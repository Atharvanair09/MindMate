import '../../data/database/isar_database.dart';
import '../../domain/models/detected_situation.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import 'reflection_engine.dart';
import '../weekly_reflection/weekly_reflection_service.dart';
import 'package:isar/isar.dart';

class SituationDetectionEngine {
  SituationDetectionEngine._privateConstructor();
  static final SituationDetectionEngine instance = SituationDetectionEngine._privateConstructor();

  final Map<String, List<String>> _situationKeywords = {
    'Exam Stress': ['exam', 'assignment', 'study', 'college', 'grades', 'test', 'deadline', 'semester'],
    'Burnout': ['exhausted', 'tired', 'drained', 'overwhelmed', 'burnout', "give up", "can't keep up", 'no energy'],
    'Sleep Issues': ['sleep', 'insomnia', 'nightmare', 'awake', 'tired', 'restless', "can't sleep"],
    'Academic Pressure': ['school', 'homework', 'project', 'professor', 'fail', 'class', 'gpa'],
    'Work Pressure': ['work', 'boss', 'meeting', 'shift', 'job', 'manager', 'stress', 'colleague', 'fired'],
    'Relationship Issues': ['argue', 'fight', 'breakup', 'partner', 'friend', 'toxic', 'misunderstand', 'lonely', 'ignore'],
    'Social Isolation': ['alone', 'lonely', 'no friends', 'isolated', 'ignored', 'left out', 'nobody'],
    'Low Motivation': ['unmotivated', 'lazy', 'procrastinate', 'pointless', 'bored', 'nothing to do', 'lost interest'],
    'Financial Stress': ['money', 'broke', 'rent', 'bills', 'expensive', 'debt', 'salary', 'paycheck'],
    'Decision Fatigue': ['decide', 'choice', 'options', 'too many', "don't know what to do", 'stuck', 'overthinking'],
  };

  Future<List<DetectedSituation>> detectSituations() async {
    final isar = IsarDatabase.instance;
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Gather text from Journals
    final journals = await isar.journalEntrys
        .filter()
        .createdAtGreaterThan(sevenDaysAgo)
        .findAll();
    
    // Gather text from Chats
    final chats = await isar.chatMessages
        .filter()
        .roleEqualTo('user')
        .and()
        .createdAtGreaterThan(sevenDaysAgo)
        .findAll();

    final allTextList = [
      ...journals.map((j) => j.content.toLowerCase()),
      ...chats.map((c) => c.message.toLowerCase())
    ];

    final combinedText = allTextList.join(' ');

    // Gather other signals
    final reflection = await ReflectionEngine.instance.getLatestReflection();
    final weeklyReflection = await WeeklyReflectionService.instance.getLatestReflection();

    final double burnoutScore = reflection?.burnoutScore.toDouble() ?? 0.0;
    final String burnoutTrend = weeklyReflection?.burnoutTrend ?? 'Stable';
    final String moodTrend = weeklyReflection?.moodTrend ?? 'Stable';

    // Mocked additional input sources
    final bool hasRecentRecovery = false;
    final bool hasNegativeHistoricalBehaviour = true; // Just a mocked signal
    final bool hasNegativePatterns = false;

    List<DetectedSituation> detectedSituations = [];

    for (var entry in _situationKeywords.entries) {
      final situationName = entry.key;
      final keywords = entry.value;

      List<String> keywordsTriggered = [];
      for (var kw in keywords) {
        if (combinedText.contains(kw.toLowerCase())) {
          keywordsTriggered.add(kw);
        }
      }

      double baseConfidence = keywordsTriggered.length * 15.0; // 15% per keyword match
      List<String> evidenceUsed = [];
      List<String> supportingFactors = [];
      List<String> signalsUsed = [];
      String reason = "";

      if (keywordsTriggered.isNotEmpty) {
        evidenceUsed.add("${keywordsTriggered.length} keywords matched");
        signalsUsed.add("Keyword Evidence");
        if (journals.isNotEmpty) signalsUsed.add("Journal Analysis");
        if (chats.isNotEmpty) signalsUsed.add("Chat Analysis");
      }

      // Add context based on Burnout and Mood
      if (burnoutScore > 60.0) {
        if (['Burnout', 'Exam Stress', 'Work Pressure', 'Academic Pressure'].contains(situationName)) {
          baseConfidence += 20.0;
          evidenceUsed.add("High Burnout Score ($burnoutScore)");
          signalsUsed.add("Current Burnout Score");
          supportingFactors.add("Elevated burnout levels contribute to this situation.");
        }
      }

      if (burnoutTrend == 'Increasing') {
        if (['Burnout', 'Exam Stress', 'Work Pressure', 'Financial Stress'].contains(situationName)) {
          baseConfidence += 15.0;
          evidenceUsed.add("Increasing Burnout Trend");
          signalsUsed.add("Burnout Trend");
          signalsUsed.add("Weekly Reflection");
          supportingFactors.add("Burnout has been getting worse over the week.");
        }
      }

      if (moodTrend == 'Decreasing') {
        baseConfidence += 10.0;
        evidenceUsed.add("Declining Mood Trend");
        signalsUsed.add("Mood Trend");
        signalsUsed.add("Mood History");
        supportingFactors.add("Recent decline in overall mood.");
      }
      
      if (hasNegativeHistoricalBehaviour) {
          signalsUsed.add("Historical Behaviour");
      }

      // Deduplicate signalsUsed
      signalsUsed = signalsUsed.toSet().toList();

      if (baseConfidence > 100.0) baseConfidence = 100.0;

      if (baseConfidence >= 40.0) {
        if (keywordsTriggered.isNotEmpty) {
          reason = "Detected based on recent conversations and journal entries discussing ${keywordsTriggered.take(2).join(', ')}.";
        } else {
          reason = "Detected based on overall burnout and mood trends.";
        }

        detectedSituations.add(
          DetectedSituation(
            situationName: situationName,
            confidence: baseConfidence,
            evidenceUsed: evidenceUsed,
            reason: reason,
            keywordsTriggered: keywordsTriggered,
            supportingFactors: supportingFactors,
            signalsUsed: signalsUsed,
            generatedAt: now,
          )
        );
      }
    }

    // Sort by confidence descending
    detectedSituations.sort((a, b) => b.confidence.compareTo(a.confidence));
    return detectedSituations;
  }
}
