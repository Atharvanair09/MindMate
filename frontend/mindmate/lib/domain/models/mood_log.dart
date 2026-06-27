import 'package:isar/isar.dart';

part 'mood_log.g.dart';

@collection
class MoodLog {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime createdAt;

  @Index()
  late int score; // 1-5

  late String source;

  late String reason;

  late double confidence;

  late bool isManual;

  bool isDemoData = false;
}
