import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/reflection_result.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../domain/models/ai_insight_result.dart';
import '../../domain/models/daily_mood_check_in.dart';
import 'reflection_engine.dart';

class AiInsightGenerator {
  static final AiInsightGenerator instance = AiInsightGenerator._internal();

  AiInsightGenerator._internal();

  Isar get isar => IsarDatabase.instance;

  Future<AiInsightResult> generateInsight({
    required ReflectionResult currentReflection,
    required MoodFeatureVector latestVector,
    required ReflectionFollowUp? activeFollowUp,
  }) async {
    // Determine History and Gates
    int historyDaysAvailable = await isar.dailyMoodCheckIns.count();
    bool trendAvailable = historyDaysAvailable >= 3;
    bool averageComparisonAvailable = historyDaysAvailable >= 7;

    // Map Available Signals
    bool hasMood = currentReflection.moodScore != null;
    bool hasJournal = latestVector.journalCount > 0;
    bool hasChat = latestVector.chatCount > 0;
    bool hasFollowUpContext = activeFollowUp != null && activeFollowUp.userResponse != null && activeFollowUp.userResponse!.isNotEmpty;

    Map<String, double> availableSignals = {};
    List<String> dataSources = [];

    if (hasMood) {
      availableSignals["Mood Signal"] = 20.0;
      dataSources.add("Mood Check-In");
    }
    if (hasJournal) {
      availableSignals["Journal Signal"] = 20.0;
      dataSources.add("Journal Analysis");
    }
    if (hasChat) {
      availableSignals["Chat Signal"] = 10.0;
      dataSources.add("Chat Analysis");
    }
    if (hasFollowUpContext) {
      availableSignals["User Context Signal"] = 10.0;
      dataSources.add("Follow-Up Context");
    }

    // Default Fallback
    if (dataSources.isEmpty) {
      return AiInsightResult.fallback();
    }

    // Previous Reflection for Burnout Trend
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    final previousVector = await isar.moodFeatureVectors
        .filter()
        .dateLessThan(startOfDay)
        .sortByDateDesc()
        .findFirst();

    ReflectionResult? previousReflection;
    if (previousVector != null) {
      previousReflection = await ReflectionEngine.instance.getReflectionForVector(previousVector);
    }

    bool burnoutDecreasing = false;
    if (previousReflection != null) {
      burnoutDecreasing = currentReflection.burnoutScore < previousReflection.burnoutScore;
      if (trendAvailable) {
        availableSignals["Burnout Trend Signal"] = 20.0;
      }
    }

    if (averageComparisonAvailable) {
      availableSignals["Historical Trend Signal"] = 10.0;
    }

    // Averages and Trends
    double rollingMoodAvg = latestVector.rollingMoodAverage7Days ?? 3.0;
    int currentMoodScore = currentReflection.moodScore ?? 3;
    bool positiveMoodTrend = currentMoodScore > rollingMoodAvg;
    bool negativeMoodTrend = currentMoodScore < rollingMoodAvg;
    double journalSentiment = latestVector.journalSentiment ?? 0.0;

    String userContext = "";
    if (hasFollowUpContext && activeFollowUp != null) {
      userContext = activeFollowUp.userResponse!.toLowerCase();
    }

    // Generation Rules
    // Default Fallback Generation Rules
    String insight = "Continue checking in to unlock more personalized insights.";
    String observation = "Your recent activity has been analyzed.";
    String suggestion = "Keep up the consistent tracking.";
    
    List<String> factorsUsed = [];
    Map<String, double> usedSignalContributions = {};
    bool handled = false;

    void addUsedSignal(String signalName) {
      if (availableSignals.containsKey(signalName)) {
        usedSignalContributions[signalName] = availableSignals[signalName]!;
      }
    }

    // 1. Analyze current Mood
    if (!handled && hasMood) {
      if (currentMoodScore >= 4) {
        insight = "You've been having a good day today.";
        observation = "Your mood check-in shows a positive state.";
        suggestion = "Keep up the momentum and note what went well today.";
        factorsUsed.add("Positive Mood");
        addUsedSignal("Mood Signal");
        handled = true;
      } else if (currentMoodScore <= 2) {
        insight = "Things have been a bit tough today.";
        observation = "Your mood check-in shows a lower mood.";
        suggestion = "Take it easy and focus on self-care.";
        factorsUsed.add("Negative Mood");
        addUsedSignal("Mood Signal");
        handled = true;
      }
    }

    // 2. Analyze Journal Sentiment
    if (!handled && hasJournal) {
      if (journalSentiment < -0.3 || (latestVector.journalStressScore != null && latestVector.journalStressScore! > 0.6)) {
        insight = "Recent reflections suggest some stress or challenges.";
        observation = "Journal entries contain language associated with stress.";
        suggestion = "Acknowledge these feelings and try a brief relaxation exercise.";
        factorsUsed.add("Journal Stress/Negative Sentiment");
        addUsedSignal("Journal Signal");
        handled = true;
      } else if (journalSentiment > 0.3) {
        insight = "Your reflections indicate a generally positive mindset.";
        observation = "Journal entries contain uplifting linguistic patterns.";
        suggestion = "Reflect on what went well today to maintain this momentum.";
        factorsUsed.add("Positive Sentiment");
        addUsedSignal("Journal Signal");
        handled = true;
      } else if (latestVector.journalEnergyScore != null && latestVector.journalEnergyScore! < 0.3) {
        insight = "Recent reflections suggest lower energy levels than usual.";
        observation = "Journal linguistic patterns indicate fatigue or low energy.";
        suggestion = "Focus on rest and limit strenuous activities today.";
        factorsUsed.add("Low Energy Score");
        addUsedSignal("Journal Signal");
        handled = true;
      }
    }

    // 3. Analyze Chat Sentiment
    if (!handled && hasChat) {
      double chatSentimentScore = latestVector.chatSentiment ?? 0.0;
      if (chatSentimentScore < -0.3) {
        insight = "Recent entries suggest elevated stress and mental fatigue.";
        observation = "Negative emotional indicators were detected in recent activity.";
        suggestion = "Consider taking breaks and monitoring stress levels.";
        factorsUsed.add("Negative Chat Sentiment");
        addUsedSignal("Chat Signal");
        handled = true;
      } else if (chatSentimentScore > 0.3) {
        insight = "Chat interactions reflect a positive outlook.";
        observation = "Positive emotional indicators were detected in recent chats.";
        suggestion = "Keep engaging in uplifting conversations.";
        factorsUsed.add("Positive Chat Sentiment");
        addUsedSignal("Chat Signal");
        handled = true;
      }
    }

    // 4. Analyze Burnout Score
    if (!handled) {
      if (currentReflection.burnoutScore > 70) {
        insight = "Stress indicators remain elevated. Prioritize recovery where possible.";
        observation = "Journal and mood indicators point to consistent high stress.";
        suggestion = "Take a short break and practice deep breathing.";
        factorsUsed.add("Burnout Risk");
        if (hasJournal) addUsedSignal("Journal Signal");
        if (hasMood) addUsedSignal("Mood Signal");
        handled = true;
      } else if (previousReflection != null && burnoutDecreasing && trendAvailable) {
        insight = "Recent patterns suggest gradual recovery from stress.";
        observation = "Your burnout risk has decreased compared to previous reflections.";
        suggestion = "Maintain the routines that are helping you recover.";
        factorsUsed.add("Burnout Trend");
        addUsedSignal("Burnout Trend Signal");
        handled = true;
      }
    }

    // Long-Term Trend Fallback (Only if 7+ days)
    if (!handled && averageComparisonAvailable && hasMood) {
      if (positiveMoodTrend) {
        insight = "Your mood appears more stable compared to recent check-ins.";
        observation = "Your mood is tracking above your 7-day average.";
        suggestion = "Consider continuing activities that have recently improved your mood.";
        factorsUsed.add("Long-Term Trend");
        addUsedSignal("Historical Trend Signal");
        addUsedSignal("Mood Signal");
        handled = true;
      } else if (negativeMoodTrend) {
        insight = "Recent check-ins suggest a decline in mood consistency.";
        observation = "Your current mood is tracking below your 7-day average.";
        suggestion = "Consider a brief mindfulness exercise to reset.";
        factorsUsed.add("Long-Term Trend");
        addUsedSignal("Historical Trend Signal");
        addUsedSignal("Mood Signal");
        handled = true;
      }
    }

    if (factorsUsed.isEmpty) {
      factorsUsed.addAll(dataSources.take(2));
      if (dataSources.contains("Chat Analysis")) addUsedSignal("Chat Signal");
      if (dataSources.contains("Mood Check-In")) addUsedSignal("Mood Signal");
      if (dataSources.contains("Journal Analysis")) addUsedSignal("Journal Signal");
      if (dataSources.contains("Follow-Up Context")) addUsedSignal("User Context Signal");
    }

    double confidence = 20.0; // Base Confidence = 20
    for (final val in usedSignalContributions.values) {
      confidence += val;
    }
    if (confidence > 90.0) confidence = 90.0;

    String detailedReflectionText = "Based on the integration of your Phase 1 wellness metrics, this reflection summarizes the patterns across your recent activities.";
    if (!trendAvailable) {
      detailedReflectionText += "\n\nTrend Note: Building your personal baseline. More data is needed for trend analysis.";
    }

    return AiInsightResult(
      homeCardInsight: insight,
      detailedReflection: detailedReflectionText,
      observation: observation,
      suggestion: suggestion,
      confidence: confidence,
      factorsUsed: factorsUsed,
      generatedAt: DateTime.now(),
      historyDaysAvailable: historyDaysAvailable,
      trendAvailable: trendAvailable,
      averageComparisonAvailable: averageComparisonAvailable,
      signalsUsed: usedSignalContributions.keys.toList(),
      availableSignals: availableSignals.keys.toList(),
      confidenceContributions: usedSignalContributions,
    );
  }
}
