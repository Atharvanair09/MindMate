import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'situation_detection_engine.dart';

class ContextualFollowUpEngine {
  static final ContextualFollowUpEngine instance = ContextualFollowUpEngine._internal();
  ContextualFollowUpEngine._internal();

  /// Generates a contextual follow up question based on the user's detected situations.
  /// Returns a map with 'question', 'situation', and 'hash'.
  Future<Map<String, String>?> generateFollowUp() async {
    final situations = await SituationDetectionEngine.instance.detectSituations();
    if (situations.isEmpty) return null;

    // Pick the most confident situation
    final topSituation = situations.first.situationName;
    String question = _getQuestionForSituation(topSituation);

    return {
      'question': question,
      'situation': topSituation,
      'hash': md5.convert(utf8.encode(question)).toString(),
    };
  }

  String _getQuestionForSituation(String situation) {
    switch (situation) {
      case 'Exam Stress':
      case 'Academic Pressure':
        return 'How did today\'s revision session go?';
      case 'Sleep Issues':
        return 'Did you manage to get better sleep last night?';
      case 'Burnout':
      case 'Work Pressure':
        return 'How is your energy level compared with yesterday?';
      case 'Social Isolation':
      case 'Relationship Issues':
        return 'Have you had a chance to connect with anyone recently?';
      case 'Low Motivation':
        return 'Were you able to find any motivation for your tasks today?';
      case 'Financial Stress':
        return 'How are you feeling about your finances today?';
      case 'Decision Fatigue':
        return 'Did you find it easier to make choices today?';
      default:
        return 'How are you feeling about your current situation?';
    }
  }
}
