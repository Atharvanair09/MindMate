import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/wellness_journey_summary.dart';
import '../../domain/models/recovery_event.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../domain/models/pattern_insight.dart';

class WellnessJourneyService {
  static final WellnessJourneyService instance = WellnessJourneyService._internal();

  WellnessJourneyService._internal();

  Isar get isar => IsarDatabase.instance;

  Future<WellnessJourneySummary> getOrGenerateSummary() async {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 30));
    
    // Check if we have a recent summary
    final existing = await isar.wellnessJourneySummarys
        .where()
        .sortByGeneratedAtDesc()
        .findFirst();

    // Collect current events to build signatures
    final checkIns = await isar.dailyMoodCheckIns.filter().createdAtGreaterThan(startDate).findAll();
    final reflections = await isar.weeklyReflections.filter().generatedAtGreaterThan(startDate).findAll();
    final recoveries = await isar.recoveryEvents.filter().generatedAtGreaterThan(startDate).findAll();
    final patterns = await isar.patternInsights.filter().generatedAtGreaterThan(startDate).findAll();
    
    final currentSignatures = [
      'checkins_${checkIns.length}',
      'reflections_${reflections.length}',
      'recoveries_${recoveries.length}',
      'patterns_${patterns.length}',
    ];

    // If we have an existing summary less than 24h old, and signatures haven't changed much, return it
    if (existing != null) {
      final hoursSinceGeneration = now.difference(existing.generatedAt).inHours;
      bool signaturesMatch = true;
      for (var sig in currentSignatures) {
        if (!existing.eventSignatures.contains(sig)) {
          signaturesMatch = false;
          break;
        }
      }
      
      if (hoursSinceGeneration < 24 && signaturesMatch) {
        return existing;
      }
    }

    // Otherwise, generate a new narrative
    final narrative = _generateNarrative(
      startDate: startDate,
      endDate: now,
      checkIns: checkIns,
      reflections: reflections,
      recoveries: recoveries,
      patterns: patterns,
    );

    final summary = WellnessJourneySummary()
      ..narrative = narrative
      ..generatedAt = now
      ..startDate = startDate
      ..endDate = now
      ..eventSignatures = currentSignatures;

    await isar.writeTxn(() async {
      await isar.wellnessJourneySummarys.put(summary);
    });

    return summary;
  }

  String _generateNarrative({
    required DateTime startDate,
    required DateTime endDate,
    required List<DailyMoodCheckIn> checkIns,
    required List<WeeklyReflection> reflections,
    required List<RecoveryEvent> recoveries,
    required List<PatternInsight> patterns,
  }) {
    if (checkIns.isEmpty && reflections.isEmpty && recoveries.isEmpty && patterns.isEmpty) {
      return "Your wellness journey is just beginning. Start checking in daily and completing reflections to see a summary of your progress over time.";
    }

    final monthName = DateFormat('MMMM').format(endDate);
    List<String> paragraphs = [];

    // Part 1: The Beginning / General Trends
    if (reflections.isNotEmpty) {
      final firstRef = reflections.first;
      String startText = "This $monthName started ";
      if (firstRef.burnoutTrend.contains('Increasing')) {
        startText += "with increasing stress and some challenges.";
      } else if (firstRef.moodTrend.contains('Declining')) {
        startText += "with a noticeable dip in mood.";
      } else {
        startText += "with relatively stable wellness levels.";
      }
      paragraphs.add(startText);
    } else if (checkIns.isNotEmpty) {
      paragraphs.add("Over the past few weeks, you've been actively tracking your mood and building self-awareness.");
    }

    // Part 2: Middle / Interventions and Discoveries
    if (patterns.isNotEmpty) {
      final p = patterns.last;
      bool positive = p.associationType.toLowerCase().contains('improved') || p.associationType.toLowerCase().contains('lower');
      if (positive) {
        paragraphs.add("Along the way, we discovered that ${p.patternName.toLowerCase()} became a positive pattern for you.");
      } else {
        paragraphs.add("You also gained insight into how certain triggers, like ${p.patternName.toLowerCase()}, affect your energy.");
      }
    }

    // Part 3: Community and Plans (Mocked context based on events)
    if (recoveries.isNotEmpty) {
      paragraphs.add("After engaging with your wellness plans and taking time for yourself, your stress and burnout risk gradually decreased.");
    } else if (reflections.length > 1) {
      final lastRef = reflections.last;
      if (lastRef.burnoutTrend.contains('Improving')) {
        paragraphs.add("By following your wellness recommendations, you've shown gradual improvement in managing your stress levels.");
      }
    }

    // Part 4: Conclusion / Recovery
    if (recoveries.isNotEmpty) {
      paragraphs.add("Recent milestones highlight your resilience. Improved mood and effective coping strategies have become recurring recovery patterns.");
    } else if (checkIns.isNotEmpty && checkIns.length >= 7) {
      paragraphs.add("Consistency in logging has helped build a clearer picture of your well-being, paving the way for better self-care routines.");
    }

    // Variation logic to avoid repeating identical summaries (randomize slight variations)
    // Here we just use a join for simplicity, but the changing data (patterns.last, reflections.first/last) naturally evolves the text.
    return paragraphs.join(" ");
  }
}
