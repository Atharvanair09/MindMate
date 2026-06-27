class PreventiveAction {
  final String text;
  final String explanation;
  final bool isCompleted;

  PreventiveAction({
    required this.text,
    required this.explanation,
    this.isCompleted = false,
  });

  PreventiveAction copyWith({
    String? text,
    String? explanation,
    bool? isCompleted,
  }) {
    return PreventiveAction(
      text: text ?? this.text,
      explanation: explanation ?? this.explanation,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class PreventiveInterventionPlan {
  final List<PreventiveAction> actions;
  final DateTime generatedAt;
  final String forecastTrend;

  PreventiveInterventionPlan({
    required this.actions,
    required this.generatedAt,
    required this.forecastTrend,
  });
}
