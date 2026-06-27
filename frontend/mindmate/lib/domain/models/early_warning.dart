import 'package:isar/isar.dart';

part 'early_warning.g.dart';

@collection
class EarlyWarningAlert {
  Id id = Isar.autoIncrement;

  /// The severity level of the alert: "Green", "Yellow", "Orange", "Red"
  late String level;

  /// The list of reasons supporting this alert level
  late List<String> reasons;

  /// When this alert was generated
  late DateTime generatedAt;
}
