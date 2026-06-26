import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../ml/situation_detection_engine.dart';
import '../../domain/models/app_notification.dart';

class SmartCheckInService {
  SmartCheckInService._privateConstructor();
  static final SmartCheckInService instance = SmartCheckInService._privateConstructor();

  final Map<String, String> _situationMessages = {
    'Exam Stress': "How did today's study session go?",
    'Sleep Issues': "Did you sleep better last night?",
    'Burnout': "How is your energy level compared to yesterday?",
    'Academic Pressure': "Are you keeping up with your coursework?",
    'Work Pressure': "How was your workday?",
    'Relationship Difficulties': "How are things with your relationships?",
    'Social Isolation': "Have you connected with anyone recently?",
    'Low Motivation': "What's one small thing you can do today?",
  };

  final String _fallbackMessage = "How are you feeling right now?";
  final int _maxCheckInsPerDay = 3;

  Future<String?> generateCheckInMessage() async {
    final isar = IsarDatabase.instance;
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);

    // 1. Check daily limit
    final todayCheckIns = await isar.appNotifications
        .filter()
        .typeEqualTo('smart_check_in')
        .and()
        .createdAtGreaterThan(startOfDay)
        .sortByCreatedAtDesc()
        .findAll();

    if (todayCheckIns.length >= _maxCheckInsPerDay) {
      return null; // Reached daily limit
    }

    // 2. Determine highest confidence situation
    final situations = await SituationDetectionEngine.instance.detectSituations();
    
    String? proposedMessage;
    if (situations.isNotEmpty) {
      // Pick the top one
      final topSituation = situations.first;
      proposedMessage = _situationMessages[topSituation.situationName];
    }
    
    proposedMessage ??= _fallbackMessage;

    // 3. Avoid repetition
    // Check the last few notifications to ensure we don't repeat the same question sequentially
    if (todayCheckIns.isNotEmpty) {
      final lastCheckIn = todayCheckIns.first;
      if (lastCheckIn.description == proposedMessage) {
        // Find another situation if possible
        bool foundAlternative = false;
        for (var i = 1; i < situations.length; i++) {
          final altMessage = _situationMessages[situations[i].situationName];
          if (altMessage != null && altMessage != lastCheckIn.description) {
            proposedMessage = altMessage;
            foundAlternative = true;
            break;
          }
        }
        
        if (!foundAlternative) {
          // If we can't find an alternative situation, and it's repeating, use fallback if fallback is not what repeated
          if (lastCheckIn.description != _fallbackMessage) {
            proposedMessage = _fallbackMessage;
          } else {
            // Even fallback is repeating, just don't send one
            return null; 
          }
        }
      }
    }

    return proposedMessage;
  }
}
