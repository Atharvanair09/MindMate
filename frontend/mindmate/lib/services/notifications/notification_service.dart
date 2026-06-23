import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/app_notification.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../main.dart';
import '../../core/state/app_state_observer.dart';

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  factory NotificationService() => instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  Isar get _isar => IsarDatabase.instance;

  // Pending context aware check-in message
  static String? pendingContextAwareCheckInMessage;

  final Map<int, Timer> _activeTimers = {};

  void showInAppBanner(String title, String body) {
    if (scaffoldMessengerKey.currentState != null) {
      scaffoldMessengerKey.currentState!.showSnackBar(
        SnackBar(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(body),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          backgroundColor: Colors.indigo[800],
          duration: const Duration(seconds: 4),
          action: SnackBarAction(
            label: 'VIEW',
            textColor: Colors.white,
            onPressed: () {
              // Action logic if needed
            },
          ),
        ),
      );
    }
  }

  Future<void> handleAppForeground() async {
    // App is now actively visible. Cancel OS scheduled notifications to prevent system popups
    // and replace them with internal Dart timers.
    await flutterLocalNotificationsPlugin.cancelAll();

    final now = DateTime.now();
    final pendingNotifications = await _isar.appNotifications
        .filter()
        .isReadEqualTo(false)
        .and()
        .timestampGreaterThan(now)
        .findAll();

    for (var notification in pendingNotifications) {
      final delay = notification.timestamp.difference(now);
      if (delay.inMilliseconds > 0) {
        _activeTimers[notification.id]?.cancel();
        _activeTimers[notification.id] = Timer(delay, () {
          // Timer fired while in foreground!
          AppStateObserver.instance.suppressedCount++;
          showInAppBanner(notification.title, notification.message);
        });
      }
    }
  }

  Future<void> handleAppBackground() async {
    // App is entering background. Cancel Dart timers and delegate to OS via zonedSchedule.
    for (var timer in _activeTimers.values) {
      timer.cancel();
    }
    _activeTimers.clear();

    final now = DateTime.now();
    final pendingNotifications = await _isar.appNotifications
        .filter()
        .isReadEqualTo(false)
        .and()
        .timestampGreaterThan(now)
        .findAll();

    for (var notification in pendingNotifications) {
      final tzDate = tz.TZDateTime.from(notification.timestamp, tz.local);
      
      String channelId = 'daily_mood_channel_id';
      String channelName = 'Reminders';
      if (notification.type == 'reflection_follow_up') {
        channelId = 'follow_up_reminder_channel_id';
        channelName = 'Reflection Follow-Ups';
      } else if (notification.type == 'burnout_alert') {
        channelId = 'burnout_alert_channel_id';
        channelName = 'Burnout Alerts';
      } else if (notification.type == 'ai_insight') {
        channelId = 'ai_insight_channel_id';
        channelName = 'AI Insights';
      } else if (notification.type == 'mood_reminder') {
        channelId = 'daily_mood_channel_id';
        channelName = 'Daily Mood Check-In';
      }

      final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.max,
        priority: Priority.high,
      );
      
      final NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: const DarwinNotificationDetails(),
      );

      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: notification.id,
        title: notification.title,
        body: notification.message,
        scheduledDate: tzDate,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> initialize() async {
    if (_isInitialized) return;

    tz.initializeTimeZones();

    // Use monochrome vector icon ic_notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_notification');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    // Create Notification Channels for Android 8.0+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      const AndroidNotificationChannel dailyMoodChannel = AndroidNotificationChannel(
        'daily_mood_channel_id',
        'Daily Mood Check-In',
        description: 'Reminder to log your daily mood',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      const AndroidNotificationChannel smartMoodChannel = AndroidNotificationChannel(
        'smart_mood_channel_id',
        'Smart Mood Prompt',
        description: 'Optional check-in based on recent reflections',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );
      const AndroidNotificationChannel followUpChannel = AndroidNotificationChannel(
        'follow_up_reminder_channel_id',
        'Reflection Follow-Ups',
        description: 'Reminders to follow up on your reflections',
        importance: Importance.max,
        playSound: true,
        enableVibration: true,
      );
      const AndroidNotificationChannel aiInsightChannel = AndroidNotificationChannel(
        'ai_insight_channel_id',
        'AI Insights',
        description: 'AI reflection insights based on your entries',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );
      const AndroidNotificationChannel burnoutChannel = AndroidNotificationChannel(
        'burnout_alert_channel_id',
        'Burnout Alerts',
        description: 'Alerts when your burnout markers rise',
        importance: Importance.high,
        playSound: true,
        enableVibration: true,
      );

      await androidImplementation.createNotificationChannel(dailyMoodChannel);
      await androidImplementation.createNotificationChannel(smartMoodChannel);
      await androidImplementation.createNotificationChannel(followUpChannel);
      await androidImplementation.createNotificationChannel(aiInsightChannel);
      await androidImplementation.createNotificationChannel(burnoutChannel);
    }

    _isInitialized = true;
  }

  void _onNotificationResponse(NotificationResponse response) {
    // Handle notification tapped logic here if needed
  }

  Future<bool> requestPermissions() async {
    bool granted = false;
    
    // Android 13+
    final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      granted = await androidImplementation.requestNotificationsPermission() ?? false;
    }

    // iOS
    final IOSFlutterLocalNotificationsPlugin? iosImplementation =
        flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();
            
    if (iosImplementation != null) {
      granted = await iosImplementation.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ?? false;
    }
    
    return granted;
  }

  // --- LOCAL ISAR STORAGE CRUD ---

  Future<int> saveNotification(String title, String message, String type, {DateTime? scheduledTime}) async {
    final notification = AppNotification()
      ..title = title
      ..message = message
      ..timestamp = scheduledTime ?? DateTime.now()
      ..type = type
      ..isRead = false;

    await _isar.writeTxn(() async {
      await _isar.appNotifications.put(notification);
    });
    
    return notification.id;
  }

  Future<List<AppNotification>> getNotifications() async {
    final now = DateTime.now();
    return await _isar.appNotifications
        .filter()
        .timestampLessThan(now)
        .sortByTimestampDesc()
        .findAll();
  }

  Future<int> getUnreadCount() async {
    final now = DateTime.now();
    return await _isar.appNotifications
        .filter()
        .isReadEqualTo(false)
        .and()
        .timestampLessThan(now)
        .count();
  }

  Future<void> markAsRead(int id) async {
    await _isar.writeTxn(() async {
      final notification = await _isar.appNotifications.get(id);
      if (notification != null) {
        notification.isRead = true;
        await _isar.appNotifications.put(notification);
      }
    });
  }

  Future<void> markAllAsRead() async {
    final now = DateTime.now();
    final unread = await _isar.appNotifications
        .filter()
        .isReadEqualTo(false)
        .and()
        .timestampLessThan(now)
        .findAll();

    if (unread.isNotEmpty) {
      await _isar.writeTxn(() async {
        for (var notification in unread) {
          notification.isRead = true;
          await _isar.appNotifications.put(notification);
        }
      });
    }
  }

  // --- REMINDERS & TRIGGER METHODS ---

  Future<void> scheduleDailyMoodReminder() async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 19, 0, 0); // 7 PM

    if (now.isAfter(scheduledDate)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_mood_channel_id',
      'Daily Mood Check-In',
      channelDescription: 'Reminder to log your daily mood',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Check if an Isar record already exists for this scheduled time
    final existing = await _isar.appNotifications
        .filter()
        .typeEqualTo('mood_reminder')
        .and()
        .timestampEqualTo(scheduledDate)
        .findFirst();

    if (existing == null) {
      // Save to Isar for Notification Centre tracking
      final notifId = await saveNotification(
        'Mood Check-In',
        'How are you feeling right now?',
        'mood_reminder',
        scheduledTime: scheduledDate,
      );

      final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

      // ALWAYS register the OS zonedSchedule so the alarm survives app termination.
      // This is the primary delivery path for background / terminated state.
      try {
        await flutterLocalNotificationsPlugin.cancel(id: notifId);
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: notifId,
          title: 'Mood Check-In',
          body: 'How are you feeling right now?',
          scheduledDate: tzDate,
          notificationDetails: platformDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      } catch (_) {
        // Fallback: inexact alarm if exact scheduling is unavailable (some Android 12+ devices)
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: notifId,
          title: 'Mood Check-In',
          body: 'How are you feeling right now?',
          scheduledDate: tzDate,
          notificationDetails: platformDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        );
      }

      // ADDITIONALLY, when the app is currently in the foreground, set a Dart timer
      // so we can show an in-app snackbar instead of an OS popup at 7 PM.
      if (AppStateObserver.instance.isForeground) {
        final delay = scheduledDate.difference(now);
        _activeTimers[notifId]?.cancel();
        _activeTimers[notifId] = Timer(delay, () {
          // Cancel the OS notification (app is open) and show snackbar instead
          flutterLocalNotificationsPlugin.cancel(id: notifId);
          AppStateObserver.instance.suppressedCount++;
          showInAppBanner('Mood Check-In', 'How are you feeling right now?');
        });
      }
    }
  }

  Future<void> cancelDailyMoodReminder() async {
    // Cancel all pending mood_reminder OS notifications
    final now = DateTime.now();
    final reminders = await _isar.appNotifications
        .filter()
        .typeEqualTo('mood_reminder')
        .and()
        .timestampGreaterThan(now)
        .findAll();
    for (final r in reminders) {
      await flutterLocalNotificationsPlugin.cancel(id: r.id);
      _activeTimers[r.id]?.cancel();
      _activeTimers.remove(r.id);
    }
  }


  Future<void> scheduleFollowUpReminders(ReflectionFollowUp followUp) async {
    final now = DateTime.now();
    
    // HACKATHON MODE: Reminders scheduled 1 minute and 2 minutes after creation
    final time1 = now.add(const Duration(minutes: 1));
    final time2 = now.add(const Duration(minutes: 2));
    
    final id1 = followUp.id * 10 + 1;
    final id2 = followUp.id * 10 + 2;
    
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'follow_up_reminder_channel_id',
      'Reflection Follow-Ups',
      channelDescription: 'Reminders to follow up on your reflections',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Save scheduled reminders to local Isar DB
    final nid1 = await saveNotification(
      'Reflection Follow-Up',
      followUp.message,
      'reflection_follow_up',
      scheduledTime: time1,
    );
    final nid2 = await saveNotification(
      'Reflection Follow-Up',
      followUp.message,
      'reflection_follow_up',
      scheduledTime: time2,
    );

    if (AppStateObserver.instance.isForeground) {
      // Start dart timers
      _activeTimers[nid1] = Timer(time1.difference(now), () {
        AppStateObserver.instance.suppressedCount++;
        showInAppBanner('Reflection Follow-Up', followUp.message);
      });
      _activeTimers[nid2] = Timer(time2.difference(now), () {
        AppStateObserver.instance.suppressedCount++;
        showInAppBanner('Reflection Follow-Up', followUp.message);
      });
    } else {
      // Schedule Android/iOS local notifications
      final tzDate1 = tz.TZDateTime.from(time1, tz.local);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: nid1,
        title: 'Reflection Follow-Up',
        body: followUp.message,
        scheduledDate: tzDate1,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      final tzDate2 = tz.TZDateTime.from(time2, tz.local);
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id: nid2,
        title: 'Reflection Follow-Up',
        body: followUp.message,
        scheduledDate: tzDate2,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelFollowUpReminders(int followUpId) async {
    final now = DateTime.now();
    final toDelete = await _isar.appNotifications
        .filter()
        .typeEqualTo('reflection_follow_up')
        .and()
        .timestampGreaterThan(now)
        .findAll();

    for (var n in toDelete) {
      await flutterLocalNotificationsPlugin.cancel(id: n.id);
      _activeTimers[n.id]?.cancel();
      _activeTimers.remove(n.id);
    }
    
    await _isar.writeTxn(() async {
      for (var n in toDelete) {
        await _isar.appNotifications.delete(n.id);
      }
    });
  }

  // Send context-aware check-in immediately or scheduled 1 min after app closed
  Future<void> sendContextAwareCheckIn(String body, {bool immediate = false}) async {
    final now = DateTime.now();
    final scheduledTime = immediate ? now : now.add(const Duration(minutes: 1));

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'smart_mood_channel_id',
      'Smart Mood Check-In',
      channelDescription: 'Context-aware mood check-in requests',
      importance: Importance.max,
      priority: Priority.high,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    // Save notification to Isar first
    final notifId = await saveNotification(
      'Mood Check-In',
      body,
      'mood_reminder',
      scheduledTime: scheduledTime,
    );

    if (immediate) {
      if (AppStateObserver.instance.isForeground) {
        AppStateObserver.instance.suppressedCount++;
        showInAppBanner('Mood Check-In', body);
      } else {
        AppStateObserver.instance.backgroundCount++;
        await flutterLocalNotificationsPlugin.show(
          id: notifId,
          title: 'Mood Check-In',
          body: body,
          notificationDetails: platformDetails,
        );
      }
    } else {
      if (AppStateObserver.instance.isForeground) {
        _activeTimers[notifId] = Timer(scheduledTime.difference(now), () {
          AppStateObserver.instance.suppressedCount++;
          showInAppBanner('Mood Check-In', body);
        });
      } else {
        final tzDate = tz.TZDateTime.from(scheduledTime, tz.local);
        await flutterLocalNotificationsPlugin.zonedSchedule(
          id: notifId,
          title: 'Mood Check-In',
          body: body,
          scheduledDate: tzDate,
          notificationDetails: platformDetails,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }
  }

  // Send immediate Burnout Alert
  Future<void> sendBurnoutAlert(String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'burnout_alert_channel_id',
      'Burnout Alert',
      channelDescription: 'Alerts when your burnout markers rise significantly',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final notifId = await saveNotification(
      'Burnout Alert',
      body,
      'burnout_alert',
    );
    
    if (AppStateObserver.instance.isForeground) {
      AppStateObserver.instance.suppressedCount++;
      showInAppBanner('Burnout Alert', body);
    } else {
      AppStateObserver.instance.backgroundCount++;
      await flutterLocalNotificationsPlugin.show(
        id: notifId,
        title: 'Burnout Alert',
        body: body,
        notificationDetails: platformDetails,
      );
    }
  }

  // Send immediate AI Reflection Insight
  Future<void> sendAIInsight(String body) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'ai_insight_channel_id',
      'AI Reflection',
      channelDescription: 'Insights based on your recent entries',
      importance: Importance.high,
      priority: Priority.high,
    );
    
    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final notifId = await saveNotification(
      'AI Reflection',
      body,
      'ai_insight',
    );
    
    if (AppStateObserver.instance.isForeground) {
      AppStateObserver.instance.suppressedCount++;
      showInAppBanner('AI Reflection', body);
    } else {
      AppStateObserver.instance.backgroundCount++;
      await flutterLocalNotificationsPlugin.show(
        id: notifId,
        title: 'AI Reflection',
        body: body,
        notificationDetails: platformDetails,
      );
    }
  }

  // Wrapper for backward compatibility
  Future<void> sendSmartMoodReminder() async {
    await sendContextAwareCheckIn(
      "We noticed some changes in your recent reflections. Would you like to check in today?",
      immediate: true,
    );
  }

  // --- DEBUG HELPERS ---

  /// Returns a map of notification diagnostic information for the Debug Page.
  Future<Map<String, dynamic>> getNotificationDebugInfo() async {
    // Permission status
    String permissionStatus = 'Unknown';
    final androidImpl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final granted = await androidImpl.areNotificationsEnabled();
      permissionStatus = (granted ?? false) ? 'GRANTED' : 'DENIED';
    }

    // Pending OS notifications
    final pendingRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    final pendingCount = pendingRequests.length;

    // Next scheduled mood reminder
    final now = DateTime.now();
    final nextReminder = await _isar.appNotifications
        .filter()
        .typeEqualTo('mood_reminder')
        .and()
        .timestampGreaterThan(now)
        .sortByTimestamp()
        .findFirst();

    // Last delivered notification (past + unread count)
    final lastDelivered = await _isar.appNotifications
        .filter()
        .timestampLessThan(now)
        .sortByTimestampDesc()
        .findFirst();

    return {
      'permissionStatus': permissionStatus,
      'pendingOSCount': pendingCount,
      'nextReminderTime': nextReminder?.timestamp?.toLocal().toString() ?? 'None scheduled',
      'nextReminderType': nextReminder?.type ?? '--',
      'lastNotificationTitle': lastDelivered?.title ?? 'None',
      'lastNotificationTime': lastDelivered?.timestamp.toLocal().toString() ?? '--',
      'appState': AppStateObserver.instance.state.toString().split('.').last.toUpperCase(),
      'dartTimerCount': _activeTimers.length,
    };
  }

  /// Sends a test notification immediately, routing via the correct path based on app state.
  /// Use this from the Debug Page to verify end-to-end delivery.
  Future<Map<String, String>> sendTestReminder() async {
    const title = 'Test Reminder';
    final deliveryBody = '🧪 Test notification fired at ${DateTime.now().toLocal().toString().substring(0, 19)}';

    final notifId = await saveNotification(title, deliveryBody, 'test_reminder');
    final appState = AppStateObserver.instance.state.toString().split('.').last.toUpperCase();

    if (AppStateObserver.instance.isForeground) {
      AppStateObserver.instance.suppressedCount++;
      showInAppBanner(title, deliveryBody);
      return {
        'appState': appState,
        'deliveryPath': 'IN-APP SNACKBAR',
        'expected': 'Snackbar shown above ↑',
      };
    } else {
      AppStateObserver.instance.backgroundCount++;
      const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
        'daily_mood_channel_id',
        'Daily Mood Check-In',
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformDetails = NotificationDetails(
        android: androidDetails,
        iOS: DarwinNotificationDetails(),
      );
      await flutterLocalNotificationsPlugin.show(
        id: notifId,
        title: title,
        body: deliveryBody,
        notificationDetails: platformDetails,
      );
      return {
        'appState': appState,
        'deliveryPath': 'OS NOTIFICATION',
        'expected': 'Android notification in status bar',
      };
    }
  }
}
