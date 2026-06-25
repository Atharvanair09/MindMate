import 'dart:async';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/timeline_event.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../domain/models/recovery_event.dart';
import '../../domain/models/pattern_insight.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../domain/models/app_notification.dart';

class TimelineService {
  static final TimelineService instance = TimelineService._internal();
  
  TimelineService._internal();

  Isar get isar => IsarDatabase.instance;

  /// Watch timeline events, automatically updating when new data is added.
  Stream<List<TimelineEvent>> watchTimelineEvents({bool newestFirst = true}) async* {
    // Yield initially
    yield await getTimelineEvents(newestFirst: newestFirst);

    // Create a combined stream of all relevant collections
    final combinedStream = StreamGroup.merge([
      isar.dailyMoodCheckIns.watchLazy(),
      isar.reflectionFollowUps.watchLazy(),
      isar.recoveryEvents.watchLazy(),
      isar.patternInsights.watchLazy(),
      isar.weeklyReflections.watchLazy(),
      isar.appNotifications.watchLazy(),
    ]);

    // Yield whenever any of the watched collections change
    await for (final _ in combinedStream) {
      yield await getTimelineEvents(newestFirst: newestFirst);
    }
  }

  Future<List<TimelineEvent>> getTimelineEvents({bool newestFirst = true}) async {
    final List<TimelineEvent> events = [];

    // 1. Mood Check-Ins
    final checkIns = await isar.dailyMoodCheckIns.where().findAll();
    for (final c in checkIns) {
      events.add(TimelineEvent(
        id: 'mood_${c.id}',
        eventType: 'Mood Check-In',
        title: 'Mood Logged: ${c.moodLevel}',
        description: 'Logged mood via ${c.source}.',
        eventDate: c.createdAt,
        importance: 'LOW',
        sourceId: c.id.toString(),
        generatedAt: c.createdAt,
      ));
    }

    // 2. Mood Conflict Detected / Resolved
    final followUps = await isar.reflectionFollowUps.where().findAll();
    for (final f in followUps) {
      if (f.journalPositiveMoodMismatch || f.journalNegativeMoodMismatch) {
        events.add(TimelineEvent(
          id: 'conflict_detected_${f.id}',
          eventType: 'Check-In Mismatch Detected',
          title: 'Check-In Mismatch Detected',
          description: 'Your journal suggested a different emotional state than your selected mood.',
          eventDate: f.createdAt,
          importance: 'MEDIUM',
          sourceId: f.id.toString(),
          generatedAt: f.createdAt,
        ));
      }
      if (f.resolved && f.resolvedAt != null) {
        events.add(TimelineEvent(
          id: 'conflict_resolved_${f.id}',
          eventType: 'Mood Clarified',
          title: 'Mood Clarified',
          description: 'Additional context helped explain your emotional state.',
          eventDate: f.resolvedAt!,
          importance: 'LOW',
          sourceId: f.id.toString(),
          generatedAt: f.resolvedAt!,
        ));
      }
    }

    // 3. Recovery Event Detected
    final recoveryEvents = await isar.recoveryEvents.where().findAll();
    for (final r in recoveryEvents) {
      events.add(TimelineEvent(
        id: 'recovery_${r.id}',
        eventType: 'Recovery Milestone',
        title: 'Recovery Milestone',
        description: 'Your mood improved and stress indicators decreased.',
        eventDate: r.generatedAt,
        importance: 'HIGH',
        sourceId: r.id.toString(),
        generatedAt: r.generatedAt,
      ));
    }

    // 4. Pattern Discovered
    final patterns = await isar.patternInsights.where().findAll();
    for (final p in patterns) {
      bool? isPos;
      if (p.associationType.toLowerCase().contains('improved mood') || p.associationType.toLowerCase().contains('lower burnout')) {
        isPos = true;
      } else if (p.associationType.toLowerCase().contains('lower mood') || p.associationType.toLowerCase().contains('higher burnout')) {
        isPos = false;
      }

      events.add(TimelineEvent(
        id: 'pattern_${p.id}',
        eventType: 'Personal Pattern Learned',
        title: p.patternName,
        description: p.description,
        eventDate: p.generatedAt,
        importance: 'MEDIUM',
        sourceId: p.id.toString(),
        generatedAt: p.generatedAt,
        isPositive: isPos,
      ));
    }

    // 5. Weekly Reflection & Burnout Analysis
    final weeklyReflections = await isar.weeklyReflections.where().findAll();
    for (final w in weeklyReflections) {
      String condensedSummary = '';
      if (w.moodTrend == 'Stable') {
        condensedSummary += 'Mood remained stable this week.\n';
      } else if (w.moodTrend == 'Improving') {
        condensedSummary += 'Mood improved this week.\n';
      } else if (w.moodTrend == 'Declining') {
        condensedSummary += 'Mood declined this week.\n';
      } else {
        condensedSummary += 'No significant mood decline detected.\n';
      }
      
      if (w.burnoutTrend == 'Stable') {
        condensedSummary += 'Burnout risk stayed moderate.';
      } else if (w.burnoutTrend == 'Improving') {
        condensedSummary += 'Burnout risk decreased.';
      } else if (w.burnoutTrend == 'Increasing') {
        condensedSummary += 'Burnout risk increased.';
      } else {
        condensedSummary += 'Moderate stress levels observed.';
      }

      events.add(TimelineEvent(
        id: 'weekly_reflection_${w.id}',
        eventType: 'Weekly Reflection Generated',
        title: 'Weekly Insight Ready',
        description: condensedSummary.trim(),
        eventDate: w.generatedAt,
        importance: 'MEDIUM',
        sourceId: w.id.toString(),
        generatedAt: w.generatedAt,
      ));

      if (w.burnoutTrend.contains('Increasing')) {
        events.add(TimelineEvent(
          id: 'burnout_spike_weekly_${w.id}',
          eventType: 'Stress Increase Observed',
          title: 'Stress Increase Observed',
          description: 'Recent signals suggest elevated stress levels.',
          eventDate: w.generatedAt,
          importance: 'HIGH',
          sourceId: w.id.toString(),
          generatedAt: w.generatedAt,
        ));
      } else if (w.burnoutTrend.contains('Improving')) {
        events.add(TimelineEvent(
          id: 'burnout_improvement_weekly_${w.id}',
          eventType: 'Burnout Improvement',
          title: 'Burnout Improved',
          description: 'Weekly reflection noted an improving burnout trend.',
          eventDate: w.generatedAt,
          importance: 'HIGH',
          sourceId: w.id.toString(),
          generatedAt: w.generatedAt,
        ));
      }
    }

    // 6. Burnout Alerts from AppNotification
    final notifications = await isar.appNotifications.filter().typeEqualTo('burnout_alert').findAll();
    for (final n in notifications) {
      events.add(TimelineEvent(
        id: 'burnout_alert_notif_${n.id}',
        eventType: 'Stress Increase Observed',
        title: 'Stress Increase Observed',
        description: 'Recent signals suggest elevated stress levels.',
        eventDate: n.createdAt,
        importance: 'HIGH',
        sourceId: n.id.toString(),
        generatedAt: n.createdAt,
      ));
    }

    // Sort events
    events.sort((a, b) {
      if (newestFirst) {
        return b.eventDate.compareTo(a.eventDate);
      } else {
        return a.eventDate.compareTo(b.eventDate);
      }
    });

    return events;
  }
}

class StreamGroup {
  static Stream<T> merge<T>(Iterable<Stream<T>> streams) {
    late StreamController<T> controller;
    final List<StreamSubscription<T>> subscriptions = [];

    controller = StreamController<T>.broadcast(
      onListen: () {
        for (final stream in streams) {
          subscriptions.add(stream.listen(
            controller.add,
            onError: controller.addError,
          ));
        }
      },
      onCancel: () {
        for (final sub in subscriptions) {
          sub.cancel();
        }
        subscriptions.clear();
      },
    );

    return controller.stream;
  }
}
