import 'package:isar/isar.dart';

part 'embedding_task.g.dart';

@collection
class EmbeddingTask {
  Id id = Isar.autoIncrement;

  @Index()
  late String sourceType; // 'journal' or 'chat'

  @Index()
  late int sourceId; // The Isar ID of the JournalEntry or ChatMessage

  @Index()
  late String status; // 'pending', 'processing', 'completed', 'failed'

  int retryCount = 0;

  late DateTime createdAt;

  DateTime? startedAt;

  DateTime? completedAt;

  String? lastError;
}
