import '../../domain/models/detected_situation.dart';
import '../../domain/models/coping_tool.dart';

class CopingToolkitService {
  CopingToolkitService._();
  static final CopingToolkitService instance = CopingToolkitService._();

  List<CopingTool> getRecommendedTools(DetectedSituation situation) {
    final nameLower = situation.situationName.toLowerCase();
    
    if (nameLower.contains('exam') || nameLower.contains('study')) {
      return [
        CopingTool(
          id: 'pomodoro',
          name: 'Pomodoro Timer',
          description: 'Break down your study sessions into focused intervals.',
          iconName: 'timer',
        ),
        CopingTool(
          id: 'task_breakdown',
          name: 'Task Breakdown',
          description: 'Organize your syllabus into manageable chunks.',
          iconName: 'list_alt',
        ),
        CopingTool(
          id: 'study_reset',
          name: 'Study Reset',
          description: 'Take a guided 5-minute break to clear your mind.',
          iconName: 'self_improvement',
        ),
      ];
    } else if (nameLower.contains('burnout') || nameLower.contains('exhaustion')) {
      return [
        CopingTool(
          id: 'breathing_exercise',
          name: 'Guided Breathing',
          description: 'Follow a guided box breathing session to reduce stress.',
          iconName: 'air',
        ),
        CopingTool(
          id: 'recovery_checklist',
          name: 'Recovery Checklist',
          description: 'Ensure you are meeting your basic needs for recovery.',
          iconName: 'checklist',
        ),
        CopingTool(
          id: 'stress_journal',
          name: 'Stress Journal',
          description: 'Write down what is overwhelming you to gain perspective.',
          iconName: 'book',
        ),
      ];
    } else if (nameLower.contains('sleep') || nameLower.contains('insomnia')) {
      return [
        CopingTool(
          id: 'wind_down_routine',
          name: 'Wind-down Routine',
          description: 'Follow a 30-minute pre-sleep relaxation guide.',
          iconName: 'nightlight_round',
        ),
        CopingTool(
          id: 'sleep_hygiene',
          name: 'Sleep Hygiene Tips',
          description: 'Learn best practices for a restful night\'s sleep.',
          iconName: 'tips_and_updates',
        ),
      ];
    } else if (nameLower.contains('social') || nameLower.contains('isolation') || nameLower.contains('lonely')) {
      return [
        CopingTool(
          id: 'conversation_starters',
          name: 'Conversation Starters',
          description: 'Icebreakers and topics to help you connect with others.',
          iconName: 'chat_bubble_outline',
        ),
        CopingTool(
          id: 'community_recommendations',
          name: 'Community Recommendations',
          description: 'Find support groups and communities that share your interests.',
          iconName: 'people_outline',
        ),
      ];
    }
    
    // Default tools for general stress or unknown situations
    return [
      CopingTool(
        id: 'breathing_exercise_default',
        name: 'Quick Breathing',
        description: 'A 2-minute breathing exercise to center yourself.',
        iconName: 'air',
      ),
      CopingTool(
        id: 'journal_default',
        name: 'Quick Journal',
        description: 'Jot down your current thoughts.',
        iconName: 'edit_note',
      ),
    ];
  }
}
