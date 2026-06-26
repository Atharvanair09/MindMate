import 'package:isar/isar.dart';

part 'app_notification.g.dart';

@collection
class AppNotification {
  Id id = Isar.autoIncrement;

  late String title;
  late String description;
  late DateTime createdAt;
  bool read = false;
  
  // 'ai_insight', 'reflection_follow_up', 'burnout_alert', 'mood_reminder', 'smart_check_in', 'system', 'conflict_reminder', 'recovery_event', 'pattern_discovery', 'weekly_reflection_ready', 'group_recommendation'
  late String type;

  // Fields for Contextual Follow-Up Engine
  String? followUpCategory;
  String? followUpSituation;
  String? followUpHash;
  bool? responded;
}
