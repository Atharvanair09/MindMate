import 'package:isar/isar.dart';

part 'wellness_journey_summary.g.dart';

@collection
class WellnessJourneySummary {
  Id id = Isar.autoIncrement;

  /// The generated chronological narrative of the user's wellness progression
  late String narrative;

  /// The timestamp when this summary was generated
  late DateTime generatedAt;

  /// The start date of the period this summary covers
  late DateTime startDate;

  /// The end date of the period this summary covers
  late DateTime endDate;

  /// Hashes or IDs of the latest events used to generate this summary,
  /// used to prevent generating the same summary if no new data exists
  List<String> eventSignatures = [];

  bool isDemoData = false;
}
