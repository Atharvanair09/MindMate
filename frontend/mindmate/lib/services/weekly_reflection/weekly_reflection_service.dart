import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/weekly_reflection.dart';
import '../ml/reflection_engine.dart';

class WeeklyReflectionService {
  static final WeeklyReflectionService instance =
      WeeklyReflectionService._internal();
  WeeklyReflectionService._internal();

  Isar get isar => IsarDatabase.instance;

  // ─────────────────────────────────────────────────────────────────────────
  //  Public API
  // ─────────────────────────────────────────────────────────────────────────

  /// Returns the most recently generated [WeeklyReflection], or null if none.
  Future<WeeklyReflection?> getLatestReflection() async {
    return isar.weeklyReflections
        .where()
        .sortByGeneratedAtDesc()
        .findFirst();
  }

  /// Returns true if we have ≥ 7 days of mood data AND no reflection yet for
  /// the current ISO week start.
  Future<bool> shouldAutoGenerate() async {
    final count = await isar.dailyMoodCheckIns.count();
    if (count < 7) return false;
    final weekStart = _currentWeekStart();
    final existing = await isar.weeklyReflections
        .where()
        .weekStartDateEqualTo(weekStart)
        .findFirst();
    return existing == null;
  }

  /// Generates (or re-generates) the weekly reflection for the last 7 days
  /// and persists it to Isar.  Returns the saved [WeeklyReflection].
  Future<WeeklyReflection> generateReflection() async {
    final now = DateTime.now();
    final weekEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final weekStart = weekEnd.subtract(const Duration(days: 6));
    final weekStartMidnight =
        DateTime(weekStart.year, weekStart.month, weekStart.day);

    // ── 1. Mood Data ──────────────────────────────────────────────────────
    final moodCheckIns = await _getMoodCheckInsForRange(weekStart, weekEnd);

    // ── 2. Feature Vectors (for burnout) ──────────────────────────────────
    final vectors = await _getVectorsForRange(weekStart, weekEnd);

    // ── 3. Journal Entries ────────────────────────────────────────────────
    final journals = await _getJournalsForRange(weekStart, weekEnd);

    // ── 4. Chat Messages (user only) ──────────────────────────────────────
    final chats = await _getUserChatsForRange(weekStart, weekEnd);

    // ── 5. Reflection Follow-Ups ──────────────────────────────────────────
    final followUps = await _getFollowUpsForRange(weekStart, weekEnd);

    // ── Calculate averages ────────────────────────────────────────────────
    final moodValues = _extractMoodValues(moodCheckIns);
    final double avgMood =
        moodValues.isEmpty ? 0.0 : moodValues.reduce((a, b) => a + b) / moodValues.length;

    final burnoutScores = await _computeDailyBurnouts(vectors);
    final double avgBurnout = burnoutScores.isEmpty
        ? 0.0
        : burnoutScores.reduce((a, b) => a + b) / burnoutScores.length;

    // ── Trends ────────────────────────────────────────────────────────────
    final moodTrend = _computeMoodTrend(moodValues);
    final burnoutTrend = _computeBurnoutTrend(burnoutScores);

    // ── Indicators ────────────────────────────────────────────────────────
    final positiveIndicators =
        _buildPositiveIndicators(journals, chats, followUps, moodValues);
    final negativeIndicators =
        _buildNegativeIndicators(journals, chats, followUps, moodValues);

    // ── Patterns ──────────────────────────────────────────────────────────
    final keyPatterns = _detectPatterns(journals, chats, moodValues);

    // ── Summary & Suggestion ──────────────────────────────────────────────
    final summary =
        _buildSummary(moodTrend, burnoutTrend, avgMood, avgBurnout);
    final suggestion = _buildSuggestion(moodTrend, burnoutTrend);

    // ── Confidence ────────────────────────────────────────────────────────
    final confidence = _computeConfidence(
      moodCheckIns: moodCheckIns,
      journals: journals,
      chats: chats,
      burnoutScores: burnoutScores,
      followUps: followUps,
    );

    // ── Persist ───────────────────────────────────────────────────────────
    final reflection = WeeklyReflection()
      ..weekStartDate = weekStartMidnight
      ..weekEndDate = weekEnd
      ..averageMoodScore = avgMood
      ..averageBurnoutScore = avgBurnout
      ..burnoutTrend = burnoutTrend
      ..moodTrend = moodTrend
      ..positiveIndicators = positiveIndicators
      ..negativeIndicators = negativeIndicators
      ..keyPatterns = keyPatterns
      ..summary = summary
      ..suggestion = suggestion
      ..confidence = confidence
      ..generatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.weeklyReflections.put(reflection);
    });

    debugPrint('[WeeklyReflectionService] Reflection generated. '
        'Mood: $moodTrend | Burnout: $burnoutTrend | Confidence: $confidence%');

    return reflection;
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Data Fetchers
  // ─────────────────────────────────────────────────────────────────────────

  Future<List<DailyMoodCheckIn>> _getMoodCheckInsForRange(
      DateTime start, DateTime end) async {
    final utcStart = DateTime.utc(start.year, start.month, start.day);
    final utcEnd = DateTime.utc(end.year, end.month, end.day);
    return isar.dailyMoodCheckIns
        .where()
        .dateBetween(utcStart, utcEnd)
        .sortByDate()
        .findAll();
  }

  Future<List<MoodFeatureVector>> _getVectorsForRange(
      DateTime start, DateTime end) async {
    return isar.moodFeatureVectors
        .filter()
        .dateBetween(start, end)
        .sortByDate()
        .findAll();
  }

  Future<List<JournalEntry>> _getJournalsForRange(
      DateTime start, DateTime end) async {
    return isar.journalEntrys
        .filter()
        .isDeletedEqualTo(false)
        .and()
        .journalDateBetween(start, end)
        .findAll();
  }

  Future<List<ChatMessage>> _getUserChatsForRange(
      DateTime start, DateTime end) async {
    return isar.chatMessages
        .filter()
        .roleEqualTo('user')
        .and()
        .createdAtBetween(start, end)
        .findAll();
  }

  Future<List<ReflectionFollowUp>> _getFollowUpsForRange(
      DateTime start, DateTime end) async {
    return isar.reflectionFollowUps
        .filter()
        .createdAtBetween(start, end)
        .findAll();
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Computation Helpers
  // ─────────────────────────────────────────────────────────────────────────

  List<double> _extractMoodValues(List<DailyMoodCheckIn> checkIns) {
    return checkIns.map((c) => _moodLevelToValue(c.moodLevel)).toList();
  }

  double _moodLevelToValue(String level) {
    switch (level) {
      case 'GREAT':
        return 5.0;
      case 'GOOD':
        return 4.0;
      case 'OKAY':
        return 3.0;
      case 'LOW':
        return 2.0;
      case 'STRUGGLING':
        return 1.0;
      default:
        return 3.0;
    }
  }

  Future<List<double>> _computeDailyBurnouts(
      List<MoodFeatureVector> vectors) async {
    final scores = <double>[];
    for (final vector in vectors) {
      try {
        final result =
            await ReflectionEngine.instance.getReflectionForVector(vector);
        scores.add(result.burnoutScore.toDouble());
      } catch (_) {
        // Skip if computation fails for a given day
      }
    }
    return scores;
  }

  /// Compares first-3 vs last-3 mood averages.
  String _computeMoodTrend(List<double> values) {
    if (values.length < 4) return 'Stable';
    final first = values.take(3).toList();
    final last = values.reversed.take(3).toList();
    final firstAvg = first.reduce((a, b) => a + b) / first.length;
    final lastAvg = last.reduce((a, b) => a + b) / last.length;
    final delta = lastAvg - firstAvg;
    if (delta > 0.4) return 'Improving';
    if (delta < -0.4) return 'Declining';
    return 'Stable';
  }

  /// Compares first-3 vs last-3 burnout averages.
  String _computeBurnoutTrend(List<double> scores) {
    if (scores.length < 4) return 'Stable';
    final first = scores.take(3).toList();
    final last = scores.reversed.take(3).toList();
    final firstAvg = first.reduce((a, b) => a + b) / first.length;
    final lastAvg = last.reduce((a, b) => a + b) / last.length;
    final delta = lastAvg - firstAvg;
    if (delta < -5) return 'Improving';
    if (delta > 5) return 'Increasing';
    return 'Stable';
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Positive Indicators
  // ─────────────────────────────────────────────────────────────────────────

  List<String> _buildPositiveIndicators(
    List<JournalEntry> journals,
    List<ChatMessage> chats,
    List<ReflectionFollowUp> followUps,
    List<double> moodValues,
  ) {
    final indicators = <String>[];

    // Low burnout journals / positive sentiment
    for (final j in journals) {
      if ((j.sentimentScore ?? 0) > 0.3) {
        final kw = j.emotionalKeywords;
        if (kw != null && kw.isNotEmpty) {
          final snippet = kw.split(',').first.trim();
          indicators
              .add('Positive journal: "${snippet.length > 30 ? snippet.substring(0, 30) : snippet}"');
        } else {
          indicators.add('Positive journal entry detected.');
        }
        if (indicators.length >= 3) break;
      }
    }

    // Positive chat messages
    for (final c in chats) {
      if (indicators.length >= 3) break;
      if ((c.sentimentScore ?? 0) > 0.3) {
        final snippet = c.message.length > 35
            ? '${c.message.substring(0, 32)}…'
            : c.message;
        indicators.add('Positive conversation: "$snippet"');
      }
    }

    // Resolved follow-ups with user context
    for (final f in followUps) {
      if (indicators.length >= 3) break;
      if (f.resolved && f.userResponse != null && f.userResponse!.isNotEmpty) {
        final resp = f.userResponse!;
        if (_containsAny(resp.toLowerCase(),
            ['friend', 'family', 'better', 'good', 'great', 'happy', 'walk', 'rest', 'relax'])) {
          indicators.add('Resolved conflict: "${resp.length > 35 ? '${resp.substring(0, 32)}…' : resp}"');
        }
      }
    }

    // High-mood days
    final greatDays = moodValues.where((v) => v >= 4).length;
    if (greatDays > 0 && indicators.length < 3) {
      indicators.add('$greatDays day${greatDays > 1 ? 's' : ''} with high mood (GOOD or GREAT).');
    }

    // Social/recovery keywords in journal
    for (final j in journals) {
      if (indicators.length >= 3) break;
      final content = j.content.toLowerCase();
      if (_containsAny(content, ['friend', 'family', 'social', 'hang out', 'coffee', 'dinner'])) {
        indicators.add('Spent time with friends or family.');
        break;
      }
    }

    return indicators.take(3).toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Negative Indicators
  // ─────────────────────────────────────────────────────────────────────────

  List<String> _buildNegativeIndicators(
    List<JournalEntry> journals,
    List<ChatMessage> chats,
    List<ReflectionFollowUp> followUps,
    List<double> moodValues,
  ) {
    final indicators = <String>[];

    // Repeated LOW mood
    final lowDays = moodValues.where((v) => v <= 2).length;
    if (lowDays >= 2) {
      indicators.add('$lowDays day${lowDays > 1 ? 's' : ''} with low mood (LOW or STRUGGLING).');
    }

    // High-stress journals
    for (final j in journals) {
      if (indicators.length >= 3) break;
      if ((j.stressScore ?? 0) > 0.6) {
        final kw = j.emotionalKeywords;
        if (kw != null && kw.isNotEmpty) {
          final snippet = kw.split(',').first.trim();
          indicators.add('High-stress journal: "$snippet"');
        } else {
          indicators.add('High-stress journal entry detected.');
        }
      }
    }

    // Negative chats
    for (final c in chats) {
      if (indicators.length >= 3) break;
      if ((c.sentimentScore ?? 0) < -0.3) {
        indicators.add('Elevated emotional stress detected in conversations.');
        break;
      }
    }

    // Unresolved follow-up conflicts with burnout/trend flags
    final unresolved =
        followUps.where((f) => !f.resolved && !f.dismissed).length;
    if (unresolved > 0 && indicators.length < 3) {
      indicators.add('$unresolved unresolved mood conflict${unresolved > 1 ? 's' : ''} this week.');
    }

    // Academic/deadline stress keywords
    for (final j in journals) {
      if (indicators.length >= 3) break;
      final content = j.content.toLowerCase();
      if (_containsAny(
          content, ['deadline', 'exam', 'assignment', 'stressed', 'overwhelmed', 'anxious'])) {
        indicators.add('Academic or work pressure noted in journal entries.');
        break;
      }
    }

    return indicators.take(3).toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Pattern Detection
  // ─────────────────────────────────────────────────────────────────────────

  List<String> _detectPatterns(
    List<JournalEntry> journals,
    List<ChatMessage> chats,
    List<double> moodValues,
  ) {
    final patterns = <String>[];

    // Pattern 1: Social activity + good mood
    bool hasSocialActivity = journals.any((j) =>
        _containsAny(j.content.toLowerCase(),
            ['friend', 'family', 'social', 'hang out', 'met', 'coffee', 'dinner']));
    if (hasSocialActivity &&
        moodValues.any((v) => v >= 4) &&
        patterns.length < 4) {
      patterns.add(
          'Social interactions appear associated with improved mood.');
    }

    // Pattern 2: Academic pressure → stress
    bool hasAcademicStress = journals.any((j) =>
        _containsAny(j.content.toLowerCase(),
            ['deadline', 'exam', 'assignment', 'test', 'study', 'project']));
    bool hasHighStressJournal = journals.any((j) => (j.stressScore ?? 0) > 0.5);
    if (hasAcademicStress && hasHighStressJournal && patterns.length < 4) {
      patterns.add(
          'Academic pressure appears linked to increased stress.');
    }

    // Pattern 3: Sleep disruption → low mood
    bool hasSleepIssues = journals.any((j) =>
        _containsAny(j.content.toLowerCase(),
            ['sleep', 'tired', 'exhausted', 'insomnia', 'rest', 'fatigue']));
    if (hasSleepIssues &&
        moodValues.any((v) => v <= 2) &&
        patterns.length < 4) {
      patterns.add(
          'Sleep disruption appears associated with lower mood.');
    }

    // Pattern 4: Exercise / movement + positive mood
    bool hasExercise = journals.any((j) =>
        _containsAny(j.content.toLowerCase(),
            ['gym', 'walk', 'run', 'exercise', 'workout', 'jog', 'sport']));
    if (hasExercise && moodValues.isNotEmpty &&
        moodValues.reduce((a, b) => a + b) / moodValues.length > 3.0 &&
        patterns.length < 4) {
      patterns.add(
          'Physical activity appears correlated with better mood scores.');
    }

    // Pattern 5: Negative chat sentiment + negative journal
    bool hasChatStress = chats.any((c) => (c.sentimentScore ?? 0) < -0.3);
    bool hasNegativeJournal =
        journals.any((j) => (j.sentimentScore ?? 0) < -0.3);
    if (hasChatStress && hasNegativeJournal && patterns.length < 4) {
      patterns.add(
          'Negative emotional signals appear consistently across journals and conversations.');
    }

    return patterns;
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Summary & Suggestion
  // ─────────────────────────────────────────────────────────────────────────

  String _buildSummary(
    String moodTrend,
    String burnoutTrend,
    double avgMood,
    double avgBurnout,
  ) {
    final moodLabel = avgMood >= 4.0
        ? 'generally positive'
        : avgMood >= 3.0
            ? 'moderate'
            : 'challenging';

    final burnoutLabel = avgBurnout < 35
        ? 'low'
        : avgBurnout < 70
            ? 'moderate'
            : 'high';

    if (moodTrend == 'Improving' && burnoutTrend != 'Increasing') {
      return 'This week showed $moodLabel wellness levels with encouraging signs of '
          'recovery. Mood improved toward the end of the week and burnout risk '
          'remained $burnoutLabel.';
    } else if (moodTrend == 'Declining' || burnoutTrend == 'Increasing') {
      return 'This week showed $burnoutLabel burnout risk with some stress signals. '
          'Mood trended $moodTrend and burnout risk was $burnoutTrend toward the '
          'end of the week. Focus on rest and recovery.';
    } else {
      return 'This week showed $moodLabel stress levels with a relatively stable '
          'pattern. Mood was $moodTrend and burnout risk remained $burnoutLabel '
          'throughout the week.';
    }
  }

  String _buildSuggestion(String moodTrend, String burnoutTrend) {
    if (burnoutTrend == 'Increasing') {
      return 'Consider prioritising rest and reducing stressors where possible.';
    }
    if (moodTrend == 'Improving') {
      return 'Continue the routines that have supported recent progress.';
    }
    if (moodTrend == 'Declining') {
      return 'Reconnect with activities that have helped your mood in the past.';
    }
    return 'Maintain consistency and continue daily check-ins.';
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Confidence
  // ─────────────────────────────────────────────────────────────────────────

  double _computeConfidence({
    required List<DailyMoodCheckIn> moodCheckIns,
    required List<JournalEntry> journals,
    required List<ChatMessage> chats,
    required List<double> burnoutScores,
    required List<ReflectionFollowUp> followUps,
  }) {
    double confidence = 40.0;
    if (moodCheckIns.length >= 7) confidence += 10;
    if (journals.isNotEmpty) confidence += 10;
    if (chats.isNotEmpty) confidence += 10;
    if (burnoutScores.length >= 3) confidence += 10;
    if (followUps.any((f) => f.resolved && f.userResponse != null)) {
      confidence += 10;
    }
    return confidence.clamp(40.0, 90.0);
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Utilities
  // ─────────────────────────────────────────────────────────────────────────

  bool _containsAny(String text, List<String> keywords) =>
      keywords.any((kw) => text.contains(kw));

  DateTime _currentWeekStart() {
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    return startOfToday.subtract(Duration(days: startOfToday.weekday - 1));
  }
}
