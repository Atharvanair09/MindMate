import 'package:isar/isar.dart';

part 'pattern_insight.g.dart';

@collection
class PatternInsight {
  Id id = Isar.autoIncrement;

  /// The name or category of the pattern (e.g., "Social Interaction", "Sleep Disruption")
  late String patternName;

  /// The number of occurrences supporting this pattern
  late int supportingEvidence;

  /// The outcome associated with this pattern (e.g., "Improved Mood", "Higher Burnout", "Lower Mood")
  late String associationType;

  /// Confidence level ("Low", "Moderate", "High") based on evidence count
  late String confidence;

  /// Description or exact wording of the pattern detected
  late String description;

  /// When this pattern was detected
  late DateTime generatedAt;

  bool isDemoData = false;
}
