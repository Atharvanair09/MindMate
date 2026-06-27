import 'package:isar/isar.dart';

part 'daily_mood_check_in.g.dart';

@collection
class DailyMoodCheckIn {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime date; // Store as UTC midnight to represent the calendar day

  late String moodLevel; // GREAT, GOOD, OKAY, LOW, STRUGGLING

  late DateTime createdAt;

  late DateTime updatedAt;

  late String source; // manual, smart_prompt

  bool isDemoData = false;
}
