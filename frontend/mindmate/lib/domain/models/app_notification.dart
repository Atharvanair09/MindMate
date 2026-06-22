import 'package:isar/isar.dart';

part 'app_notification.g.dart';

@collection
class AppNotification {
  Id id = Isar.autoIncrement;

  late String title;
  late String message;
  late DateTime timestamp;
  bool isRead = false;
  
  // 'ai_insight', 'reflection_follow_up', 'burnout_alert', 'mood_reminder', 'system'
  late String type;
}
