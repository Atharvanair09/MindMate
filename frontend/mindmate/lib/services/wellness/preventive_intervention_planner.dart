import '../../domain/models/preventive_intervention_plan.dart';
import '../../domain/models/burnout_forecast.dart';
import '../../domain/models/detected_situation.dart';
import '../../domain/models/pattern_insight.dart';
import '../../domain/models/recovery_event.dart';
import 'burnout_forecast_engine.dart';
import '../ml/situation_detection_engine.dart';
import '../pattern/pattern_discovery_service.dart';
import '../ml/recovery_detection_service.dart';
import '../../data/database/isar_database.dart';
import 'package:isar/isar.dart';

class PreventiveInterventionPlanner {
  static final PreventiveInterventionPlanner instance = PreventiveInterventionPlanner._internal();

  PreventiveInterventionPlanner._internal();

  Future<PreventiveInterventionPlan> generatePlan() async {
    // 1. Fetch Forecast
    final BurnoutForecast forecast = await BurnoutForecastEngine.instance.getDailyForecast();
    
    // 2. Fetch Detectable Situations
    final List<DetectedSituation> situations = await SituationDetectionEngine.instance.detectSituations();
    
    // 3. Fetch Patterns & Recovery History
    final List<PatternInsight> patterns = await PatternDiscoveryService.instance.getPatterns();
    final List<RecoveryEvent> recoveries = await IsarDatabase.instance.recoveryEvents.where().sortByGeneratedAtDesc().limit(5).findAll();

    List<PreventiveAction> actions = [];
    
    // Core Logic Based on Trend
    if (forecast.trend == "Increasing" || forecast.trend == "Declining") {
      // Risk is going up, prioritize immediate interventions
      
      // Action 1: Address Burnout Directly
      actions.add(PreventiveAction(
        text: "Schedule a 30-minute recovery break today.",
        explanation: "Recommended because your burnout forecast indicates an increasing trend over the next 3 to 7 days. Early intervention prevents further escalation.",
      ));

      // Action 2: Situation specific or fallback
      if (situations.isNotEmpty) {
        final topSituation = situations.first.situationName;
        if (topSituation == "Sleep Issues") {
          actions.add(PreventiveAction(
            text: "Implement a strict wind-down routine tonight (no screens 1 hour before bed).",
            explanation: "Your recent sleep issues are contributing to the increasing burnout forecast. Improving sleep quality is a critical preventive measure.",
          ));
        } else {
          actions.add(PreventiveAction(
            text: "Reduce non-essential workload if possible.",
            explanation: "With $topSituation detected alongside rising burnout risk, reducing immediate demands helps create a buffer.",
          ));
        }
      } else {
        actions.add(PreventiveAction(
          text: "Practice a short breathing exercise (e.g. 4-7-8 method).",
          explanation: "Recommended to lower your baseline stress level as your burnout risk is climbing.",
        ));
      }

      // Action 3: Pattern or Recovery based
      if (patterns.any((p) => p.patternName == "Negative Coping")) {
        actions.add(PreventiveAction(
          text: "Be mindful of your negative coping habits today.",
          explanation: "You have a known pattern of negative coping under stress, which is currently forecasted to increase.",
        ));
      } else if (recoveries.isNotEmpty) {
        actions.add(PreventiveAction(
          text: "Revisit what helped during your last recovery period.",
          explanation: "A recent recovery event was detected. Re-engaging with those positive triggers can prevent the current rising trend.",
        ));
      } else {
        actions.add(PreventiveAction(
          text: "Prioritize one essential task and defer the rest.",
          explanation: "Focusing your energy mitigates the increasing stress load forecasted for the coming days.",
        ));
      }
    } else if (forecast.trend == "Stable") {
      // Moderate/Stable
      actions.add(PreventiveAction(
        text: "Maintain your current daily routines.",
        explanation: "Your burnout forecast is stable, suggesting your current routine is maintaining your baseline.",
      ));
      
      if (situations.isNotEmpty) {
        actions.add(PreventiveAction(
          text: "Address your most pressing situation: ${situations.first.situationName}.",
          explanation: "While burnout is stable, resolving this situation will help push your trend towards a decrease.",
        ));
      } else {
        actions.add(PreventiveAction(
          text: "Incorporate a 15-minute daily walk.",
          explanation: "Since your stress levels are stable, this is a good time to build resilience with light physical activity.",
        ));
      }

      actions.add(PreventiveAction(
        text: "Plan an enjoyable activity for the weekend.",
        explanation: "Having something to look forward to helps maintain a stable and positive outlook.",
      ));
    } else {
      // Decreasing / Improving
      actions.add(PreventiveAction(
        text: "Reflect on what has been going well recently.",
        explanation: "Your burnout forecast is decreasing. Acknowledging positive changes reinforces good habits.",
      ));

      if (recoveries.isNotEmpty) {
        actions.add(PreventiveAction(
          text: "Continue the habits from your recent recovery.",
          explanation: "Your recovery trend is actively lowering your burnout forecast. Stick to these successful triggers.",
        ));
      } else {
        actions.add(PreventiveAction(
          text: "Gradually reintroduce tasks you may have deferred.",
          explanation: "With your burnout risk decreasing, you have more capacity to handle standard workloads.",
        ));
      }

      actions.add(PreventiveAction(
        text: "Take time to share your positive energy with others.",
        explanation: "Social connection during lower stress periods builds strong support networks for the future.",
      ));
    }

    // Ensure max 3 actions
    final topActions = actions.take(3).toList();

    return PreventiveInterventionPlan(
      actions: topActions,
      generatedAt: DateTime.now(),
      forecastTrend: forecast.trend,
    );
  }
}
