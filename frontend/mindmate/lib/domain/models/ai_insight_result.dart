class AiInsightResult {
  final String homeCardInsight; // Max 120 chars, one concise sentence
  final String detailedReflection;
  final String observation;
  final String suggestion;
  final double confidence; // 0.0 to 100.0
  final List<String> factorsUsed;
  final DateTime generatedAt;
  
  // New fields for debugging and transparency
  final int historyDaysAvailable;
  final bool trendAvailable;
  final bool averageComparisonAvailable;
  final List<String> signalsUsed;
  final List<String> availableSignals;
  final Map<String, double> confidenceContributions;

  AiInsightResult({
    required this.homeCardInsight,
    required this.detailedReflection,
    required this.observation,
    required this.suggestion,
    required this.confidence,
    required this.factorsUsed,
    required this.generatedAt,
    this.historyDaysAvailable = 0,
    this.trendAvailable = false,
    this.averageComparisonAvailable = false,
    this.signalsUsed = const [],
    this.availableSignals = const [],
    this.confidenceContributions = const {},
  });

  // Fallback state when there is insufficient data
  factory AiInsightResult.fallback() {
    return AiInsightResult(
      homeCardInsight: "Continue checking in to unlock more personalized insights.",
      detailedReflection: "We need a bit more data to provide meaningful reflections. Keep journaling and logging your mood!",
      observation: "Insufficient data to detect patterns.",
      suggestion: "Log your mood or add a journal entry today.",
      confidence: 0.0,
      factorsUsed: ["None"],
      generatedAt: DateTime.now(),
      historyDaysAvailable: 0,
      trendAvailable: false,
      averageComparisonAvailable: false,
      signalsUsed: ["None"],
      availableSignals: ["None"],
      confidenceContributions: {},
    );
  }
}
