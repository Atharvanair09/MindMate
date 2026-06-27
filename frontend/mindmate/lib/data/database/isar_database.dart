import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/mood_log.dart';
import '../../domain/models/session_log.dart';
import '../../domain/models/embedding_record.dart';
import '../../domain/models/prediction_log.dart';
import '../../domain/models/intervention_log.dart';
import '../../domain/models/embedding_task.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../domain/models/app_notification.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../domain/models/recovery_event.dart';
import '../../domain/models/pattern_insight.dart';
import '../../domain/models/anonymous_post.dart';
import '../../domain/models/burnout_forecast.dart';
import '../../domain/models/early_warning.dart';
import '../../domain/models/wellness_journey_summary.dart';

class IsarDatabase {
  static late Isar instance;
  static bool _isInitialized = false;

  static Future<void> initialize(String uuid) async {
    if (_isInitialized) {
      if (instance.name == uuid) return;
      await close(); // Close existing instance if logging in as different user
    }

    final dir = await getApplicationDocumentsDirectory();
    
    // Privacy Architecture Note:
    // This architecture intentionally stores every sensitive record locally.
    // No journal content leaves the device.
    // No chat history leaves the device.
    // No embeddings leave the device.
    // Anonymous authentication is completely separated from user wellness data.
    instance = await Isar.open(
      [
        JournalEntrySchema,
        ChatMessageSchema,
        MoodLogSchema,
        SessionLogSchema,
        EmbeddingRecordSchema,
        PredictionLogSchema,
        InterventionLogSchema,
        EmbeddingTaskSchema,
        MoodFeatureVectorSchema,
        DailyMoodCheckInSchema,
        ReflectionFollowUpSchema,
        AppNotificationSchema,
        WeeklyReflectionSchema,
        RecoveryEventSchema,
        PatternInsightSchema,
        AnonymousPostSchema,
        BurnoutForecastSchema,
        EarlyWarningAlertSchema,
        WellnessJourneySummarySchema,
      ],
      directory: dir.path,
      name: uuid,
    );
    
    _isInitialized = true;
  }

  static Future<void> close() async {
    if (_isInitialized) {
      await instance.close();
      _isInitialized = false;
    }
  }
}
