import 'package:isar/isar.dart';

part 'embedding_record.g.dart';

@collection
class EmbeddingRecord {
  Id id = Isar.autoIncrement;

  late String sourceType; // e.g., 'journal', 'chat'

  late int sourceId;

  @Index()
  late String modelVersion;

  late int vectorDimension;

  late DateTime createdAt;

  bool storedLocally = true;
}
