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

    // ── Influential Factors ───────────────────────────────────────────────
    final influenceData = _computeMostInfluentialFactors(
      journals: journals,
      chats: chats,
      followUps: followUps,
      moodValues: moodValues,
      moodTrend: moodTrend,
      burnoutTrend: burnoutTrend,
    );

    // ── Summary & Suggestion ──────────────────────────────────────────────
    final summary =
        _buildSummary(moodTrend, burnoutTrend, avgMood, avgBurnout);
    final suggestion = _buildSuggestion(influenceData, moodTrend, burnoutTrend);

    // ── Confidence ────────────────────────────────────────────────────────
    final confidenceBreakdown = _computeConfidenceBreakdown(
      moodCheckIns: moodCheckIns,
      journals: journals,
      chats: chats,
      burnoutScores: burnoutScores,
      followUps: followUps,
    );
    final confidence = confidenceBreakdown['total']!;

    final String historySufficiency;
    if (moodCheckIns.length < 3) {
      historySufficiency = 'LOW';
    } else if (moodCheckIns.length < 7) {
      historySufficiency = 'MODERATE';
    } else {
      historySufficiency = 'HIGH';
    }

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
      ..rawConfidence = confidenceBreakdown['rawConfidence']!
      ..confidenceCap = confidenceBreakdown['confidenceCap']!
      ..baseConfidence = confidenceBreakdown['baseConfidence']!
      ..daysContribution = confidenceBreakdown['daysContribution']!
      ..moodContribution = confidenceBreakdown['moodContribution']!
      ..journalContribution = confidenceBreakdown['journalContribution']!
      ..chatContribution = confidenceBreakdown['chatContribution']!
      ..burnoutContribution = confidenceBreakdown['burnoutContribution']!
      ..followUpContribution = confidenceBreakdown['followUpContribution']!
      ..historySufficiency = historySufficiency
      ..mostPositiveInfluence = influenceData['mostPositiveInfluence'] as String
      ..positiveInfluenceReason = influenceData['positiveInfluenceReason'] as String
      ..mostNegativeInfluence = influenceData['mostNegativeInfluence'] as String
      ..negativeInfluenceReason = influenceData['negativeInfluenceReason'] as String
      ..topPositiveScore = influenceData['topPositiveScore'] as double
      ..topNegativeScore = influenceData['topNegativeScore'] as double
      ..influenceScores = influenceData['influenceScores'] as List<String>
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

  /// Compares first half vs second half averages based on available days.
  String _computeMoodTrend(List<double> values) {
    int days = values.length;
    if (days < 3) return 'Insufficient Data';
    
    int takeCount = days >= 6 ? 3 : days ~/ 2;
    final first = values.take(takeCount).toList();
    final last = values.reversed.take(takeCount).toList();
    
    final firstAvg = first.reduce((a, b) => a + b) / first.length;
    final lastAvg = last.reduce((a, b) => a + b) / last.length;
    final delta = lastAvg - firstAvg;
    
    String trend;
    if (delta > 0.4) {
      trend = 'Improving';
    } else if (delta < -0.4) {
      trend = 'Declining';
    } else {
      trend = 'Stable';
    }
    
    if (days < 7) {
      return 'Preliminary $trend';
    }
    return trend;
  }

  /// Compares first half vs second half averages based on available days.
  String _computeBurnoutTrend(List<double> scores) {
    int days = scores.length;
    if (days < 3) return 'Insufficient Data';
    
    int takeCount = days >= 6 ? 3 : days ~/ 2;
    final first = scores.take(takeCount).toList();
    final last = scores.reversed.take(takeCount).toList();
    
    final firstAvg = first.reduce((a, b) => a + b) / first.length;
    final lastAvg = last.reduce((a, b) => a + b) / last.length;
    final delta = lastAvg - firstAvg;
    
    String trend;
    if (delta < -5) {
      trend = 'Improving';
    } else if (delta > 5) {
      trend = 'Increasing';
    } else {
      trend = 'Stable';
    }
    
    if (days < 7) {
      return 'Preliminary $trend';
    }
    return trend;
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Influential Factors
  // ─────────────────────────────────────────────────────────────────────────

  Map<String, dynamic> _computeMostInfluentialFactors({
    required List<JournalEntry> journals,
    required List<ChatMessage> chats,
    required List<ReflectionFollowUp> followUps,
    required List<double> moodValues,
    required String moodTrend,
    required String burnoutTrend,
  }) {
    // POSITIVE SCORING
    final posScores = <String, double>{};
    final posReasons = <String, String>{};

    // Resolved Mood Conflicts
    final resolvedConflicts = followUps.where((f) => f.resolved).length;
    if (resolvedConflicts > 0) {
      posScores['Resolved Mood Conflicts'] = resolvedConflicts * 25.0;
      posReasons['Resolved Mood Conflicts'] = 'Mentioned in follow-up response.';
    }

    // Positive Journals
    final posJournals = journals.where((j) => (j.sentimentScore ?? 0) > 0.3).length;
    if (posJournals > 0) {
      posScores['Positive Journals'] = posJournals * 20.0;
      posReasons['Positive Journals'] = 'Detected in multiple journals.';
    }

    // Positive Chats
    final posChatsCount = chats.where((c) => (c.sentimentScore ?? 0) > 0.3).length;
    if (posChatsCount > 0) {
      posScores['Positive Chats'] = posChatsCount * 15.0;
      posReasons['Positive Chats'] = 'Positive sentiment detected in conversations.';
    }

    // Social Activity Mentions
    final socialJournals = journals.where((j) => _containsAny(j.content.toLowerCase(), ['friend', 'family', 'social', 'hang out', 'coffee', 'dinner'])).length;
    if (socialJournals > 0) {
      posScores['Social Interaction Mentions'] = socialJournals * 20.0;
      posReasons['Social Interaction Mentions'] = 'Associated with positive mood mentions.';
    }

    // Exercise Mentions
    final exerciseJournals = journals.where((j) => _containsAny(j.content.toLowerCase(), ['gym', 'walk', 'run', 'exercise', 'workout', 'jog', 'sport'])).length;
    if (exerciseJournals > 0) {
      posScores['Exercise'] = exerciseJournals * 6.0;
      posReasons['Exercise'] = 'Physical activity appears correlated with better mood.';
    }

    // Mood Recovery / Burnout Reduction
    if (moodTrend.contains('Improving')) {
      posScores['Mood Recovery Events'] = 20.0;
      posReasons['Mood Recovery Events'] = 'Overall mood trend showed strong improvement.';
    }
    if (burnoutTrend.contains('Improving')) {
      posScores['Burnout Improvement'] = 25.0;
      posReasons['Burnout Improvement'] = 'Overall burnout trend showed strong improvement.';
    }

    // NEGATIVE SCORING
    final negScores = <String, double>{};
    final negReasons = <String, String>{};

    // Repeated LOW Mood
    final lowDays = moodValues.where((v) => v <= 2).length;
    if (lowDays > 0) {
      negScores['Repeated LOW Mood'] = lowDays * 15.0;
      negReasons['Repeated LOW Mood'] = 'Detected across multiple days.';
    }

    // Negative Journals
    final negJournals = journals.where((j) => (j.sentimentScore ?? 0) < -0.3 || (j.stressScore ?? 0) > 0.6).length;
    if (negJournals > 0) {
      negScores['Negative Journals'] = negJournals * 20.0;
      negReasons['Negative Journals'] = 'High stress or negative sentiment in journals.';
    }

    // Negative Chats
    final negChatsCount = chats.where((c) => (c.sentimentScore ?? 0) < -0.3).length;
    if (negChatsCount > 0) {
      negScores['Negative Chats'] = negChatsCount * 20.0;
      negReasons['Negative Chats'] = 'Elevated emotional stress in conversations.';
    }

    // Sleep Issues
    final sleepJournals = journals.where((j) => _containsAny(j.content.toLowerCase(), ['sleep', 'tired', 'exhausted', 'insomnia', 'rest', 'fatigue'])).length;
    if (sleepJournals > 0) {
      negScores['Sleep Disruption'] = sleepJournals * 15.0;
      negReasons['Sleep Disruption'] = 'Associated with lower mood.';
    }

    // Academic Stress
    final academicJournals = journals.where((j) => _containsAny(j.content.toLowerCase(), ['deadline', 'exam', 'assignment', 'test', 'study', 'project'])).length;
    if (academicJournals > 0) {
      negScores['Academic Stress'] = academicJournals * 15.0;
      negReasons['Academic Stress'] = 'Academic pressure noted in journal entries.';
    }

    // Work Stress
    final workJournals = journals.where((j) => _containsAny(j.content.toLowerCase(), ['work', 'job', 'boss', 'office', 'meeting', 'shift'])).length;
    if (workJournals > 0) {
      negScores['Work Stress'] = workJournals * 15.0;
      negReasons['Work Stress'] = 'Work pressure noted in journal entries.';
    }

    // Burnout Spikes
    if (burnoutTrend.contains('Increasing')) {
      negScores['Burnout Spikes'] = 20.0;
      negReasons['Burnout Spikes'] = 'Significant increase in burnout risk.';
    }

    // Unresolved Follow-Ups
    final unresolved = followUps.where((f) => !f.resolved && !f.dismissed).length;
    if (unresolved > 0) {
      negScores['Unresolved Follow-Ups'] = unresolved * 8.0;
      negReasons['Unresolved Follow-Ups'] = 'Unresolved mood conflicts this week.';
    }

    String topPos = 'No strong positive factor detected.';
    String topPosReason = 'Not enough positive data detected.';
    double maxPos = 0.0;
    posScores.forEach((k, v) {
      if (v > maxPos) {
        maxPos = v;
        topPos = k;
        topPosReason = posReasons[k]!;
      }
    });

    String topNeg = 'No strong negative factor detected.';
    String topNegReason = 'Not enough negative data detected.';
    double maxNeg = 0.0;
    negScores.forEach((k, v) {
      if (v > maxNeg) {
        maxNeg = v;
        topNeg = k;
        topNegReason = negReasons[k]!;
      }
    });

    final influenceScores = <String>[];
    posScores.forEach((k, v) => influenceScores.add('$k: ${v.toStringAsFixed(1)}'));
    negScores.forEach((k, v) => influenceScores.add('$k: ${v.toStringAsFixed(1)}'));

    return {
      'mostPositiveInfluence': topPos,
      'positiveInfluenceReason': topPosReason,
      'mostNegativeInfluence': topNeg,
      'negativeInfluenceReason': topNegReason,
      'topPositiveScore': maxPos,
      'topNegativeScore': maxNeg,
      'influenceScores': influenceScores,
    };
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

    final isMoodImproving = moodTrend.contains('Improving');
    final isMoodDeclining = moodTrend.contains('Declining');
    final isBurnoutIncreasing = burnoutTrend.contains('Increasing');

    if (isMoodImproving && !isBurnoutIncreasing) {
      return 'This week showed $moodLabel wellness levels with encouraging signs of '
          'recovery. Mood improved toward the end of the week and burnout risk '
          'remained $burnoutLabel.';
    } else if (isMoodDeclining || isBurnoutIncreasing) {
      final moodStr = moodTrend == 'Insufficient Data' ? 'stable' : moodTrend.toLowerCase();
      final burnoutStr = burnoutTrend == 'Insufficient Data' ? 'stable' : burnoutTrend.toLowerCase();
      return 'This week showed $burnoutLabel burnout risk with some stress signals. '
          'Mood trended $moodStr and burnout risk was $burnoutStr toward the '
          'end of the week. Focus on rest and recovery.';
    } else {
      final moodStr = moodTrend == 'Insufficient Data' ? 'stable' : moodTrend.toLowerCase();
      return 'This week showed $moodLabel stress levels with a relatively stable '
          'pattern. Mood was $moodStr and burnout risk remained $burnoutLabel '
          'throughout the week.';
    }
  }

  String _buildSuggestion(Map<String, dynamic> influenceData, String moodTrend, String burnoutTrend) {
    final topPosScore = influenceData['topPositiveScore'] as double;
    final topNegScore = influenceData['topNegativeScore'] as double;
    final mostPos = influenceData['mostPositiveInfluence'] as String;
    final mostNeg = influenceData['mostNegativeInfluence'] as String;

    String highestInfluence = topPosScore >= topNegScore ? mostPos : mostNeg;

    if (highestInfluence == 'Social Interaction Mentions') {
      return 'Continue making time for meaningful social interactions, as they appear associated with improved mood.';
    }
    if (highestInfluence == 'Positive Journals') {
      return 'Activities that create enjoyment and a sense of accomplishment appear beneficial. Consider continuing these routines.';
    }
    if (highestInfluence == 'Sleep Disruption') {
      return 'Improving sleep consistency may help support mood stability and reduce stress.';
    }
    if (highestInfluence == 'Academic Stress') {
      return 'Consider breaking large tasks into smaller steps and scheduling recovery periods during demanding weeks.';
    }
    if (highestInfluence == 'Negative Chats') {
      return 'Recent conversations show signs of emotional strain. Consider taking breaks and reaching out for support when needed.';
    }

    if (burnoutTrend.contains('Increasing')) {
      return 'Consider prioritising rest and reducing stressors where possible.';
    }
    if (moodTrend.contains('Improving')) {
      return 'Continue the routines that have supported recent progress.';
    }
    if (moodTrend.contains('Declining')) {
      return 'Reconnect with activities that have helped your mood in the past.';
    }
    return 'Maintain consistency and continue daily check-ins.';
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Confidence
  // ─────────────────────────────────────────────────────────────────────────

  Map<String, double> _computeConfidenceBreakdown({
    required List<DailyMoodCheckIn> moodCheckIns,
    required List<JournalEntry> journals,
    required List<ChatMessage> chats,
    required List<double> burnoutScores,
    required List<ReflectionFollowUp> followUps,
  }) {
    int days = moodCheckIns.length;
    double daysContrib = 0.0;
    if (days >= 1 && days <= 2) {
      daysContrib = 10.0;
    } else if (days >= 3 && days <= 4) {
      daysContrib = 20.0;
    } else if (days >= 5 && days <= 6) {
      daysContrib = 30.0;
    } else if (days >= 7) {
      daysContrib = 40.0;
    }

    double moodContrib = moodCheckIns.isNotEmpty ? 10.0 : 0.0;
    double journalContrib = journals.isNotEmpty ? 10.0 : 0.0;
    double chatContrib = chats.isNotEmpty ? 10.0 : 0.0;
    double burnoutContrib = burnoutScores.isNotEmpty ? 10.0 : 0.0;
    double followUpContrib = followUps.isNotEmpty ? 10.0 : 0.0;

    double totalConfidence = 20.0 +
        daysContrib +
        moodContrib +
        journalContrib +
        chatContrib +
        burnoutContrib +
        followUpContrib;

    double cap = 90.0;
    if (days >= 1 && days <= 2) {
      cap = 60.0;
    } else if (days >= 3 && days <= 4) {
      cap = 75.0;
    } else if (days >= 5 && days <= 6) {
      cap = 85.0;
    } else if (days >= 7) {
      cap = 90.0;
    }

    double rawConfidence = totalConfidence.clamp(20.0, 90.0);
    double finalConfidence = rawConfidence > cap ? cap : rawConfidence;

    return {
      'baseConfidence': 20.0,
      'daysContribution': daysContrib,
      'moodContribution': moodContrib,
      'journalContribution': journalContrib,
      'chatContribution': chatContrib,
      'burnoutContribution': burnoutContrib,
      'followUpContribution': followUpContrib,
      'rawConfidence': rawConfidence,
      'confidenceCap': cap,
      'total': finalConfidence,
    };
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
