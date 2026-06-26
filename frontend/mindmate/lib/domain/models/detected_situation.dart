class DetectedSituation {
  final String situationName;
  final double confidence; // 0.0 to 100.0
  final List<String> evidenceUsed;
  final String reason;
  final List<String> keywordsTriggered;
  final DateTime generatedAt;

  DetectedSituation({
    required this.situationName,
    required this.confidence,
    required this.evidenceUsed,
    required this.reason,
    required this.keywordsTriggered,
    required this.generatedAt,
  });
}
