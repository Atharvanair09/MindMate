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

enum RecoveryStatus {
  generated,
  rejected,
  notRun,
}

class RecoveryDetectionResult {
  final RecoveryStatus status;
  final String? failureReason;
  final bool moodImproved;
  final bool burnoutImproved;
  final double startMood;
  final double endMood;
  final double startBurnout;
  final double endBurnout;
  final List<String> triggers;
  final RecoveryEvent? event;
  final int deletedDemoEventsCount;
  final bool isUpserted;
  final bool duplicatePrevented;

  RecoveryDetectionResult({
    required this.status,
    this.failureReason,
    this.moodImproved = false,
    this.burnoutImproved = false,
    this.startMood = -1,
    this.endMood = -1,
    this.startBurnout = -1,
    this.endBurnout = -1,
    this.triggers = const [],
    this.event,
    this.deletedDemoEventsCount = 0,
    this.isUpserted = false,
    this.duplicatePrevented = false,
  });
}

class RecoveryDetectionService {
  static final RecoveryDetectionService instance = RecoveryDetectionService._internal();
  RecoveryDetectionService._internal();

  Isar get isar => IsarDatabase.instance;

  Future<RecoveryDetectionResult> detectRecoveryEvents({bool isDemoMode = false}) async {
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final startDate = endDate.subtract(const Duration(days: 3));
    
    return await detectForWindow(startDate, endDate, isDemoMode: isDemoMode);
  }

  Future<RecoveryDetectionResult> detectForWindow(DateTime startDate, DateTime endDate, {bool isDemoMode = false}) async {
    final utcStart = DateTime.utc(startDate.year, startDate.month, startDate.day);
    final utcEnd = DateTime.utc(endDate.year, endDate.month, endDate.day);

    int deletedDemoCount = 0;
    if (isDemoMode) {
      await isar.writeTxn(() async {
        deletedDemoCount = await isar.recoveryEvents.filter().isDemoDataEqualTo(true).deleteAll();
      });
    }

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

    List<String> triggers = await _identifyTriggers(startDate, endDate);

    if (!moodImproved && !burnoutImproved) {
      List<String> reasons = [];
      if (!moodImproved) {
        if (startMood == -1 || endMood == -1) {
          reasons.add("Insufficient mood data");
        } else {
          reasons.add("Mood did not improve by at least 1.0 (Start: $startMood, End: $endMood)");
        }
      }
      if (!burnoutImproved) {
        if (startBurnout == -1 || endBurnout == -1) {
          reasons.add("Insufficient burnout data");
        } else {
          reasons.add("Burnout did not improve by at least 10.0 (Start: $startBurnout, End: $endBurnout)");
        }
      }
      return RecoveryDetectionResult(
        status: RecoveryStatus.rejected,
        failureReason: reasons.join(" AND "),
        moodImproved: moodImproved,
        burnoutImproved: burnoutImproved,
        startMood: startMood,
        endMood: endMood,
        startBurnout: startBurnout,
        endBurnout: endBurnout,
        triggers: triggers,
        deletedDemoEventsCount: deletedDemoCount,
      );
    }

    // Determine strength
    String strength = "Moderate";
    if ((moodImproved && (endMood - startMood) >= 2.0) || 
        (burnoutImproved && (startBurnout - endBurnout) >= 20.0)) {
      strength = "Strong";
    }

    // Avoid duplicate events in same day
    final todayMidnight = DateTime(endDate.year, endDate.month, endDate.day);
    final existingEvent = await isar.recoveryEvents
        .filter()
        .endDateGreaterThan(todayMidnight)
        .findFirst();

    if (existingEvent != null && !isDemoMode) {
      return RecoveryDetectionResult(
        status: RecoveryStatus.rejected,
        failureReason: "Recovery event already logged for today",
        moodImproved: moodImproved,
        burnoutImproved: burnoutImproved,
        startMood: startMood,
        endMood: endMood,
        startBurnout: startBurnout,
        endBurnout: endBurnout,
        triggers: triggers,
        event: existingEvent,
        duplicatePrevented: true,
        deletedDemoEventsCount: deletedDemoCount,
      );
    }

    String summary = "Recovery detected";
    if (moodImproved && burnoutImproved) {
      summary = "Significant improvement in both mood and burnout levels.";
    } else if (moodImproved) {
      summary = "Mood improved significantly over the last 3 days.";
    } else if (burnoutImproved) {
      summary = "Burnout risk decreased notably over the last 3 days.";
    }

    final event = existingEvent ?? RecoveryEvent();
    bool isUpsert = existingEvent != null;

    event
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

    if (isDemoMode) {
      event.isDemoData = true;
    }

    await isar.writeTxn(() async {
      await isar.recoveryEvents.put(event);
    });

    debugPrint('[RecoveryDetectionService] Recovery Event Detected. Strength: $strength');
    
    return RecoveryDetectionResult(
      status: RecoveryStatus.generated,
      moodImproved: moodImproved,
      burnoutImproved: burnoutImproved,
      startMood: startMood,
      endMood: endMood,
      startBurnout: startBurnout,
      endBurnout: endBurnout,
      triggers: triggers,
      event: event,
      deletedDemoEventsCount: deletedDemoCount,
      isUpserted: isUpsert,
    );
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

