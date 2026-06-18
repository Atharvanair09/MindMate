import 'package:isar/isar.dart';

part 'journal_entry.g.dart';

@collection
class JournalEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;

  late String title;

  late String content;

  late int wordCount;

  double? sentimentScore;

  bool embeddingGenerated = false;

  int? embeddingId;

  bool isDeleted = false;
}
