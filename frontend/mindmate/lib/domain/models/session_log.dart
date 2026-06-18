import 'package:isar/isar.dart';

part 'session_log.g.dart';

@collection
class SessionLog {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime date;

  int appOpenCount = 0;

  int chatMessages = 0;

  int journalEntries = 0;

  int timeSpentMinutes = 0;
}
