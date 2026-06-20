import 'package:isar/isar.dart';

part 'journal_entry.g.dart';

@collection
class JournalEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime createdAt;

  late DateTime updatedAt;

  @Index()
  late DateTime journalDate;

  String? title;

  late String content;

  String? pagesJson;

  int? wordCount;

  double? sentimentScore;

  bool embeddingGenerated = false;

  int? embeddingId;

  bool isDeleted = false;

  String get preview {
    if (content.isEmpty) return 'Empty journal';
    final lines = content.split('\n');
    return lines.first.length > 50 ? '${lines.first.substring(0, 47)}...' : lines.first;
  }
}
