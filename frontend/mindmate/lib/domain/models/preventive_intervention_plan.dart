class PreventiveAction {
  final String text;
  final String explanation;

  PreventiveAction({
    required this.text,
    required this.explanation,
  });
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
