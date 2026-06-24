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

  /// Confidence score 40–90%.
  late double confidence;

  late DateTime generatedAt;
}
