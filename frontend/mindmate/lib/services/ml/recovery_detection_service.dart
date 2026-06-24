import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../domain/models/recovery_event.dart';
import 'reflection_engine.dart';

class RecoveryDetectionService {
  static final RecoveryDetectionService instance = RecoveryDetectionService._internal();
  RecoveryDetectionService._internal();

  Isar get isar => IsarDatabase.instance;

  Future<RecoveryEvent?> detectRecoveryEvents() async {
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startDate = endDate.subtract(const Duration(days: 3));
    
    return await detectForWindow(startDate, endDate);
  }

  Future<RecoveryEvent?> detectForWindow(DateTime startDate, DateTime endDate) async {
    final utcStart = DateTime.utc(startDate.year, startDate.month, startDate.day);
    final utcEnd = DateTime.utc(endDate.year, endDate.month, endDate.day);

    // 1. Get Moods
    final moodCheckIns = await isar.dailyMoodCheckIns
        .where()
        .dateBetween(utcStart, utcEnd)
        .sortByDate()
        .findAll();

    // 2. Get Burnout Scores
    final vectors = await isar.moodFeatureVectors
        .filter()
        .dateBetween(startDate, endDate)
        .sortByDate()
        .findAll();

    double startMood = -1;
    double endMood = -1;
    
    if (moodCheckIns.isNotEmpty) {
      startMood = _moodLevelToValue(moodCheckIns.first.moodLevel);
      endMood = _moodLevelToValue(moodCheckIns.last.moodLevel);
    }

    double startBurnout = -1;
    double endBurnout = -1;

    if (vectors.isNotEmpty) {
      try {
        final startResult = await ReflectionEngine.instance.getReflectionForVector(vectors.first);
        startBurnout = startResult.burnoutScore.toDouble();
      } catch (_) {}
      try {
        final endResult = await ReflectionEngine.instance.getReflectionForVector(vectors.last);
        endBurnout = endResult.burnoutScore.toDouble();
      } catch (_) {}
    }

    bool moodImproved = false;
    bool burnoutImproved = false;

    if (startMood != -1 && endMood != -1 && (endMood - startMood) >= 1.0) {
      moodImproved = true;
    }
    
    if (startBurnout != -1 && endBurnout != -1 && (startBurnout - endBurnout) >= 10.0) {
      burnoutImproved = true;
    }

    if (!moodImproved && !burnoutImproved) {
      return null; // No recovery detected
    }

    // Determine strength
    String strength = "Moderate";
    if ((moodImproved && (endMood - startMood) >= 2.0) || 
        (burnoutImproved && (startBurnout - endBurnout) >= 20.0)) {
      strength = "Strong";
    }

    // Identify Triggers
    List<String> triggers = await _identifyTriggers(startDate, endDate);

    // Avoid duplicate events in same day
    final todayMidnight = DateTime(endDate.year, endDate.month, endDate.day);
    final existingEvent = await isar.recoveryEvents
        .filter()
        .endDateGreaterThan(todayMidnight)
        .findFirst();

    if (existingEvent != null) {
      return existingEvent; // Already logged
    }

    String summary = "Recovery detected";
    if (moodImproved && burnoutImproved) {
      summary = "Significant improvement in both mood and burnout levels.";
    } else if (moodImproved) {
      summary = "Mood improved significantly over the last 3 days.";
    } else if (burnoutImproved) {
      summary = "Burnout risk decreased notably over the last 3 days.";
    }

    final event = RecoveryEvent()
      ..startDate = startDate
      ..endDate = endDate
      ..startMood = startMood
      ..endMood = endMood
      ..startBurnout = startBurnout
      ..endBurnout = endBurnout
      ..recoveryStrength = strength
      ..possibleTriggers = triggers
      ..summary = summary
      ..generatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.recoveryEvents.put(event);
    });

    debugPrint('[RecoveryDetectionService] Recovery Event Detected. Strength: $strength');
    return event;
  }

  Future<List<String>> _identifyTriggers(DateTime start, DateTime end) async {
    List<String> triggers = [];

    // Journals
    final journals = await isar.journalEntrys
        .filter()
        .isDeletedEqualTo(false)
        .and()
        .journalDateBetween(start, end)
        .findAll();

    bool positiveJournal = false;
    bool socialMention = false;
    bool reducedStress = false;

    for (final j in journals) {
      if ((j.sentimentScore ?? 0) > 0.3) positiveJournal = true;
      if ((j.stressScore ?? 1.0) < 0.4) reducedStress = true;
      
      final content = j.content.toLowerCase();
      if (content.contains('friend') || content.contains('family') || content.contains('social') || content.contains('met')) {
        socialMention = true;
      }
    }

    if (positiveJournal) triggers.add('Positive journal entries');
    if (reducedStress) triggers.add('Reduced stress indicators');
    if (socialMention) triggers.add('Social interaction');

    // Chats
    final chats = await isar.chatMessages
        .filter()
        .roleEqualTo('user')
        .and()
        .createdAtBetween(start, end)
        .findAll();

    if (chats.any((c) => (c.sentimentScore ?? 0) > 0.3)) {
      triggers.add('Positive chats');
    }

    // Follow ups
    final followUps = await isar.reflectionFollowUps
        .filter()
        .createdAtBetween(start, end)
        .findAll();

    if (followUps.any((f) => f.resolved)) {
      triggers.add('Resolved conflicts');
    }

    if (triggers.isEmpty) {
      triggers.add('Time and rest');
    }

    return triggers;
  }

  double _moodLevelToValue(String level) {
    switch (level) {
      case 'GREAT': return 5.0;
      case 'GOOD': return 4.0;
      case 'OKAY': return 3.0;
      case 'LOW': return 2.0;
      case 'STRUGGLING': return 1.0;
      default: return 3.0;
    }
  }

  String moodValueToLevel(double val) {
    if (val >= 5) return 'GREAT';
    if (val >= 4) return 'GOOD';
    if (val >= 3) return 'OKAY';
    if (val >= 2) return 'LOW';
    if (val >= 1) return 'STRUGGLING';
    return 'UNKNOWN';
  }
}
