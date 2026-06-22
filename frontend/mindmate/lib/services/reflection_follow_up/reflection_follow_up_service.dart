import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../services/ml/feature_pipeline.dart';
import '../../services/ml/reflection_engine.dart';
import '../../services/notifications/notification_service.dart';

class ReflectionFollowUpService {
  static final ReflectionFollowUpService instance = ReflectionFollowUpService._internal();
  factory ReflectionFollowUpService() => instance;
  ReflectionFollowUpService._internal();

  Isar get _isar => IsarDatabase.instance;

  Future<ReflectionFollowUp?> getActiveFollowUp() async {
    return await _isar.reflectionFollowUps
        .where()
        .filter()
        .resolvedEqualTo(false)
        .and()
        .dismissedEqualTo(false)
        .findFirst();
  }

  Future<void> markResolved(int id, {String? userResponse}) async {
    await _isar.writeTxn(() async {
      final followUp = await _isar.reflectionFollowUps.get(id);
      if (followUp != null) {
        followUp.resolved = true;
        followUp.resolvedAt = DateTime.now();
        followUp.updatedAt = DateTime.now();
        if (userResponse != null && userResponse.trim().isNotEmpty) {
          followUp.userResponse = userResponse;
        }
        await _isar.reflectionFollowUps.put(followUp);
      }
    });

    // Cancel pending follow-up notifications
    await NotificationService.instance.cancelFollowUpReminders(id);

    // Re-run the feature pipeline and mark cached reflection as dirty
    // to incorporate the new user response in reflections immediately.
    await FeaturePipeline.instance.triggerPipeline();
  }

  Future<void> markDismissed(int id) async {
    await _isar.writeTxn(() async {
      final followUp = await _isar.reflectionFollowUps.get(id);
      if (followUp != null) {
        followUp.dismissed = true;
        followUp.dismissedAt = DateTime.now();
        followUp.updatedAt = DateTime.now();
        await _isar.reflectionFollowUps.put(followUp);
      }
    });

    // Cancel pending follow-up notifications
    await NotificationService.instance.cancelFollowUpReminders(id);
  }

  Future<bool> detectAndSaveFollowUp() async {
    final activeFollowUp = await getActiveFollowUp();
    if (activeFollowUp != null) {
      return true; // Already have an active follow-up
    }

    final now = DateTime.now();
    
    final todayMidnight = DateTime.utc(now.year, now.month, now.day);
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // Check if any follow-up was created today
    final todayFollowUps = await _isar.reflectionFollowUps
        .filter()
        .createdAtBetween(startOfDay, endOfDay, includeLower: true, includeUpper: false)
        .findAll();

    if (todayFollowUps.isNotEmpty) {
      final hasDismissed = todayFollowUps.any((f) => f.dismissed);
      final hasResolvedWithResponse = todayFollowUps.any((f) => f.resolved && f.userResponse != null && f.userResponse!.trim().isNotEmpty);
      
      if (hasDismissed || hasResolvedWithResponse) {
        return false; // Don't show again if they dismissed it or answered it
      }

      final resolvedFollowUps = todayFollowUps.where((f) => f.resolved).toList();
      if (resolvedFollowUps.isNotEmpty) {
        final todayCheckIn = await _isar.dailyMoodCheckIns
            .where()
            .dateEqualTo(todayMidnight)
            .findFirst();

        if (todayCheckIn != null) {
          // Find the latest resolved follow-up today
          resolvedFollowUps.sort((a, b) => (b.resolvedAt ?? b.updatedAt).compareTo(a.resolvedAt ?? a.updatedAt));
          final latestResolved = resolvedFollowUps.first;
          final latestResolvedTime = latestResolved.resolvedAt ?? latestResolved.updatedAt;

          // If today's mood check-in was NOT updated after the latest resolved follow-up,
          // it means the mood hasn't changed since they resolved the follow-up.
          // Respect their choice.
          if (todayCheckIn.updatedAt.isBefore(latestResolvedTime)) {
            return false;
          }
        } else {
          return false;
        }
      }
    }

    final vector = await FeaturePipeline.instance.getLatestVector();
    if (vector == null) return false;

    // Fetch previous vector to evaluate Case 3 and Case 4
    final previousVector = await _isar.moodFeatureVectors
        .filter()
        .dateLessThan(vector.date)
        .sortByDateDesc()
        .findFirst();

    bool journalPositiveMismatch = false;
    bool journalNegativeMismatch = false;
    bool burnoutChange = false;
    bool trendChange = false;
    String? reason;
    String message = "";

    final todayMood = vector.currentMood;
    final todayMoodVal = vector.currentMoodValue;
    final journalSentiment = vector.journalSentiment;

    // Case 1: Journal sentiment is strongly negative AND Selected mood is GREAT or GOOD
    if (journalSentiment != null && journalSentiment <= -0.5 && 
        (todayMood == 'GREAT' || todayMood == 'GOOD')) {
      journalNegativeMismatch = true;
      reason = "journal_negative_mood_mismatch";
      message = "You mentioned feeling exhausted and stressed in your journal, but your mood check-in is $todayMood. Did something positive happen after writing your journal?";
    }
    // Case 2: Journal sentiment is strongly positive AND Selected mood is LOW or STRUGGLING
    else if (journalSentiment != null && journalSentiment >= 0.5 && 
             (todayMood == 'LOW' || todayMood == 'STRUGGLING')) {
      journalPositiveMismatch = true;
      reason = "journal_positive_mood_mismatch";
      message = "Your journal sounded optimistic, but your check-in suggests you're having a difficult day. Would you like to share what changed?";
    }
    // Case 3: Burnout score increases significantly while mood remains unchanged
    else if (previousVector != null) {
      final todayReflection = await ReflectionEngine.instance.getLatestReflection();
      final todayBurnout = todayReflection.burnoutScore;

      final previousReflection = await ReflectionEngine.instance.getReflectionForVector(previousVector);
      final previousBurnout = previousReflection.burnoutScore;

      final burnoutIncrease = todayBurnout - previousBurnout;
      final moodUnchanged = todayMood != null && todayMood == previousVector.currentMood;

      if (burnoutIncrease >= 15 && moodUnchanged) {
        burnoutChange = true;
        reason = "burnout_change";
        message = "We noticed your burnout markers are rising even though your checked-in mood remains unchanged at $todayMood. Would you like to share what's adding to your load?";
      }
    }

    // Case 4: Mood changes dramatically from recent trend
    if (reason == null && todayMoodVal != null && vector.rollingMoodAverage7Days != null) {
      final diff = (todayMoodVal - vector.rollingMoodAverage7Days!).abs();
      if (diff >= 1.5) {
        trendChange = true;
        reason = "trend_change";
        message = "Your mood today is quite different from your recent trend. Would you like to share what changed?";
      }
    }

    if (reason != null) {
      // Find today's journal entry and daily mood check-in to associate
      final todayMidnight = DateTime.utc(now.year, now.month, now.day);
      final startOfDay = DateTime(now.year, now.month, now.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final todayJournal = await _isar.journalEntrys
          .filter()
          .createdAtBetween(startOfDay, endOfDay, includeLower: true, includeUpper: false)
          .and()
          .isDeletedEqualTo(false)
          .findFirst();

      final todayCheckIn = await _isar.dailyMoodCheckIns
          .where()
          .dateEqualTo(todayMidnight)
          .findFirst();

      final followUp = ReflectionFollowUp()
        ..createdAt = now
        ..updatedAt = now
        ..reason = reason
        ..journalPositiveMoodMismatch = journalPositiveMismatch
        ..journalNegativeMoodMismatch = journalNegativeMismatch
        ..burnoutChange = burnoutChange
        ..trendChange = trendChange
        ..message = message
        ..dismissed = false
        ..resolved = false
        ..journalEntryId = todayJournal?.id
        ..moodCheckInId = todayCheckIn?.id;

      await _isar.writeTxn(() async {
        await _isar.reflectionFollowUps.put(followUp);
      });

      // Schedule follow-up reminders
      try {
        await NotificationService.instance.scheduleFollowUpReminders(followUp);
      } catch (e) {
        // Suppress or log error during background scheduling
      }

      return true;
    }

    return false;
  }

  Future<void> recordFollowUpShown() async {
    final now = DateTime.now();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_reflection_follow_up_date', now.toIso8601String());
  }
}
