import '../repositories/journal_repository_impl.dart';
import '../repositories/chat_repository_impl.dart';
import '../repositories/mood_repository_impl.dart';
import '../repositories/session_repository_impl.dart';
import '../repositories/embedding_repository_impl.dart';
import '../repositories/prediction_repository_impl.dart';
import '../repositories/intervention_repository_impl.dart';

/// Privacy Architecture Note:
/// This architecture intentionally stores every sensitive record locally.
/// No journal content leaves the device.
/// No chat history leaves the device.
/// No embeddings leave the device.
/// Anonymous authentication is completely separated from user wellness data.
class StorageService {
  final journalRepo = JournalRepositoryImpl();
  final chatRepo = ChatRepositoryImpl();
  final moodRepo = MoodRepositoryImpl();
  final sessionRepo = SessionRepositoryImpl();
  final embeddingRepo = EmbeddingRepositoryImpl();
  final predictionRepo = PredictionRepositoryImpl();
  final interventionRepo = InterventionRepositoryImpl();

  // Future facade methods can be added here if orchestrating across multiple repositories is needed.
}
