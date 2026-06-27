import 'package:flutter/foundation.dart';
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

  AiInsightResult? _cachedInsight;
  DateTime? _cacheDate;

  AiInsightGenerator._internal();

  Isar get isar => IsarDatabase.instance;

  void invalidateCache() {
    _cachedInsight = null;
    _cacheDate = null;
  }

  Future<AiInsightResult> generateInsight({
    required ReflectionResult currentReflection,
    required MoodFeatureVector latestVector,
    required ReflectionFollowUp? activeFollowUp,
    bool forceRegenerate = false,
  }) async {
    final today = DateTime.now();
    final isSameDay = _cacheDate != null && 
        _cacheDate!.year == today.year && 
        _cacheDate!.month == today.month && 
        _cacheDate!.day == today.day;

    if (!forceRegenerate && _cachedInsight != null && isSameDay) {
      debugPrint("=== AI INSIGHT DEBUG ===");
      debugPrint("Insight generation time: ${_cachedInsight!.generatedAt}");
      debugPrint("Insight source: Memory Cache");
      debugPrint("Insight date: $_cacheDate");
      debugPrint("Loaded from cache: true");
      debugPrint("========================");
      return _cachedInsight!;
    }
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

    // 4. Comprehensive Positive Insights
    bool isOverallPositive = moodHigh || journalPositive || chatPositive || isBurnoutRecovering || positiveMoodTrend;
    if (!handled && isOverallPositive) {
      List<String> strongEvidence = [];
      if (isBurnoutRecovering) strongEvidence.add("improving burnout");
      if (positiveMoodTrend) strongEvidence.add("stable mood");
      if (journalPositive) strongEvidence.add("positive reflections");
      if (chatPositive) strongEvidence.add("positive conversations");
      if (latestVector.journalCount >= 2 || currentReflection.contributingFactors.contains("Consistent Journaling")) strongEvidence.add("consistent journaling");
      
      bool mentionsSleep = false;
      bool mentionsSocial = false;
      if (hasFollowUpContext && activeFollowUp != null) {
        final ctx = activeFollowUp.userResponse!.toLowerCase();
        mentionsSocial = ctx.contains("friend") || ctx.contains("family") || ctx.contains("social") || ctx.contains("talk") || ctx.contains("chat") || ctx.contains("call") || ctx.contains("met") || ctx.contains("out");
        mentionsSleep = ctx.contains("sleep") || ctx.contains("rest") || ctx.contains("nap") || ctx.contains("bed");
      }
      if (mentionsSleep) strongEvidence.add("better sleep habits");
      if (mentionsSocial) strongEvidence.add("social interactions");

      if (isBurnoutRecovering && journalPositive) {
         insight = "Your burnout score has gradually decreased while positive reflections have become more frequent. Maintaining these habits appears to be supporting your wellbeing.";
         observation = "Burnout has decreased over the past week while positive journal entries have increased.";
      } else if (positiveMoodTrend && mentionsSocial) {
         insight = "Your mood has remained stable over the last few days, and recent journal entries suggest that social interactions have been helping your recovery.";
         observation = "Social interactions and stable mood are contributing to your current progress.";
      } else if (mentionsSleep && strongEvidence.contains("consistent journaling")) {
         insight = "Your recovery milestones suggest that consistent journaling and better sleep habits are contributing to your current progress.";
         observation = "Consistent journaling and better sleep habits are supporting your wellbeing.";
      } else if (chatPositive && journalPositive) {
         insight = "Recent conversations and journal entries indicate improved emotional balance compared with earlier this week.";
         observation = "Positive patterns detected across multiple sources.";
      } else if (isBurnoutRecovering || positiveMoodTrend) {
         insight = "Your emotional wellbeing appears more stable than last week. Positive routines and lower stress signals are becoming more consistent.";
         observation = "Lower stress signals and stable patterns are becoming more consistent.";
      } else {
         String evidenceText = strongEvidence.isNotEmpty ? strongEvidence.join(" and ") : "positive routines";
         insight = "Your wellbeing appears to be improving. Evidence suggests that $evidenceText ${strongEvidence.length > 1 ? 'are' : 'is'} contributing to your current progress.";
         observation = "Analysis of your recent activities indicates sustained positive patterns.";
      }
      
      if (isBurnoutRecovering) {
        factorsUsed.add("Burnout Trend");
        addUsedSignal("Burnout Trend Signal", "Burnout score shows a recovering trend.");
      }
      if (positiveMoodTrend || moodHigh) {
        factorsUsed.add(positiveMoodTrend ? "Long-Term Trend" : "Positive Mood");
        if (positiveMoodTrend) addUsedSignal("Historical Trend Signal", "Mood is trending positively above average.");
        addUsedSignal("Mood Signal", "Current mood validates the positive state.");
      }
      if (journalPositive) {
        factorsUsed.add("Positive Sentiment");
        addUsedSignal("Journal Signal", "Journal sentiment is highly positive.");
      }
      if (chatPositive) {
        factorsUsed.add("Positive Chat Sentiment");
        addUsedSignal("Chat Signal", "Chat sentiment is highly positive.");
      }
      if (mentionsSleep || mentionsSocial) {
        factorsUsed.add("Follow-Up Context");
        addUsedSignal("User Context Signal", "User mentioned beneficial activities in follow-up.");
      }
      
      suggestion = "Continue maintaining your current routines to reinforce this positive trend.";
      handled = true;
    }

    // 5. Long-Term Trend Fallback (Negative only)
    if (!handled && averageComparisonAvailable && hasMood) {
      if (negativeMoodTrend) {
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

    final result = AiInsightResult(
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

    _cachedInsight = result;
    _cacheDate = today;

    debugPrint("=== AI INSIGHT DEBUG ===");
    debugPrint("Insight generation time: ${result.generatedAt}");
    debugPrint("Insight source: Generator Engine");
    debugPrint("Insight date: $_cacheDate");
    debugPrint("Loaded from cache: false (Regenerated)");
    debugPrint("========================");

    return result;
  }
}
