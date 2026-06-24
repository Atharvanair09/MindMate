import 'package:isar/isar.dart';

part 'recovery_event.g.dart';

@collection
class RecoveryEvent {
  Id id = Isar.autoIncrement;

  @Index()
  late DateTime startDate;

  @Index()
  late DateTime endDate;

  late double startMood;

  late double endMood;

  late double startBurnout;

  late double endBurnout;

  /// e.g. "Strong", "Moderate"
  late String recoveryStrength;

  /// e.g. ["Social interaction", "Positive journals"]
  late List<String> possibleTriggers;

  /// Summary of the recovery event.
  late String summary;

  late DateTime generatedAt;
}
