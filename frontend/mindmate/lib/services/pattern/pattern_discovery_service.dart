import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/pattern_insight.dart';

class CandidateDebug {
  final String category;
  final int count;
  final double? mood;
  final double? burnout;
  final bool accepted;
  final String reason;
  final int historyDaysAvailable;
  final int requiredOccurrences;
  final String confidence;

  CandidateDebug({
    required this.category,
    required this.count,
    required this.mood,
    required this.burnout,
    required this.accepted,
    required this.reason,
    required this.historyDaysAvailable,
    required this.requiredOccurrences,
    required this.confidence,
  });
}

class PatternDiscoveryService {
  static final PatternDiscoveryService instance =
      PatternDiscoveryService._internal();
  PatternDiscoveryService._internal();

  static List<CandidateDebug> lastDebugInfo = [];

  Isar get isar => IsarDatabase.instance;

  /// Discovers behavioral patterns from the past 14 days and stores them as PatternInsight.
  Future<List<PatternInsight>> discoverPatterns() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 14));

    final journals = await isar.journalEntrys
        .filter()
        .isDeletedEqualTo(false)
        .and()
        .journalDateBetween(startDate, now)
        .findAll();

    final moodCheckIns = await isar.dailyMoodCheckIns
        .where()
        .dateBetween(DateTime.utc(startDate.year, startDate.month, startDate.day), 
                     DateTime.utc(now.year, now.month, now.day))
        .findAll();

    final patterns = <PatternInsight>[];

    // Delete existing patterns to avoid duplicates for the demo
    await isar.writeTxn(() async {
      await isar.patternInsights.clear();
    });

    // Clear debug info
    lastDebugInfo.clear();

    final historyDaysAvailable = await isar.dailyMoodCheckIns.count();
    final requiredOccurrences = historyDaysAvailable < 7 ? 1 : 2;

    // 1. Social Interaction (Positive Candidate)
    int socialCount = 0;
    List<double> socialMoods = [];
    List<double> socialBurnouts = [];
    for (final j in journals) {
      if (_containsAny(j.content.toLowerCase(), ['friend', 'friends', 'meetup', 'met friends', 'hangout', 'dinner with friends'])) {
        socialCount++;
        final mood = _getMoodForDate(moodCheckIns, j.journalDate);
        if (mood != null) socialMoods.add(mood);
        if (j.stressScore != null) socialBurnouts.add(j.stressScore!);
      }
    }
    _evaluatePositiveCandidate(
      patterns: patterns,
      category: 'Social Interaction',
      patternName: 'Social Recovery',
      description: 'Social interactions appear associated with improved mood.',
      count: socialCount,
      moods: socialMoods,
      burnouts: socialBurnouts,
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
    );

    // 2. Positive Journaling (Positive Candidate)
    int posJournalCount = 0;
    List<double> posJournalMoods = [];
    List<double> posJournalBurnouts = [];
    for (final j in journals) {
      if (_containsAny(j.content.toLowerCase(), ['amazing', 'great', 'happy', 'relaxed', 'enjoyed', 'productive', 'better', 'optimistic'])) {
        posJournalCount++;
        final mood = _getMoodForDate(moodCheckIns, j.journalDate);
        if (mood != null) posJournalMoods.add(mood);
        if (j.stressScore != null) posJournalBurnouts.add(j.stressScore!);
      }
    }
    _evaluatePositiveCandidate(
      patterns: patterns,
      category: 'Positive Journaling',
      patternName: 'Positive Reflection',
      description: 'Engaging in positive reflection appears associated with improved mood.',
      count: posJournalCount,
      moods: posJournalMoods,
      burnouts: posJournalBurnouts,
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
    );

    // 3. Exercise (Positive Candidate)
    int exerciseCount = 0;
    List<double> exerciseMoods = [];
    List<double> exerciseBurnouts = [];
    for (final j in journals) {
      if (_containsAny(j.content.toLowerCase(), ['workout', 'gym', 'run', 'walking', 'exercise'])) {
        exerciseCount++;
        final mood = _getMoodForDate(moodCheckIns, j.journalDate);
        if (mood != null) exerciseMoods.add(mood);
        if (j.stressScore != null) exerciseBurnouts.add(j.stressScore!);
      }
    }
    _evaluatePositiveCandidate(
      patterns: patterns,
      category: 'Exercise',
      patternName: 'Physical Recovery',
      description: 'Physical activity appears correlated with better mood.',
      count: exerciseCount,
      moods: exerciseMoods,
      burnouts: exerciseBurnouts,
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
    );

    // 4. Achievement (Positive Candidate)
    int achieveCount = 0;
    List<double> achieveMoods = [];
    List<double> achieveBurnouts = [];
    for (final j in journals) {
      if (_containsAny(j.content.toLowerCase(), ['completed', 'finished', 'accomplished', 'progress', 'project completed'])) {
        achieveCount++;
        final mood = _getMoodForDate(moodCheckIns, j.journalDate);
        if (mood != null) achieveMoods.add(mood);
        if (j.stressScore != null) achieveBurnouts.add(j.stressScore!);
      }
    }
    _evaluatePositiveCandidate(
      patterns: patterns,
      category: 'Achievement',
      patternName: 'Project Progress',
      description: 'Task completion appears associated with reduced stress.',
      count: achieveCount,
      moods: achieveMoods,
      burnouts: achieveBurnouts,
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
    );

    // 5. Sleep Challenges -> Lower Mood
    int sleepCount = 0;
    List<double> sleepMoods = [];
    for (final j in journals) {
      if (_containsAny(j.content.toLowerCase(), ['sleep', 'tired', 'exhausted', 'insomnia', 'restless', 'fatigue'])) {
        sleepCount++;
        final mood = _getMoodForDate(moodCheckIns, j.journalDate);
        if (mood != null) sleepMoods.add(mood);
      }
    }
    _evaluateNegativeCandidate(
      patterns: patterns,
      category: 'Sleep Challenges',
      patternName: 'Sleep Challenges',
      description: 'Sleep disruption appears associated with lower mood.',
      count: sleepCount,
      values: sleepMoods,
      isMood: true,
      association: 'Lower Mood',
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
    );

    // 6. Academic Pressure -> Higher Burnout / Stress
    int academicCount = 0;
    List<double> academicStress = [];
    for (final j in journals) {
      if (_containsAny(j.content.toLowerCase(), ['exam', 'deadline', 'assignment', 'test', 'study', 'project'])) {
        academicCount++;
        academicStress.add(j.stressScore ?? 0.0);
      }
    }
    _evaluateNegativeCandidate(
      patterns: patterns,
      category: 'Academic Pressure',
      patternName: 'Academic Pressure',
      description: 'Academic pressure appears linked to increased stress and burnout risk.',
      count: academicCount,
      values: academicStress,
      isMood: false,
      association: 'Higher Burnout',
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
    );

    // 7. Work Stress -> Higher Burnout
    int workCount = 0;
    List<double> workStress = [];
    for (final j in journals) {
      if (_containsAny(j.content.toLowerCase(), ['work', 'job', 'boss', 'office', 'meeting', 'shift'])) {
        workCount++;
        workStress.add(j.stressScore ?? 0.0);
      }
    }
    _evaluateNegativeCandidate(
      patterns: patterns,
      category: 'Work Stress',
      patternName: 'Work Stress',
      description: 'Work-related pressure appears linked to increased stress and burnout risk.',
      count: workCount,
      values: workStress,
      isMood: false,
      association: 'Higher Burnout',
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
    );

    // 8. Negative Journaling -> Lower Mood
    int negJournalCount = 0;
    for (final j in journals) {
      if ((j.sentimentScore ?? 0.0) < -0.3) {
        negJournalCount++;
      }
    }
    _evaluateNegativeCandidate(
      patterns: patterns,
      category: 'Negative Journaling',
      patternName: 'Negative Journaling',
      description: 'Frequent negative reflection appears associated with lower mood trends.',
      count: negJournalCount,
      values: [],
      isMood: true,
      association: 'Lower Mood',
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
    );

    await isar.writeTxn(() async {
      await isar.patternInsights.putAll(patterns);
    });

    debugPrint('[PatternDiscoveryService] Generated ${patterns.length} patterns.');
    return patterns;
  }

  void _evaluatePositiveCandidate({
    required List<PatternInsight> patterns,
    required String category,
    required String patternName,
    required String description,
    required int count,
    required List<double> moods,
    required List<double> burnouts,
    required int historyDaysAvailable,
    required int requiredOccurrences,
  }) {
    final double? avgMood = moods.isEmpty ? null : moods.reduce((a, b) => a + b) / moods.length;
    final double? avgBurnout = burnouts.isEmpty ? null : burnouts.reduce((a, b) => a + b) / burnouts.length;

    bool accepted = false;
    String reason = '';
    String association = '';

    if (count < requiredOccurrences) {
      reason = 'Not enough evidence ($count < $requiredOccurrences)';
    } else {
      if (avgMood != null && avgMood >= 4.0) {
        accepted = true;
        association = 'Improved Mood';
        reason = 'Associated with High Mood (${avgMood.toStringAsFixed(1)})';
      } else if (avgBurnout != null && avgBurnout <= 0.3) {
        accepted = true;
        association = 'Reduced Stress';
        reason = 'Associated with Low Burnout (${avgBurnout.toStringAsFixed(2)})';
      } else {
        reason = 'Insufficient or weak evidence for mood/burnout changes';
      }
    }

    String confidence = 'Preliminary';
    if (count >= 3) {
      confidence = 'High';
    } else if (count == 2) {
      confidence = 'Moderate';
    }

    if (accepted) {
      patterns.add(_createPattern(
        name: patternName,
        description: description,
        evidence: count,
        association: association,
        confidence: confidence,
      ));
    }

    lastDebugInfo.add(CandidateDebug(
      category: category,
      count: count,
      mood: avgMood,
      burnout: avgBurnout,
      accepted: accepted,
      reason: reason,
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
      confidence: confidence,
    ));
  }

  void _evaluateNegativeCandidate({
    required List<PatternInsight> patterns,
    required String category,
    required String patternName,
    required String description,
    required int count,
    required List<double> values,
    required bool isMood,
    required String association,
    required int historyDaysAvailable,
    required int requiredOccurrences,
  }) {
    final double avgValue = values.isEmpty ? 0.0 : values.reduce((a, b) => a + b) / values.length;

    bool accepted = false;
    String reason = '';

    if (count < requiredOccurrences) {
      reason = 'Not enough evidence ($count < $requiredOccurrences)';
    } else {
      if (category == 'Negative Journaling') {
        accepted = true;
        reason = 'Frequent negative reflection';
      } else if (isMood && avgValue <= 3.0) {
        accepted = true;
        reason = 'Associated with Lower Mood (${avgValue.toStringAsFixed(1)})';
      } else if (!isMood && avgValue > 0.4) {
        accepted = true;
        reason = 'Associated with Higher Stress (${avgValue.toStringAsFixed(2)})';
      } else {
        reason = 'Insufficient or weak evidence for mood/burnout changes';
      }
    }

    String confidence = 'Preliminary';
    if (count >= 3) {
      confidence = 'High';
    } else if (count == 2) {
      confidence = 'Moderate';
    }

    if (accepted) {
      patterns.add(_createPattern(
        name: patternName,
        description: description,
        evidence: count,
        association: association,
        confidence: confidence,
      ));
    }

    lastDebugInfo.add(CandidateDebug(
      category: category,
      count: count,
      mood: isMood ? (values.isEmpty ? null : avgValue) : null,
      burnout: !isMood ? (values.isEmpty ? null : avgValue) : null,
      accepted: accepted,
      reason: reason,
      historyDaysAvailable: historyDaysAvailable,
      requiredOccurrences: requiredOccurrences,
      confidence: confidence,
    ));
  }

  PatternInsight _createPattern({
    required String name,
    required String description,
    required int evidence,
    required String association,
    required String confidence,
  }) {

    return PatternInsight()
      ..patternName = name
      ..description = description
      ..supportingEvidence = evidence
      ..associationType = association
      ..confidence = confidence
      ..generatedAt = DateTime.now();
  }

  bool _containsAny(String text, List<String> keywords) {
    for (final kw in keywords) {
      if (text.contains(kw)) return true;
    }
    return false;
  }

  double? _getMoodForDate(List<DailyMoodCheckIn> checkIns, DateTime date) {
    for (final c in checkIns) {
      if (c.date.year == date.year && c.date.month == date.month && c.date.day == date.day) {
        return _moodLevelToValue(c.moodLevel);
      }
    }
    return null;
  }

  double _moodLevelToValue(String level) {
    switch (level) {
      case 'GREAT': return 5.0;
      case 'GOOD': return 4.0;
      case 'OKAY': return 3.0;
      case 'LOW': return 2.0;
      case 'STRUGGLING': return 1.0;
      default: return 3.0;
    }
  }

  /// Gets all stored patterns from Isar.
  Future<List<PatternInsight>> getPatterns() async {
    return isar.patternInsights.where().sortByGeneratedAtDesc().findAll();
  }
}
