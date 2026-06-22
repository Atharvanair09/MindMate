class ReflectionResult {
  final int burnoutScore;
  final String burnoutLevel; // LOW, MODERATE, HIGH
  final String insight;
  final List<String> contributingFactors;
  final String suggestedAction;
  final DateTime generatedAt;
  final int? moodScore;
  
  // Debug fields
  final double confidence;
  final String journalContribution;
  final String chatContribution;
  final String trendContribution;
  final double rawJournalImpact;
  final double rawChatImpact;
  final double rawTrendImpact;
  final double rawActivityImpact;
  
  final String? currentMood;
  final double moodWeight;
  final double moodContribution;
  final double burnoutBeforeMoodAdjustment;
  final double burnoutAfterMoodAdjustment;
  final String? burnoutExplanation;

  ReflectionResult({
    required this.burnoutScore,
    required this.burnoutLevel,
    required this.insight,
    required this.contributingFactors,
    required this.suggestedAction,
    required this.generatedAt,
    this.moodScore,
    required this.confidence,
    required this.journalContribution,
    required this.chatContribution,
    required this.trendContribution,
    required this.rawJournalImpact,
    required this.rawChatImpact,
    required this.rawTrendImpact,
    required this.rawActivityImpact,
    this.currentMood,
    required this.moodWeight,
    required this.moodContribution,
    required this.burnoutBeforeMoodAdjustment,
    required this.burnoutAfterMoodAdjustment,
    this.burnoutExplanation,
  });
}
