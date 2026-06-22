import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/mood_log.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/reflection_result.dart';
import '../../domain/models/reflection_follow_up.dart';
import 'feature_pipeline.dart';

class ReflectionEngine {
  static final ReflectionEngine instance = ReflectionEngine._internal();

  ReflectionEngine._internal();

  Isar get isar => IsarDatabase.instance;

  Future<ReflectionResult> getLatestReflection() async {
    // 1. Get the latest feature vector
    final vector = await FeaturePipeline.instance.getLatestVector();
    
    // 2. Get today's manual mood if it exists
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final todaysMood = await isar.moodLogs
        .filter()
        .createdAtBetween(startOfDay, endOfDay)
        .sortByCreatedAtDesc()
        .findFirst();

    final todayMidnight = DateTime.utc(today.year, today.month, today.day);
    final todayCheckIn = await isar.dailyMoodCheckIns
        .where()
        .dateEqualTo(todayMidnight)
        .findFirst();

    // Fetch the latest resolved reflection follow-up with user response context
    String? userContext;
    try {
      final resolvedFollowUp = await isar.reflectionFollowUps
          .where()
          .filter()
          .resolvedEqualTo(true)
          .and()
          .userResponseIsNotNull()
          .sortByResolvedAtDesc()
          .findFirst();
      userContext = resolvedFollowUp?.userResponse;
    } catch (_) {
      userContext = null;
    }

    // 3. If no vector exists, create a default/fallback vector and calculate dynamically.
    final targetVector = vector ?? (MoodFeatureVector()
      ..date = startOfDay
      ..createdAt = DateTime.now()
      ..featureVersion = '1.0.0'
      ..hourOfDay = DateTime.now().hour
      ..dayOfWeek = startOfDay.weekday
      ..journalCount = 0
      ..chatCount = 0
      ..timeSpentMinutes = 0
      ..sessionCount = 0
      ..interventionCount = 0
      ..manualMoodExists = false);

    return _generateFromVector(
      targetVector, 
      todaysMood, 
      todayCheckIn, 
      userContext: userContext,
    );
  }

  ReflectionResult _generateFromVector(
    MoodFeatureVector vector, 
    MoodLog? todaysMood, 
    DailyMoodCheckIn? todayCheckIn, 
    {String? userContext}
  ) {
    // Determine the current mood and current mood value.
    String? currentMood = vector.currentMood;
    double? currentMoodValue = vector.currentMoodValue;
    
    if (currentMood == null && todayCheckIn != null) {
      currentMood = todayCheckIn.moodLevel;
      switch (todayCheckIn.moodLevel) {
        case 'GREAT':
          currentMoodValue = 5.0;
          break;
        case 'GOOD':
          currentMoodValue = 4.0;
          break;
        case 'OKAY':
          currentMoodValue = 3.0;
          break;
        case 'LOW':
          currentMoodValue = 2.0;
          break;
        case 'STRUGGLING':
          currentMoodValue = 1.0;
          break;
        default:
          currentMoodValue = 3.0;
      }
    }
    
    if (currentMood == null && todaysMood != null) {
      currentMoodValue = todaysMood.score.toDouble();
      switch (todaysMood.score) {
        case 5:
          currentMood = 'GREAT';
          break;
        case 4:
          currentMood = 'GOOD';
          break;
        case 3:
          currentMood = 'OKAY';
          break;
        case 2:
          currentMood = 'LOW';
          break;
        case 1:
          currentMood = 'STRUGGLING';
          break;
        default:
          currentMood = 'OKAY';
      }
    }
    
    if (currentMood == null && vector.actualMood != null) {
      currentMoodValue = vector.actualMood!.toDouble();
      switch (vector.actualMood) {
        case 5:
          currentMood = 'GREAT';
          break;
        case 4:
          currentMood = 'GOOD';
          break;
        case 3:
          currentMood = 'OKAY';
          break;
        case 2:
          currentMood = 'LOW';
          break;
        case 1:
          currentMood = 'STRUGGLING';
          break;
        default:
          currentMood = 'OKAY';
      }
    }

    // 1. Journal Analysis (40%): derived from journal sentiment, stress score, and energy score.
    double sentimentVal = vector.journalSentiment ?? 0.0;
    double stressVal = vector.journalStressScore ?? 0.5;
    double energyVal = vector.journalEnergyScore ?? 0.5;

    double rawJournalImpact = (
      ((1.0 - sentimentVal) / 2.0 * 100.0) +
      (stressVal * 100.0) +
      ((1.0 - energyVal) * 100.0)
    ) / 3.0;

    // 2. Mood Trend (10%): derived from rolling 7-day average.
    double rollingAvg = vector.rollingMoodAverage7Days ?? 3.0; // 1-5 scale
    double rawTrendImpact = ((5.0 - rollingAvg) / 4.0 * 100.0);

    // 3. Chat Analysis (15%): derived from chat sentiment.
    double chatSentimentVal = vector.chatCount > 0 ? (vector.chatSentiment ?? 0.0) : 0.0;
    double rawChatImpact = ((1.0 - chatSentimentVal) / 2.0) * 100.0;

    // 4. Activity Pattern (5%): derived from session count, time spent, and interventions.
    double sessionScore = (1.0 - (vector.sessionCount / 3.0).clamp(0.0, 1.0)) * 100.0;
    double timeScore = (1.0 - (vector.timeSpentMinutes / 15.0).clamp(0.0, 1.0)) * 100.0;
    double interventionScore = (1.0 - (vector.interventionCount / 2.0).clamp(0.0, 1.0)) * 100.0;

    double rawActivityImpact = (sessionScore + timeScore + interventionScore) / 3.0;

    // Calculate Burnout Before Mood Adjustment: sum of non-mood components normalized by their total weight (0.70)
    double burnoutBeforeMoodAdjustment = (
      (rawJournalImpact * 0.40) +
      (rawChatImpact * 0.15) +
      (rawTrendImpact * 0.10) +
      (rawActivityImpact * 0.05)
    ) / 0.70;

    // Calculate Mood Contribution:
    // GREAT: -15, GOOD: -7, OKAY: 0, LOW: +10, STRUGGLING: +20
    double moodContribution = 0.0;
    if (currentMood != null) {
      switch (currentMood) {
        case 'GREAT':
          moodContribution = -15.0;
          break;
        case 'GOOD':
          moodContribution = -7.0;
          break;
        case 'OKAY':
          moodContribution = 0.0;
          break;
        case 'LOW':
          moodContribution = 10.0;
          break;
        case 'STRUGGLING':
          moodContribution = 20.0;
          break;
      }
    }

    double burnoutAfterMoodAdjustment = (burnoutBeforeMoodAdjustment + moodContribution).clamp(0.0, 100.0);
    int finalScore = burnoutAfterMoodAdjustment.round();

    String level;
    String insight;
    String suggestedAction;
    String burnoutExplanation;
    List<String> factors = [];

    // Assign level, factors, insight, and explanation
    if (finalScore < 35) {
      level = 'LOW';
      insight = "Your reflection suggests stable energy and healthy engagement today.";
      suggestedAction = "Continue evening journaling to sustain your positive balance.";
      factors.add("Consistent Balance");
    } else if (finalScore < 70) {
      level = 'MODERATE';
      insight = "Recent indicators show fluctuating mood, stress, or app engagement.";
      suggestedAction = "Go for a short walk and take a brief break.";
      factors.add("Mixed Signals");
    } else {
      level = 'HIGH';
      insight = "Indicators point to high stress, low mood, or very low activity.";
      suggestedAction = "Take a 2-minute guided breathing exercise.";
      factors.add("High Stress");
      factors.add("Low Activity");
    }

    burnoutExplanation = "Your burnout score is computed dynamically based on on-device patterns: journal sentiment, manual mood checks, and app activity.";

    // Dynamically adjust reflection if user context response is available
    if (userContext != null && userContext.trim().isNotEmpty) {
      final normalizedContext = userContext.toLowerCase();
      
      if (normalizedContext.contains("project") ||
          normalizedContext.contains("work") ||
          normalizedContext.contains("assignment") ||
          normalizedContext.contains("study") ||
          normalizedContext.contains("exam") ||
          normalizedContext.contains("test") ||
          normalizedContext.contains("task") ||
          normalizedContext.contains("deadline")) {
        insight = "Earlier entries suggested high stress, but recent updates indicate relief after completing an important task.";
        burnoutExplanation = "Your burnout indicators are balanced by your positive follow-up context: '$userContext'.";
        suggestedAction = "Acknowledge the effort you put in, celebrate completing your project, and take a moment to rest.";
      } else if (normalizedContext.contains("sleep") ||
                 normalizedContext.contains("rest") ||
                 normalizedContext.contains("nap") ||
                 normalizedContext.contains("bed") ||
                 normalizedContext.contains("tired")) {
        insight = "Earlier entries suggested low energy or stress, but your follow-up indicates focus on rest and recovery.";
        burnoutExplanation = "Exhaustion levels are mitigated by active focus on rest and recovery: '$userContext'.";
        suggestedAction = "Keep prioritizing rest tonight. Avoid screens before sleeping.";
      } else if (normalizedContext.contains("friend") ||
                 normalizedContext.contains("family") ||
                 normalizedContext.contains("talk") ||
                 normalizedContext.contains("chat") ||
                 normalizedContext.contains("call") ||
                 normalizedContext.contains("met") ||
                 normalizedContext.contains("social") ||
                 normalizedContext.contains("out")) {
        insight = "Earlier indicators pointed to a tough day, but social support and connection have brought positive relief.";
        burnoutExplanation = "Burnout signals are mitigated by supportive social interaction: '$userContext'.";
        suggestedAction = "Continue nurturing supportive relationships that lift your spirits.";
      } else if (normalizedContext.contains("walk") ||
                 normalizedContext.contains("run") ||
                 normalizedContext.contains("gym") ||
                 normalizedContext.contains("workout") ||
                 normalizedContext.contains("exercise")) {
        insight = "Physical activity and stepping away have helped ease earlier tension and stress.";
        burnoutExplanation = "Activity levels are positive, balancing out passive stress patterns: '$userContext'.";
        suggestedAction = "Keep incorporating movement into your routine as a healthy stress release.";
      } else {
        insight = "Earlier entries suggested a different pattern, but your recent update indicates: $userContext.";
        burnoutExplanation = "Your wellness model has been updated with the context: '$userContext'. Mood check-in is the primary source of truth.";
        suggestedAction = "Reflect on this positive change and keep prioritizing your well-being.";
      }

      factors.add("Follow-Up Context");
    }

    // Add factors based on actual scores
    if (vector.journalCount > 0 && (vector.journalSentiment ?? 0) > 0.3) {
      factors.add("Positive Journals");
    }
    if (vector.journalCount > 0 && (vector.journalSentiment ?? 0) < -0.3) {
      factors.add("Negative Journal Tone");
    }
    if (vector.journalStressScore != null && vector.journalStressScore! > 0.5) {
      factors.add("Elevated Stress");
    }
    if (vector.journalEnergyScore != null && vector.journalEnergyScore! < 0.3) {
      factors.add("Low Energy");
    }
    if (vector.chatCount > 0 && (vector.chatSentiment ?? 0) > 0.3) {
      factors.add("Supportive Conversations");
    }
    if (vector.journalCount > 2) {
      factors.add("Consistent Journaling");
    }

    // Keep factors concise (max 4)
    factors = factors.take(4).toList();

    // Debug confidence calculation
    double conf = 50.0;
    if (vector.journalCount > 0) conf += 20;
    if (vector.chatCount > 0) conf += 15;
    if (vector.manualMoodExists || todaysMood != null || todayCheckIn != null) conf += 15;

    // Contribution strings show actual numeric values
    String jContrib = vector.journalCount > 0
        ? "sentiment: ${(vector.journalSentiment ?? 0.0).toStringAsFixed(2)}, "
          "stress: ${(vector.journalStressScore ?? 0.5).toStringAsFixed(2)}, "
          "energy: ${(vector.journalEnergyScore ?? 0.5).toStringAsFixed(2)}"
        : "None";
    String cContrib = vector.chatCount > 0 ? "sentiment: ${(vector.chatSentiment ?? 0.0).toStringAsFixed(2)}" : "None";
    String tContrib = "Avg ${rollingAvg.toStringAsFixed(1)}";

    return ReflectionResult(
      burnoutScore: finalScore,
      burnoutLevel: level,
      insight: insight,
      contributingFactors: factors,
      suggestedAction: suggestedAction,
      generatedAt: DateTime.now(),
      moodScore: currentMoodValue?.round() ?? vector.actualMood ?? todaysMood?.score,
      confidence: conf.clamp(0.0, 100.0),
      journalContribution: jContrib,
      chatContribution: cContrib,
      trendContribution: tContrib,
      rawJournalImpact: rawJournalImpact,
      rawChatImpact: rawChatImpact,
      rawTrendImpact: rawTrendImpact,
      rawActivityImpact: rawActivityImpact,
      currentMood: currentMood,
      moodWeight: 0.30,
      moodContribution: moodContribution,
      burnoutBeforeMoodAdjustment: burnoutBeforeMoodAdjustment,
      burnoutAfterMoodAdjustment: burnoutAfterMoodAdjustment,
      burnoutExplanation: burnoutExplanation,
    );
  }

  // Used for specific Journal Reflections (offline generation based on vector alone)
  Future<ReflectionResult> getReflectionForVector(MoodFeatureVector vector) async {
    String? userContext;
    try {
      final resolvedFollowUp = await isar.reflectionFollowUps
          .where()
          .filter()
          .resolvedEqualTo(true)
          .and()
          .userResponseIsNotNull()
          .sortByResolvedAtDesc()
          .findFirst();
      userContext = resolvedFollowUp?.userResponse;
    } catch (_) {
      userContext = null;
    }
    return _generateFromVector(
      vector, 
      null, 
      null, 
      userContext: userContext,
    );
  }
}
