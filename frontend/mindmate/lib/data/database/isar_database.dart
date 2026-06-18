import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/mood_log.dart';
import '../../domain/models/session_log.dart';
import '../../domain/models/embedding_record.dart';
import '../../domain/models/prediction_log.dart';
import '../../domain/models/intervention_log.dart';

class IsarDatabase {
  static late Isar instance;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    
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
      ],
      directory: dir.path,
    );
    
    _isInitialized = true;
  }
}
