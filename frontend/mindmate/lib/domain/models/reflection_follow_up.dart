import 'package:isar/isar.dart';

part 'reflection_follow_up.g.dart';

@collection
class ReflectionFollowUp {
  Id id = Isar.autoIncrement;

  late DateTime createdAt;
  late DateTime updatedAt;

  late String reason;

  bool journalPositiveMoodMismatch = false;
  bool journalNegativeMoodMismatch = false;
  bool burnoutChange = false;
  bool trendChange = false;

  late String message;
  
  String? userResponse;

  bool dismissed = false;
  bool resolved = false;

  DateTime? dismissedAt;
  DateTime? resolvedAt;

  int? journalEntryId;
  int? moodCheckInId;
}
