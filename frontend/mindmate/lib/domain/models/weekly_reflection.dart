import 'package:isar/isar.dart';

part 'weekly_reflection.g.dart';

@collection
class WeeklyReflection {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late DateTime weekStartDate;

  late DateTime weekEndDate;

  /// Average mood score (1.0–5.0). STRUGGLING=1, LOW=2, OKAY=3, GOOD=4, GREAT=5.
  late double averageMoodScore;

  /// Average burnout score (0–100) computed from daily ReflectionEngine outputs.
  late double averageBurnoutScore;

  /// "Improving" | "Stable" | "Increasing"
  late String burnoutTrend;

  /// "Improving" | "Stable" | "Declining"
  late String moodTrend;

  /// Top 3 positive highlights detected from the week's data.
  late List<String> positiveIndicators;

  /// Top 3 negative signals detected from the week's data.
  late List<String> negativeIndicators;

  /// Simple correlation patterns (e.g. "Social interactions appear associated with improved mood.").
  late List<String> keyPatterns;

  /// A concise AI-style narrative summary of the week.
  late String summary;

  /// Actionable suggestion based on trends.
  late String suggestion;

  /// Confidence score 20–90% (Final capped confidence).
  late double confidence;

  /// Raw confidence score before capping
  double rawConfidence = 0.0;

  /// The cap on confidence based on history length
  double confidenceCap = 90.0;

  /// Base confidence score
  double baseConfidence = 20.0;

  /// Days contribution to confidence
  double daysContribution = 0.0;

  /// Mood contribution to confidence
  double moodContribution = 0.0;

  /// Journal contribution to confidence
  double journalContribution = 0.0;

  /// Chat contribution to confidence
  double chatContribution = 0.0;

  /// Burnout contribution to confidence
  double burnoutContribution = 0.0;

  /// Follow-up contribution to confidence
  double followUpContribution = 0.0;

  /// History Sufficiency label (e.g. LOW, MODERATE, FULL)
  late String historySufficiency;

  /// The most influential positive factor
  late String mostPositiveInfluence;

  /// The most influential negative factor
  late String mostNegativeInfluence;

  /// Reason for positive factor
  late String positiveInfluenceReason;

  /// Reason for negative factor
  late String negativeInfluenceReason;

  /// Score of positive factor
  late double topPositiveScore;

  /// Score of negative factor
  late double topNegativeScore;

  /// All factor scores formatted as "Factor: Score"
  late List<String> influenceScores;

  late DateTime generatedAt;
}
