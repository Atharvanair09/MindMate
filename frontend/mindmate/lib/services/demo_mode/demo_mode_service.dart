import 'dart:math';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../data/database/isar_database.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/burnout_forecast.dart';
import '../../domain/models/pattern_insight.dart';
import '../../domain/models/recovery_event.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../domain/models/app_notification.dart';
import '../../domain/models/wellness_journey_summary.dart';
import '../../domain/models/mood_log.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../core/state/demo_mode_provider.dart';
import '../ml/feature_pipeline.dart';

class DemoModeService {
  final Isar _isar = IsarDatabase.instance;
  final Random _random = Random(42); // fixed seed for consistency
  
  static final DemoModeService instance = DemoModeService._internal();
  DemoModeService._internal();

  /// Toggles demo mode on/off. Generates data if it doesn't exist.
  Future<void> toggleDemoMode(BuildContext context, bool enable) async {
    final provider = Provider.of<DemoModeProvider>(context, listen: false);
    
    if (enable) {
      provider.setSeeding(true);
      final hasData = await _hasDemoData();
      if (!hasData) {
        await seedDemoData();
      }
      provider.toggleDemoMode(true);
      provider.setSeeding(false);
    } else {
      provider.toggleDemoMode(false);
    }
  }

  /// Explicitly resets demo data (deletes all, then toggles off).
  Future<void> resetDemoData(BuildContext context) async {
    final provider = Provider.of<DemoModeProvider>(context, listen: false);
    provider.setSeeding(true);
    
    // Switch to off so UI returns to normal immediately
    provider.toggleDemoMode(false);
    
    await clearDemoData();
    provider.setSeeding(false);
  }

  Future<bool> _hasDemoData() async {
    return await _isar.moodLogs.filter().isDemoDataEqualTo(true).count() > 0;
  }

  Future<void> clearDemoData() async {
    await _isar.writeTxn(() async {
      await _isar.dailyMoodCheckIns.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.journalEntrys.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.chatMessages.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.burnoutForecasts.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.patternInsights.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.recoveryEvents.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.weeklyReflections.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.appNotifications.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.wellnessJourneySummarys.filter().isDemoDataEqualTo(true).deleteAll();
      await _isar.moodLogs.filter().isDemoDataEqualTo(true).deleteAll();
    });
  }

  Future<void> seedDemoData() async {
    final now = DateTime.now();
    
    final List<DailyMoodCheckIn> moodCheckIns = [];
    final List<MoodLog> moodLogs = [];
    final List<JournalEntry> journals = [];
    final List<ChatMessage> chats = [];
    final List<BurnoutForecast> forecasts = [];
    final List<WeeklyReflection> reflections = [];
    final List<PatternInsight> patterns = [];
    final List<RecoveryEvent> recoveries = [];
    final List<AppNotification> notifications = [];
    
    final chatId = const Uuid().v4();
    
    double currentBurnout = 80.0;
    
    // Generate 30 days of data (Day -30 to Day 0)
    for (int i = 30; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final week = 4 - (i ~/ 7); // week 1 to 4
      
      // Determine daily trends based on the week
      String moodLevel;
      int moodScore;
      String journalText;
      double stressScore;
      double sentimentScore;
      
      if (week <= 1) {
        // Week 1: High stress, low mood
        moodLevel = _random.nextBool() ? 'BAD' : 'LOW';
        moodScore = moodLevel == 'BAD' ? 1 : 2;
        journalText = _getRandomJournal(1);
        stressScore = 0.8 + (_random.nextDouble() * 0.2);
        sentimentScore = -0.5 - (_random.nextDouble() * 0.5);
        currentBurnout = (currentBurnout + _random.nextDouble() * 2).clamp(0.0, 100.0);
      } else if (week == 2) {
        // Week 2: Stabilising, some conflicts
        moodLevel = _random.nextBool() ? 'LOW' : 'NEUTRAL';
        moodScore = moodLevel == 'LOW' ? 2 : 3;
        journalText = _getRandomJournal(2);
        stressScore = 0.6 + (_random.nextDouble() * 0.2);
        sentimentScore = -0.2 + (_random.nextDouble() * 0.4);
        currentBurnout = (currentBurnout - _random.nextDouble() * 2).clamp(0.0, 100.0);
      } else if (week == 3) {
        // Week 3: Improving
        moodLevel = _random.nextBool() ? 'NEUTRAL' : 'GOOD';
        moodScore = moodLevel == 'NEUTRAL' ? 3 : 4;
        journalText = _getRandomJournal(3);
        stressScore = 0.4 + (_random.nextDouble() * 0.2);
        sentimentScore = 0.2 + (_random.nextDouble() * 0.4);
        currentBurnout = (currentBurnout - _random.nextDouble() * 3).clamp(0.0, 100.0);
      } else {
        // Week 4: Good/Great
        moodLevel = _random.nextBool() ? 'GOOD' : 'GREAT';
        moodScore = moodLevel == 'GOOD' ? 4 : 5;
        journalText = _getRandomJournal(4);
        stressScore = 0.2 + (_random.nextDouble() * 0.2);
        sentimentScore = 0.6 + (_random.nextDouble() * 0.4);
        currentBurnout = (currentBurnout - _random.nextDouble() * 4).clamp(0.0, 100.0);
      }

      // 1. Mood
      moodCheckIns.add(DailyMoodCheckIn()
        ..date = DateTime.utc(date.year, date.month, date.day)
        ..moodLevel = moodLevel
        ..createdAt = date
        ..updatedAt = date
        ..source = 'manual'
        ..isDemoData = true);
        
      moodLogs.add(MoodLog()
        ..createdAt = date
        ..score = moodScore
        ..source = 'manual'
        ..reason = 'Daily check-in'
        ..confidence = 0.9
        ..isManual = true
        ..isDemoData = true);

      // 2. Journal
      journals.add(JournalEntry()
        ..createdAt = date.add(const Duration(hours: 20))
        ..updatedAt = date.add(const Duration(hours: 20))
        ..journalDate = date
        ..title = journalText.substring(0, min(20, journalText.length))
        ..content = journalText
        ..wordCount = journalText.split(' ').length
        ..sentimentScore = sentimentScore
        ..stressScore = stressScore
        ..energyScore = 0.5
        ..isDemoData = true);

      // 3. Chats (1 per day)
      chats.add(ChatMessage()
        ..conversationId = chatId
        ..role = 'user'
        ..message = _getRandomChat(week)
        ..createdAt = date.add(const Duration(hours: 21))
        ..stressScore = stressScore
        ..sentimentScore = sentimentScore
        ..emotionalIntensity = stressScore
        ..isDemoData = true);
        
      chats.add(ChatMessage()
        ..conversationId = chatId
        ..role = 'ai'
        ..message = _getAiResponse(week)
        ..createdAt = date.add(const Duration(hours: 21, minutes: 1))
        ..isDemoData = true);

      // 4. Burnout Forecast
      forecasts.add(BurnoutForecast()
        ..date = DateTime.utc(date.year, date.month, date.day)
        ..currentBurnout = currentBurnout
        ..forecastTomorrow = currentBurnout - (week * 2.0)
        ..forecast3Days = currentBurnout - (week * 3.0)
        ..forecast7Days = currentBurnout - (week * 5.0)
        ..trend = week <= 1 ? "Increasing" : (week == 2 ? "Stable" : "Decreasing")
        ..confidence = 85.0
        ..contributingSignals = ['Mood', 'Journal']
        ..historicalScores = [currentBurnout, currentBurnout + 2]
        ..generatedAt = date
        ..isDemoData = true);

      // Notifications occasionally
      if (i % 3 == 0) {
        notifications.add(AppNotification()
          ..title = week <= 2 ? 'Burnout Alert' : 'Recovery Milestone'
          ..description = week <= 2 ? 'Your stress levels are elevated.' : 'You have maintained a positive streak!'
          ..type = week <= 2 ? 'burnout_alert' : 'recovery_event'
          ..createdAt = date.add(const Duration(hours: 10))
          ..isDemoData = true);
      }
    }

    // Weekly Reflections
    for (int w = 1; w <= 4; w++) {
      final reflectionDate = now.subtract(Duration(days: (4 - w) * 7));
      reflections.add(WeeklyReflection()
        ..weekStartDate = DateTime.utc(reflectionDate.year, reflectionDate.month, reflectionDate.day - 7)
        ..weekEndDate = DateTime.utc(reflectionDate.year, reflectionDate.month, reflectionDate.day)
        ..averageMoodScore = w <= 1 ? 1.5 : (w == 2 ? 2.5 : (w == 3 ? 3.5 : 4.5))
        ..averageBurnoutScore = w <= 1 ? 80.0 : (w == 2 ? 70.0 : (w == 3 ? 55.0 : 45.0))
        ..burnoutTrend = w <= 1 ? "Increasing" : (w == 2 ? "Stable" : "Improving")
        ..moodTrend = w <= 1 ? "Declining" : (w == 2 ? "Stable" : "Improving")
        ..positiveIndicators = ['Consistent Tracking']
        ..negativeIndicators = w <= 2 ? ['High Stress'] : []
        ..keyPatterns = ['Social interaction improves mood']
        ..summary = w <= 1 ? "A tough week with high academic stress." : (w == 4 ? "A great week showing consistent improvement." : "A transitional week with some good days and bad days.")
        ..suggestion = "Keep using your coping tools."
        ..confidence = 85.0
        ..historySufficiency = "FULL"
        ..mostPositiveInfluence = "Social"
        ..mostNegativeInfluence = "Work"
        ..positiveInfluenceReason = "Helped reduce stress"
        ..negativeInfluenceReason = "Deadlines"
        ..topPositiveScore = 0.8
        ..topNegativeScore = 0.7
        ..influenceScores = []
        ..generatedAt = reflectionDate
        ..isDemoData = true);
    }
    
    // Patterns
    patterns.add(PatternInsight()
      ..patternName = "Sleep Challenges"
      ..supportingEvidence = 5
      ..associationType = "Higher Burnout"
      ..confidence = "High"
      ..description = "Poor sleep correlates with higher burnout."
      ..generatedAt = now.subtract(const Duration(days: 20))
      ..isDemoData = true);
      
    patterns.add(PatternInsight()
      ..patternName = "Social Recovery"
      ..supportingEvidence = 4
      ..associationType = "Improved Mood"
      ..confidence = "High"
      ..description = "Meeting friends consistently improves your mood."
      ..generatedAt = now.subtract(const Duration(days: 5))
      ..isDemoData = true);

    // Milestones
    recoveries.add(RecoveryEvent()
      ..startDate = now.subtract(const Duration(days: 14))
      ..endDate = now
      ..startMood = 2.0
      ..endMood = 4.5
      ..startBurnout = 75.0
      ..endBurnout = 45.0
      ..recoveryStrength = "Strong"
      ..possibleTriggers = ["Social interaction", "Better Sleep"]
      ..summary = "Burnout reduced by 30% over two weeks."
      ..generatedAt = now
      ..isDemoData = true);

    // Write all to Isar
    await _isar.writeTxn(() async {
      await _isar.dailyMoodCheckIns.putAll(moodCheckIns);
      await _isar.moodLogs.putAll(moodLogs);
      await _isar.journalEntrys.putAll(journals);
      await _isar.chatMessages.putAll(chats);
      await _isar.burnoutForecasts.putAll(forecasts);
      await _isar.weeklyReflections.putAll(reflections);
      await _isar.patternInsights.putAll(patterns);
      await _isar.recoveryEvents.putAll(recoveries);
      await _isar.appNotifications.putAll(notifications);
    });

    for (int i = 30; i >= 0; i--) {
      final date = DateTime(now.year, now.month, now.day - i);
      final vector = await FeaturePipeline.instance.builder.buildFeatureVector(date);
      await _isar.writeTxn(() async {
        await _isar.moodFeatureVectors.put(vector);
      });
    }
  }

  String _getRandomJournal(int week) {
    if (week == 1) {
      final opts = [
        "So overwhelmed with exam stress. I barely slept.",
        "Another terrible day. Too many project deadlines.",
        "I feel completely burnt out and exhausted."
      ];
      return opts[_random.nextInt(opts.length)];
    } else if (week == 2) {
      final opts = [
        "Started trying out some of the wellness plans. Felt okay.",
        "A bit better today, but still anxious about tomorrow.",
        "Slept a bit more. Mood is stable."
      ];
      return opts[_random.nextInt(opts.length)];
    } else if (week == 3) {
      final opts = [
        "Met up with some friends today! It really helped my mood.",
        "Getting back on track with my assignments. Feeling productive.",
        "Good day overall. The breathing exercises actually work."
      ];
      return opts[_random.nextInt(opts.length)];
    } else {
      final opts = [
        "Feeling great! Finished my big project and I'm so relieved.",
        "Slept amazing. I have so much energy and motivation today.",
        "Recovery is real. I feel like myself again. Confident."
      ];
      return opts[_random.nextInt(opts.length)];
    }
  }

  String _getRandomChat(int week) {
    if (week == 1) return "I can't handle this stress anymore.";
    if (week == 2) return "Do you have any advice for anxiety?";
    if (week == 3) return "I actually felt much better after writing everything down.";
    return "I've been maintaining a great mood all week!";
  }

  String _getAiResponse(int week) {
    if (week == 1) return "I'm here for you. Let's take it one step at a time.";
    if (week == 2) return "It's completely normal to feel anxious. Try this breathing exercise.";
    if (week == 3) return "That's wonderful to hear! Journaling is a powerful tool.";
    return "Amazing! I'm so proud of the progress you've made.";
  }
}
