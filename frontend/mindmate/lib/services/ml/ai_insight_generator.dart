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
    // Generation Rules
    String insight = "Continue checking in to unlock more personalized insights.";
    String observation = "Your recent activity has been analyzed.";
    String suggestion = "Keep up the consistent tracking.";
    
    List<String> factorsUsed = [];
    Map<String, double> usedSignalContributions = {};
    List<String> acceptanceReasons = [];
    List<String> rejectionReasons = [];
    bool handled = false;

    void addUsedSignal(String signalName, String reason) {
      if (availableSignals.containsKey(signalName) && !usedSignalContributions.containsKey(signalName)) {
        usedSignalContributions[signalName] = availableSignals[signalName]!;
        acceptanceReasons.add("$signalName: ACCEPTED - $reason");
      }
    }

    void rejectSignal(String signalName, String reason) {
      if (!usedSignalContributions.containsKey(signalName)) {
        rejectionReasons.add("$signalName: REJECTED - $reason");
      }
    }

    // Identify conditions
    bool isBurnoutHigh = currentReflection.burnoutScore > 70;
    bool isBurnoutRecovering = previousReflection != null && burnoutDecreasing && trendAvailable;

    double chatSentimentScore = latestVector.chatSentiment ?? 0.0;
    bool chatNegative = hasChat && chatSentimentScore < -0.3;
    bool chatPositive = hasChat && chatSentimentScore > 0.3;

    double journalEnergyScore = latestVector.journalEnergyScore ?? 0.5;
    double journalStressScore = latestVector.journalStressScore ?? 0.0;
    bool journalNegative = hasJournal && (journalSentiment < -0.3 || journalStressScore > 0.6);
    bool journalPositive = hasJournal && journalSentiment > 0.3;
    bool journalLowEnergy = hasJournal && journalEnergyScore < 0.3;

    bool moodLow = hasMood && currentMoodScore <= 2;
    bool moodHigh = hasMood && currentMoodScore >= 4;

    // 1. High Burnout takes precedence
    if (!handled && isBurnoutHigh) {
      insight = "Stress indicators remain elevated. Prioritize recovery where possible.";
      observation = "Journal and mood indicators point to consistent high stress.";
      suggestion = "Take a short break and practice deep breathing.";
      factorsUsed.add("Burnout Risk");
      if (hasJournal) addUsedSignal("Journal Signal", "Burnout risk requires journal context.");
      if (hasMood) addUsedSignal("Mood Signal", "Mood check-ins indicate sustained stress.");
      if (hasChat) addUsedSignal("Chat Signal", "Chat activity reflects elevated stress levels.");
      handled = true;
    }

    // 2. Multi-source Negative Indicators (Mood doesn't override Journal/Chat)
    bool multiNegative = (journalNegative && chatNegative) || 
                         (journalNegative && moodLow) || 
                         (chatNegative && moodLow) ||
                         (journalNegative && journalLowEnergy); // strong combination

    if (!handled && multiNegative) {
      insight = "Recent journal and chat activity suggest elevated stress and mental fatigue.";
      observation = "Negative emotional indicators were detected across multiple sources.";
      suggestion = "Consider taking breaks and monitoring stress levels.";
      factorsUsed.add("Multi-source Negative Indicators");
      if (journalNegative) {
        addUsedSignal("Journal Signal", "Journal sentiment is below threshold or stress is high.");
        factorsUsed.add("Journal Analysis");
      }
      if (chatNegative) {
        addUsedSignal("Chat Signal", "Chat sentiment is below threshold.");
        factorsUsed.add("Chat Analysis");
      }
      if (moodLow) {
        addUsedSignal("Mood Signal", "Mood score is low, reinforcing negative trend.");
        factorsUsed.add("Mood Analysis");
      }
      handled = true;
    }

    // 3. Single Source Negative Indicators
    if (!handled && journalNegative) {
      insight = "Recent reflections suggest some stress or challenges.";
      observation = "Journal entries contain language associated with stress.";
      suggestion = "Acknowledge these feelings and try a brief relaxation exercise.";
      factorsUsed.add("Journal Stress/Negative Sentiment");
      factorsUsed.add("Journal Analysis");
      addUsedSignal("Journal Signal", "Journal sentiment is below threshold or stress is high.");
      handled = true;
    }

    if (!handled && chatNegative) {
      insight = "Recent entries suggest elevated stress and mental fatigue.";
      observation = "Negative emotional indicators were detected in recent activity.";
      suggestion = "Consider taking breaks and monitoring stress levels.";
      factorsUsed.add("Negative Chat Sentiment");
      factorsUsed.add("Chat Analysis");
      addUsedSignal("Chat Signal", "Chat sentiment is below threshold.");
      handled = true;
    }

    if (!handled && journalLowEnergy) {
      insight = "Recent reflections suggest lower energy levels than usual.";
      observation = "Journal linguistic patterns indicate fatigue or low energy.";
      suggestion = "Focus on rest and limit strenuous activities today.";
      factorsUsed.add("Low Energy Score");
      factorsUsed.add("Journal Analysis");
      addUsedSignal("Journal Signal", "Energy score is critically low.");
      handled = true;
    }

    if (!handled && moodLow) {
      insight = "Things have been a bit tough today.";
      observation = "Your mood check-in shows a lower mood.";
      suggestion = "Take it easy and focus on self-care.";
      factorsUsed.add("Negative Mood");
      factorsUsed.add("Mood Analysis");
      addUsedSignal("Mood Signal", "Mood score is low.");
      handled = true;
    }

    // 4. Positive Indicators
    if (!handled && journalPositive) {
      insight = "Your reflections indicate a generally positive mindset.";
      observation = "Journal entries contain uplifting linguistic patterns.";
      suggestion = "Reflect on what went well today to maintain this momentum.";
      factorsUsed.add("Positive Sentiment");
      addUsedSignal("Journal Signal", "Journal sentiment is highly positive.");
      handled = true;
    }

    if (!handled && chatPositive) {
      insight = "Chat interactions reflect a positive outlook.";
      observation = "Positive emotional indicators were detected in recent chats.";
      suggestion = "Keep engaging in uplifting conversations.";
      factorsUsed.add("Positive Chat Sentiment");
      addUsedSignal("Chat Signal", "Chat sentiment is highly positive.");
      handled = true;
    }

    if (!handled && moodHigh) {
      insight = "You've been having a good day today.";
      observation = "Your mood check-in shows a positive state.";
      suggestion = "Keep up the momentum and note what went well today.";
      factorsUsed.add("Positive Mood");
      addUsedSignal("Mood Signal", "Mood score is high.");
      handled = true;
    }

    // 5. Burnout Recovery
    if (!handled && isBurnoutRecovering) {
      insight = "Recent patterns suggest gradual recovery from stress.";
      observation = "Your burnout risk has decreased compared to previous reflections.";
      suggestion = "Maintain the routines that are helping you recover.";
      factorsUsed.add("Burnout Trend");
      addUsedSignal("Burnout Trend Signal", "Burnout score shows a recovering trend.");
      handled = true;
    }

    // 6. Long-Term Trend Fallback
    if (!handled && averageComparisonAvailable && hasMood) {
      if (positiveMoodTrend) {
        insight = "Your mood appears more stable compared to recent check-ins.";
        observation = "Your mood is tracking above your 7-day average.";
        suggestion = "Consider continuing activities that have recently improved your mood.";
        factorsUsed.add("Long-Term Trend");
        addUsedSignal("Historical Trend Signal", "Mood is trending positively above average.");
        addUsedSignal("Mood Signal", "Current mood validates the trend.");
        handled = true;
      } else if (negativeMoodTrend) {
        insight = "Recent check-ins suggest a decline in mood consistency.";
        observation = "Your current mood is tracking below your 7-day average.";
        suggestion = "Consider a brief mindfulness exercise to reset.";
        factorsUsed.add("Long-Term Trend");
        addUsedSignal("Historical Trend Signal", "Mood is trending negatively below average.");
        addUsedSignal("Mood Signal", "Current mood validates the trend.");
        handled = true;
      }
    }

    // Default processing for unhandled signals to log rejection reasons
    if (hasMood && !usedSignalContributions.containsKey("Mood Signal")) {
      rejectSignal("Mood Signal", "Mood within neutral range or overridden by higher priority signals.");
    }
    if (hasJournal && !usedSignalContributions.containsKey("Journal Signal")) {
      rejectSignal("Journal Signal", "Sentiment and stress thresholds not met, or overridden.");
    }
    if (hasChat && !usedSignalContributions.containsKey("Chat Signal")) {
      rejectSignal("Chat Signal", "No qualifying emotional indicators, or overridden.");
    }

    if (factorsUsed.isEmpty) {
      factorsUsed.addAll(dataSources.take(2));
      if (dataSources.contains("Chat Analysis")) addUsedSignal("Chat Signal", "Fallback source inclusion.");
      if (dataSources.contains("Mood Check-In")) addUsedSignal("Mood Signal", "Fallback source inclusion.");
      if (dataSources.contains("Journal Analysis")) addUsedSignal("Journal Signal", "Fallback source inclusion.");
      if (dataSources.contains("Follow-Up Context")) addUsedSignal("User Context Signal", "Fallback source inclusion.");
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
      signalAcceptanceReasons: acceptanceReasons,
      signalRejectionReasons: rejectionReasons,
    );
  }
}
