import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/app_notification.dart';
import '../ml/contextual_follow_up_engine.dart';
import 'notification_service.dart';

class NotificationSchedulerService {
  static final NotificationSchedulerService instance = NotificationSchedulerService._internal();
  NotificationSchedulerService._internal();

  /// Evaluates limits and lookback periods, then schedules a contextual follow-up if allowed.
  Future<void> evaluateAndSendContextualFollowUp() async {
    final isar = IsarDatabase.instance;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    // 1. Enforce a maximum of 3 follow-up notifications per day
    final todaysFollowUps = await isar.appNotifications
        .filter()
        .followUpCategoryEqualTo('contextual_follow_up')
        .and()
        .createdAtGreaterThan(startOfDay)
        .count();

    if (todaysFollowUps >= 3) {
      return; // Reached max notifications for today
    }

    // 2. Choose the most relevant follow-up based on the user's current detected situations
    final followUpData = await ContextualFollowUpEngine.instance.generateFollowUp();
    if (followUpData == null) return;

    final question = followUpData['question']!;
    final situation = followUpData['situation']!;
    final hash = followUpData['hash']!;

    // 3. Avoid repeating the same question within a 7-day lookback period
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final recentSameQuestion = await isar.appNotifications
        .filter()
        .followUpCategoryEqualTo('contextual_follow_up')
        .and()
        .followUpHashEqualTo(hash)
        .and()
        .createdAtGreaterThan(sevenDaysAgo)
        .findFirst();

    if (recentSameQuestion != null) {
      return; // Avoid repeating the same question
    }

    // 4. Send the notification
    await _sendFollowUpNotification(question, situation, hash);
  }

  Future<void> _sendFollowUpNotification(String question, String situation, String hash) async {
    final isar = IsarDatabase.instance;
    final title = 'Follow Up: $situation';

    // Save notification to get ID
    final notifId = await NotificationService.instance.saveNotification(
      title,
      question,
      'contextual_follow_up',
    );

    // Update with follow-up metadata
    await isar.writeTxn(() async {
      final notif = await isar.appNotifications.get(notifId);
      if (notif != null) {
        notif.followUpCategory = 'contextual_follow_up';
        notif.followUpSituation = situation;
        notif.followUpHash = hash;
        notif.responded = false;
        await isar.appNotifications.put(notif);
      }
    });

    // Delegate actual push to NotificationService
    await NotificationService.instance.sendContextualFollowUpPush(title, question, notifId);
  }

  /// Detect unanswered follow-ups and send reminders
  Future<void> sendUnansweredReminders() async {
    final isar = IsarDatabase.instance;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    final unanswered = await isar.appNotifications
        .filter()
        .followUpCategoryEqualTo('contextual_follow_up')
        .and()
        .respondedEqualTo(false)
        .and()
        .createdAtGreaterThan(startOfDay)
        .findAll();

    for (var notif in unanswered) {
      // Logic to resend or gently remind about unanswered check-ins
      await NotificationService.instance.sendContextualFollowUpPush(
        'Reminder: ${notif.title}', 
        notif.description,
        notif.id,
      );
    }
  }
}
