class WellnessAction {
  final String text;
  final bool isCompleted;

  WellnessAction({
    required this.text,
    this.isCompleted = false,
  });

  WellnessAction copyWith({
    String? text,
    bool? isCompleted,
  }) {
    return WellnessAction(
      text: text ?? this.text,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class WellnessPlan {
  final List<WellnessAction> actions;
  final String primarySituation;
  final DateTime generatedAt;
  final String planStatus;

  WellnessPlan({
    required this.actions,
    required this.primarySituation,
    required this.generatedAt,
    this.planStatus = "Stable",
  });
}
