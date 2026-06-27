import 'dart:async';
import 'package:isar/isar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/database/isar_database.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/mood_log.dart';
import '../../domain/models/session_log.dart';
import '../../domain/models/intervention_log.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/daily_mood_check_in.dart';
import 'feature_extractor.dart';
import 'feature_builder.dart';
import 'feature_cache.dart';
import 'reflection_engine.dart';
import 'ai_insight_generator.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/notifications/smart_check_in_service.dart';

class FeaturePipeline {
  static final FeaturePipeline instance = FeaturePipeline._internal();

  Isar get isar => IsarDatabase.instance;
  final FeatureExtractor extractor = FeatureExtractor();
  late final FeatureBuilder builder;
  final FeatureCache cache = FeatureCache();

  StreamSubscription? _journalSub;
  StreamSubscription? _chatSub;
  StreamSubscription? _moodSub;
  StreamSubscription? _dailyMoodSub;
  StreamSubscription? _sessionSub;
  StreamSubscription? _interventionSub;

  FeaturePipeline._internal() {
    builder = FeatureBuilder(extractor);
  }

  void initialize() {
    _listenToChanges();
    // Trigger initial generation if dirty (default is true)
    triggerPipeline();
  }

  void _listenToChanges() {
    // Privacy note: Everything remains completely local.
    // No data leaves the device.
    // Explicit mood is the ground truth.
    // Embeddings capture semantic meaning.
    // Feature engineering improves prediction.
    
    _journalSub = isar.journalEntrys.watchLazy().listen((_) => _onDataChanged());
    _chatSub = isar.chatMessages.watchLazy().listen((_) => _onDataChanged());
    _moodSub = isar.moodLogs.watchLazy().listen((_) => _onDataChanged());
    _dailyMoodSub = isar.dailyMoodCheckIns.watchLazy().listen((_) => _onDataChanged());
    _sessionSub = isar.sessionLogs.watchLazy().listen((_) => _onDataChanged());
    _interventionSub = isar.interventionLogs.watchLazy().listen((_) => _onDataChanged());
  }

  void _onDataChanged() {
    cache.markDirty();
    AiInsightGenerator.instance.invalidateCache();
    triggerPipeline();
  }

  Future<void> triggerPipeline() async {
    if (!cache.isDirty) return;
    
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    
    // Background feature builder: generate latest feature vector
    final vector = await builder.buildFeatureVector(today);
    
    // Store locally
    await isar.writeTxn(() async {
      // Find and delete the existing vector for today to avoid duplicates
      await isar.moodFeatureVectors.filter().dateEqualTo(startOfDay).deleteAll();
      
      // Save the newly generated vector
      await isar.moodFeatureVectors.put(vector);
    });

    cache.markClean();

    // Evaluate Context-Aware Mood Check-in triggers
    try {
      final reflection = await ReflectionEngine.instance.getLatestReflection();
      final previousVector = await isar.moodFeatureVectors
          .filter()
          .dateLessThan(startOfDay)
          .sortByDateDesc()
          .findFirst();

      bool triggerCheckIn = false;
      String? checkInMessage;

      // 1. Burnout score increases significantly
      if (previousVector != null) {
        final prevReflection = await ReflectionEngine.instance.getReflectionForVector(previousVector);
        final burnoutDiff = reflection.burnoutScore - prevReflection.burnoutScore;
        if (burnoutDiff >= 15) {
          triggerCheckIn = true;
          checkInMessage = "We noticed your burnout indicators are rising. Has your mood changed since your earlier check-in?";
        }
      }

      // 2. Negative journal sentiment
      if (!triggerCheckIn && vector.journalSentiment != null && vector.journalSentiment! <= -0.3) {
        triggerCheckIn = true;
        checkInMessage = "Has your mood changed since your earlier journal entry?";
      }

      // 3. Multiple negative chats
      if (!triggerCheckIn) {
        final chats = await extractor.getChatsForDate(today);
        final negativeChatsCount = chats
            .where((c) => c.role == 'user' && c.sentimentScore != null && c.sentimentScore! <= -0.3)
            .length;
        if (negativeChatsCount >= 2) {
          triggerCheckIn = true;
          checkInMessage = "Would you like to update how you're feeling now?";
        }
      }

      // 4. Mood differs greatly from trend
      if (!triggerCheckIn && vector.currentMoodValue != null && vector.rollingMoodAverage7Days != null) {
        final moodDiff = (vector.currentMoodValue! - vector.rollingMoodAverage7Days!).abs();
        if (moodDiff >= 1.5) {
          triggerCheckIn = true;
        }
      }

      if (triggerCheckIn) {
        checkInMessage = await SmartCheckInService.instance.generateCheckInMessage();
      }

      if (triggerCheckIn && checkInMessage != null) {
        final prefs = await SharedPreferences.getInstance();
        final lastSentStr = prefs.getString('last_context_aware_check_in');
        bool canSend = true;
        
        if (lastSentStr != null) {
          final lastSent = DateTime.parse(lastSentStr);
          // 1 minute cooldown for hackathon demo
          if (DateTime.now().difference(lastSent).inMinutes < 1) {
            canSend = false;
          }
        }

        if (canSend) {
          // Set pending context-aware check-in to be scheduled 1 min after app closed
          NotificationService.pendingContextAwareCheckInMessage = checkInMessage;
          await prefs.setString('last_context_aware_check_in', DateTime.now().toIso8601String());
        }
      }

      // --- Trigger Burnout Alerts ---
      if (reflection.burnoutLevel == 'HIGH') {
        final prefs = await SharedPreferences.getInstance();
        final lastAlertStr = prefs.getString('last_burnout_alert');
        bool canSendAlert = true;
        if (lastAlertStr != null) {
          final lastAlert = DateTime.parse(lastAlertStr);
          if (DateTime.now().difference(lastAlert).inMinutes < 1) {
            canSendAlert = false;
          }
        }
        if (canSendAlert) {
          await NotificationService.instance.sendBurnoutAlert("Your recent burnout score suggests high stress. Take a deep breath.");
          await prefs.setString('last_burnout_alert', DateTime.now().toIso8601String());
        }
      }

      // --- Trigger AI Reflection Insights ---
      if (vector.journalStressScore != null && vector.journalStressScore! > 0.5) {
        final prefs = await SharedPreferences.getInstance();
        final lastInsightStr = prefs.getString('last_ai_insight');
        bool canSendInsight = true;
        if (lastInsightStr != null) {
          final lastInsight = DateTime.parse(lastInsightStr);
          if (DateTime.now().difference(lastInsight).inMinutes < 1) {
            canSendInsight = false;
          }
        }
        if (canSendInsight) {
          await NotificationService.instance.sendAIInsight("Your recent journal entries suggest increased stress.");
          await prefs.setString('last_ai_insight', DateTime.now().toIso8601String());
        }
      }
    } catch (e) {
      // Suppress background errors
    }
  }

  // Used for Developer Debug Screen
  Future<MoodFeatureVector?> getLatestVector() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return await isar.moodFeatureVectors.filter().dateEqualTo(startOfDay).findFirst();
  }
  
  bool get isCacheValid => !cache.isDirty;

  void dispose() {
    _journalSub?.cancel();
    _chatSub?.cancel();
    _moodSub?.cancel();
    _dailyMoodSub?.cancel();
    _sessionSub?.cancel();
    _interventionSub?.cancel();
  }
}
