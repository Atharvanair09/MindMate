import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/wellness_plan.dart';
import '../../domain/models/detected_situation.dart';
import '../../domain/models/reflection_result.dart';
import '../../domain/models/mood_feature_vector.dart';
import 'situation_detection_engine.dart';
import 'reflection_engine.dart';

class WellnessPlanGenerator {
  static final WellnessPlanGenerator instance = WellnessPlanGenerator._internal();

  WellnessPlanGenerator._internal();

  Future<WellnessPlan> generatePlan() async {
    // 1. Fetch Detected Situations
    final List<DetectedSituation> situations = await SituationDetectionEngine.instance.detectSituations();
    
    // 2. Fetch Reflection for Burnout and Mood
    final ReflectionResult? reflection = await ReflectionEngine.instance.getLatestReflection();
    
    final double burnoutScore = reflection?.burnoutScore.toDouble() ?? 0.0;
    final int moodScore = reflection?.moodScore ?? 3; // 1-5, 3 is neutral
    
    // Evaluate Effectiveness (Yesterday vs Today)
    String planStatus = "Stable";
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      
      final previousVector = await IsarDatabase.instance.moodFeatureVectors
            .filter()
            .dateLessThan(startOfDay)
            .sortByDateDesc()
            .findFirst();

      if (previousVector != null) {
        final previousReflection = await ReflectionEngine.instance.getReflectionForVector(previousVector);
        
        final prevBurnout = previousReflection.burnoutScore.toDouble();
        final prevMood = previousReflection.moodScore ?? 3;

        bool burnoutImproved = burnoutScore <= (prevBurnout - 10);
        bool burnoutWorsened = burnoutScore >= (prevBurnout + 10);
        bool moodImproved = moodScore > prevMood;
        bool moodWorsened = moodScore < prevMood;

        if (burnoutImproved || moodImproved) {
          planStatus = "Improving";
        } else if (burnoutWorsened || moodWorsened) {
          planStatus = "Needs Attention";
        }
      }
    } catch (e) {
      // Fallback to stable on error
    }

    List<String> actions = [];
    String primarySituation = "General Wellness";

    // 3. Rule-based logic for situations
    if (planStatus == "Needs Attention") {
      primarySituation = "Immediate Relief Needed";
      actions = [
        "Stop what you're doing for 5 minutes.",
        "Try a 4-7-8 breathing exercise.",
        "Reach out to someone you trust.",
        "Prioritize rest for the remainder of the day."
      ];
    } else if (situations.isNotEmpty) {
      // Pick the most confident situation
      final topSituation = situations.first;
      primarySituation = topSituation.situationName;

      switch (topSituation.situationName) {
        case 'Exam Stress':
        case 'Academic Pressure':
          actions = [
            "Take a 5-minute break.",
            "Complete one focused study session.",
            "Avoid multitasking.",
            "Hydrate."
          ];
          break;
        case 'Burnout':
        case 'Work Pressure':
          actions = [
            "Reduce workload.",
            "Take regular breaks.",
            "Prioritize sleep.",
            "Avoid unnecessary commitments."
          ];
          break;
        case 'Sleep Issues':
          actions = [
            "Reduce screen time.",
            "Maintain consistent bedtime.",
            "Avoid caffeine late in the day.",
            "Try a relaxation technique."
          ];
          break;
        case 'Social Isolation':
        case 'Relationship Difficulties':
          actions = [
            "Reach out to one friend or family member.",
            "Reflect on positive interactions.",
            "Engage in a hobby you enjoy.",
            "Practice self-compassion."
          ];
          break;
        case 'Low Motivation':
          actions = [
            "Set one small, achievable goal for today.",
            "Take a short walk outside.",
            "Break tasks into smaller steps.",
            "Reward yourself for completing a task."
          ];
          break;
        default:
          actions = _getDefaultActions(moodScore, burnoutScore);
          break;
      }
    } else {
      // No specific situations detected, use burnout and mood
      if (burnoutScore > 60.0) {
        primarySituation = "Burnout Recovery";
        actions = [
          "Reduce workload.",
          "Take regular breaks.",
          "Prioritize sleep.",
          "Avoid unnecessary commitments."
        ];
      } else {
        actions = _getDefaultActions(moodScore, burnoutScore);
      }
    }

    // Ensure maximum 4 actions
    final limitedActions = actions.take(4).map((text) => WellnessAction(text: text)).toList();

    return WellnessPlan(
      actions: limitedActions,
      primarySituation: primarySituation,
      generatedAt: DateTime.now(),
      planStatus: planStatus,
    );
  }

  List<String> _getDefaultActions(int moodScore, double burnoutScore) {
    if (moodScore <= 2) {
      return [
        "Take it easy today.",
        "Do one thing that brings you comfort.",
        "Talk to someone you trust.",
        "Practice mindful breathing."
      ];
    } else if (moodScore >= 4) {
      return [
        "Note what went well today.",
        "Maintain your healthy routines.",
        "Share your positive energy.",
        "Reflect on your successes."
      ];
    } else {
      return [
        "Stay hydrated throughout the day.",
        "Take a brief walk or stretch.",
        "Maintain a balanced diet.",
        "Take time to unwind tonight."
      ];
    }
  }
}
