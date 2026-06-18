import 'package:isar/isar.dart';

part 'intervention_log.g.dart';

@collection
class InterventionLog {
  Id id = Isar.autoIncrement;

  late String interventionType;

  late DateTime startedAt;

  late DateTime completedAt;

  String? preMood;

  String? postMood;

  String? improvement;
}
