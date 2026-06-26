import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/wellness_plan.dart';
import '../../domain/models/detected_situation.dart';
import '../../domain/models/reflection_result.dart';
import '../../domain/models/mood_feature_vector.dart';
import 'situation_detection_engine.dart';
import 'reflection_engine.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../services/community/community_wellness_service.dart';

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
    String? effectivenessExplanation;
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

        // Check recent follow-ups for user feedback on plan
        bool hasPositiveFollowUp = false;
        bool hasNegativeFollowUp = false;
        final recentFollowUp = await IsarDatabase.instance.reflectionFollowUps
           .filter().resolvedEqualTo(true).sortByResolvedAtDesc().findFirst();
        if (recentFollowUp != null && recentFollowUp.userResponse != null) {
            final text = recentFollowUp.userResponse!.toLowerCase();
            if (text.contains("better") || text.contains("helped") || text.contains("good") || text.contains("improved")) {
                hasPositiveFollowUp = true;
            } else if (text.contains("worse") || text.contains("stressed") || text.contains("hard") || text.contains("overwhelmed")) {
                hasNegativeFollowUp = true;
            }
        }

        // Check community wellness for external stressors
        bool communityDeclining = false;
        try {
           final communities = await CommunityWellnessService.instance.getMonitoredCommunities();
           if (communities.any((c) => c.overallTrend == 'Needs Attention')) {
               communityDeclining = true;
           }
        } catch (_) {}

        if (burnoutImproved || moodImproved || hasPositiveFollowUp) {
          planStatus = "Improving";
          effectivenessExplanation = "Your mood and burnout levels are better today. Continuing to practice habits like taking breaks and resting seems to be helping!";
        } else if (burnoutWorsened || moodWorsened || hasNegativeFollowUp || communityDeclining) {
          planStatus = "Needs Attention";
          effectivenessExplanation = "We noticed some increased stress signals today. We've adjusted your plan to prioritize immediate relief and recovery.";
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
            "Complete one Pomodoro session.",
            "Review one chapter.",
            "Take a five-minute break every hour.",
            "Hydrate before studying."
          ];
          break;
        case 'Burnout':
        case 'Work Pressure':
          actions = [
            "Reduce workload where possible.",
            "Schedule a recovery break.",
            "Focus on one important task only."
          ];
          break;
        case 'Sleep Issues':
          actions = [
            "Avoid screens thirty minutes before bed.",
            "Maintain a consistent bedtime.",
            "Reduce caffeine intake this evening."
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
          "Reduce workload where possible.",
          "Schedule a recovery break.",
          "Focus on one important task only."
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
      effectivenessExplanation: effectivenessExplanation,
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
