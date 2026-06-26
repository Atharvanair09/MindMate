import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/embedding_record.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../services/ml/feature_pipeline.dart';
import '../../domain/models/reflection_result.dart';
import '../../services/ml/reflection_engine.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../domain/models/app_notification.dart';
import '../../services/notifications/notification_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../core/state/app_state_observer.dart';
import '../../domain/models/ai_insight_result.dart';
import '../../services/ml/ai_insight_generator.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../services/weekly_reflection/weekly_reflection_service.dart';
import '../../domain/models/recovery_event.dart';
import '../../services/ml/recovery_detection_service.dart';
import 'package:intl/intl.dart';
import '../../domain/models/pattern_insight.dart';
import '../../services/pattern/pattern_discovery_service.dart';
import '../../services/timeline/timeline_service.dart';

class DeveloperDebugPage extends StatefulWidget {
  const DeveloperDebugPage({super.key});

  @override
  State<DeveloperDebugPage> createState() => _DeveloperDebugPageState();
}

class _DeveloperDebugPageState extends State<DeveloperDebugPage> {
  int _totalEmbeddings = 0;
  MoodFeatureVector? _latestFeatureVector;
  ReflectionResult? _reflection;
  AiInsightResult? _aiInsight;
  DailyMoodCheckIn? _todayMood;
  List<ReflectionFollowUp> _followUps = [];
  JournalEntry? _latestJournal;

  // Today's user chat messages (for chat signal debug)
  List<ChatMessage> _todayUserChats = [];

  int _unreadNotificationsCount = 0;
  int _totalNotificationsCount = 0;
  int _pendingFollowUpsCount = 0;
  int _scheduledRemindersCount = 0;
  String _channelStatus = "Checking...";
  String _iconStatus = "Verifying...";
  List<PendingNotificationRequest> _pendingRequests = [];

  String _appState = "UNKNOWN";
  int _appForegroundCount = 0;
  int _appBackgroundCount = 0;
  int _appSuppressedCount = 0;

  // Enhanced notification debug
  String _notifPermission = "Checking...";
  int _notifScheduled = 0;
  String _nextReminderType = "—";
  String _notifTriggerTime = "—";
  String _lastNotifSent = "—";
  String _bgDeliveryEnabled = "Checking...";
  int _dartTimerCount = 0;

  // Test mode state
  Map<String, String>? _testResult;
  bool _isSendingTest = false;

  // Weekly Reflection debug
  WeeklyReflection? _weeklyReflection;
  int _weeklyDaysAnalysed = 0;
  bool _isGeneratingWeekly = false;

  // Recovery Detection debug
  List<RecoveryEvent> _recoveryEvents = [];
  bool _isDetectingRecovery = false;

  // Pattern Discovery debug
  List<PatternInsight> _patternInsights = [];
  bool _isDiscoveringPatterns = false;

  // Timeline Events debug
  int _timelineTotalEvents = 0;
  int _timelinePatternEvents = 0;
  int _timelineRecoveryEvents = 0;
  int _timelineConflictEvents = 0;
  int _timelineWeeklyEvents = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final isar = IsarDatabase.instance;
    final total = await isar.embeddingRecords.count();
    final latestVector = await FeaturePipeline.instance.getLatestVector();
    final reflection = await ReflectionEngine.instance.getLatestReflection();

    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final todayMidnight = DateTime.utc(now.year, now.month, now.day);
    final todayMood = await isar.dailyMoodCheckIns
        .where()
        .dateEqualTo(todayMidnight)
        .findFirst();

    final followUps = await isar.reflectionFollowUps
        .where()
        .sortByCreatedAtDesc()
        .findAll();

    // Get latest journal entry (most recent by createdAt)
    final latestJournal = await isar.journalEntrys
        .where()
        .sortByCreatedAtDesc()
        .findFirst();

    // Get today's user chat messages for signal debug
    final todayChats = await isar.chatMessages
        .filter()
        .roleEqualTo('user')
        .and()
        .createdAtBetween(startOfDay, endOfDay)
        .findAll();

    ReflectionFollowUp? activePrompt;
    try {
      activePrompt = followUps.firstWhere((f) => !f.resolved && !f.dismissed);
    } catch (_) {
      activePrompt = null;
    }

    AiInsightResult? aiInsight;
    if (latestVector != null) {
      aiInsight = await AiInsightGenerator.instance.generateInsight(
        currentReflection: reflection,
        latestVector: latestVector,
        activeFollowUp: activePrompt,
      );
    }

    final unreadCount = await NotificationService.instance.getUnreadCount();
    final totalCount = await isar.appNotifications.count();
    final pendingFollowUpsCount = await isar.reflectionFollowUps
        .filter()
        .resolvedEqualTo(false)
        .and()
        .dismissedEqualTo(false)
        .count();

    final pendingReqs = await NotificationService.instance.flutterLocalNotificationsPlugin.pendingNotificationRequests();
    final scheduledCount = pendingReqs.length;

    final androidImplementation = NotificationService.instance.flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    String channelStatus = "N/A (iOS)";
    if (androidImplementation != null) {
      final channels = await androidImplementation.getNotificationChannels();
      if (channels != null && channels.isNotEmpty) {
        channelStatus = channels.map((c) => "${c.id} (${c.importance.toString().split('.').last})").join("\n");
      } else {
        channelStatus = "No channels created";
      }
    }

    // Enhanced notification debug info
    final notifDebugInfo = await NotificationService.instance.getNotificationDebugInfo();

    String iconStatus = "Configured: @drawable/ic_notification (Brain Outline Vector)";

    // Read App State Metrics
    final appState = AppStateObserver.instance.state.toString().split('.').last.toUpperCase();
    final foregroundCount = AppStateObserver.instance.foregroundCount;
    final backgroundCount = AppStateObserver.instance.backgroundCount;
    final suppressedCount = AppStateObserver.instance.suppressedCount;

    setState(() {
      _totalEmbeddings = total;
      _latestFeatureVector = latestVector;
      _reflection = reflection;
      _aiInsight = aiInsight;
      _todayMood = todayMood;
      _followUps = followUps;
      _latestJournal = latestJournal;
      _todayUserChats = todayChats;

      _unreadNotificationsCount = unreadCount;
      _totalNotificationsCount = totalCount;
      _pendingFollowUpsCount = pendingFollowUpsCount;
      _scheduledRemindersCount = scheduledCount;
      _channelStatus = channelStatus;
      _iconStatus = iconStatus;
      _pendingRequests = pendingReqs;

      _appState = appState;
      _appForegroundCount = foregroundCount;
      _appBackgroundCount = backgroundCount;
      _appSuppressedCount = suppressedCount;

      _notifPermission = notifDebugInfo['Notification Permission Granted'] as String? ?? '—';
      _notifScheduled = notifDebugInfo['Notification Scheduled'] as int? ?? 0;
      _nextReminderType = notifDebugInfo['Next Scheduled Reminder'] as String? ?? '—';
      _notifTriggerTime = notifDebugInfo['Notification Trigger Time'] as String? ?? '—';
      
      final lastTitle = notifDebugInfo['Last Notification Sent'] as String? ?? 'None';
      final lastTime = notifDebugInfo['lastNotificationTime'] as String? ?? '--';
      _lastNotifSent = lastTitle != 'None' ? '$lastTitle ($lastTime)' : 'None';
      
      _bgDeliveryEnabled = notifDebugInfo['Background Delivery Enabled'] as String? ?? '—';
      _dartTimerCount = notifDebugInfo['dartTimerCount'] as int? ?? 0;
    });

    // Weekly reflection (fetched after main setState to avoid async-in-setState)
    final weeklyReflection =
        await WeeklyReflectionService.instance.getLatestReflection();
    final weeklyDaysAnalysed = await isar.dailyMoodCheckIns.count();

    // Recovery events
    final recoveryEvents = await isar.recoveryEvents
        .where()
        .sortByGeneratedAtDesc()
        .findAll();

    // Pattern Insights
    final patterns = await PatternDiscoveryService.instance.getPatterns();

    // Timeline Events
    final timelineEvents = await TimelineService.instance.getTimelineEvents();

    setState(() {
      _weeklyReflection = weeklyReflection;
      _weeklyDaysAnalysed = weeklyDaysAnalysed.clamp(0, 7);
      _recoveryEvents = recoveryEvents;
      _patternInsights = patterns;
      
      _timelineTotalEvents = timelineEvents.length;
      _timelinePatternEvents = timelineEvents.where((e) => e.eventType == 'Personal Pattern Learned').length;
      _timelineRecoveryEvents = timelineEvents.where((e) => e.eventType == 'Recovery Milestone').length;
      _timelineConflictEvents = timelineEvents.where((e) => e.eventType == 'Check-In Mismatch Detected' || e.eventType == 'Mood Clarified').length;
      _timelineWeeklyEvents = timelineEvents.where((e) => e.eventType == 'Weekly Reflection Generated').length;
    });
  }

  Future<void> _sendTestReminder() async {
    setState(() {
      _isSendingTest = true;
      _testResult = null;
    });
    final result = await NotificationService.instance.sendTestReminder();
    setState(() {
      _isSendingTest = false;
      _testResult = result;
    });
  }

  Future<void> _sendTestReminder10s() async {
    setState(() {
      _isSendingTest = true;
      _testResult = null;
    });
    await NotificationService.instance.scheduleTestReminder10s();
    setState(() {
      _isSendingTest = false;
      _testResult = {
        'appState': AppStateObserver.instance.state.toString().split('.').last.toUpperCase(),
        'deliveryPath': 'SCHEDULED (10s)',
        'expected': 'Wait 10 seconds for notification',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        title: Text(
          "AI DEBUG",
          style: GoogleFonts.vt323(color: Colors.white, fontSize: 24),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Embeddings ──────────────────────────────────────
            _buildSection("Embeddings", [
              _buildValueRow("✓ Model Loaded", isCyan: true),
              _buildValueRow("Total: $_totalEmbeddings"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Feature Pipeline ────────────────────────────────
            _buildSection("Feature Pipeline", [
              _buildValueRow("Status: Active", isCyan: true),
            ]),
            const SizedBox(height: 10),

            // ── Feature Vector (Full) ────────────────────────────
            _buildSection("Feature Vector (Full)", [
              _buildValueRow("Journal Count: ${_latestFeatureVector?.journalCount ?? 0}"),
              _buildValueRow("Chat Count: ${_latestFeatureVector?.chatCount ?? 0}"),
              _buildDivider(),
              _buildValueRow("journalSentiment: ${_latestFeatureVector?.journalSentiment?.toStringAsFixed(4) ?? 'null'}"),
              _buildValueRow("journalStress: ${_latestFeatureVector?.journalStressScore?.toStringAsFixed(4) ?? 'null'}"),
              _buildValueRow("journalEnergy: ${_latestFeatureVector?.journalEnergyScore?.toStringAsFixed(4) ?? 'null'}"),
              _buildDivider(),
              _buildValueRow("chatSentiment: ${_latestFeatureVector?.chatSentiment?.toStringAsFixed(4) ?? 'null'}"),
              _buildValueRow("chatStress: ${_latestFeatureVector?.chatStressScore?.toStringAsFixed(4) ?? 'null'}"),
              _buildValueRow("chatEnergyIntensity: ${_latestFeatureVector?.chatEnergyScore?.toStringAsFixed(4) ?? 'null'}"),
              _buildValueRow("negativeChatCount: ${_latestFeatureVector?.negativeChatCount ?? 0}"),
              _buildDivider(),
              _buildValueRow("burnoutScore: ${_reflection?.burnoutScore ?? '--'}"),
              _buildValueRow("burnoutLevel: ${_reflection?.burnoutLevel ?? '--'}"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Chat Signal Debug ────────────────────────────────
            _buildSection("Chat Signal Debug (Today's User Messages)", [
              if (_todayUserChats.isEmpty)
                _buildValueRow("No user chat messages today", isCyan: true)
              else ...[
                _buildValueRow("Messages Analyzed: ${_todayUserChats.length}", isCyan: true),
                const SizedBox(height: 8),
                ..._todayUserChats.asMap().entries.map((entry) {
                  final i = entry.key;
                  final chat = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildValueRow("Msg #${i + 1}: ${chat.message.length > 40 ? '${chat.message.substring(0, 37)}...' : chat.message}", isCyan: true),
                        _buildScoreBar("  Sentiment", chat.sentimentScore, -1.0, 1.0),
                        _buildScoreBar("  Stress", chat.stressScore, 0.0, 1.0),
                        _buildScoreBar("  Intensity", chat.emotionalIntensity, 0.0, 1.0),
                        _buildValueRow("  Negative: ${(chat.sentimentScore ?? 0) <= -0.3 ? '✓ YES' : '✗ no'}"),
                      ],
                    ),
                  );
                }),
                _buildDivider(),
                _buildValueRow("Avg Chat Sentiment: ${_latestFeatureVector?.chatSentiment?.toStringAsFixed(4) ?? 'null'}"),
                _buildValueRow("Avg Chat Stress: ${_latestFeatureVector?.chatStressScore?.toStringAsFixed(4) ?? 'null'}"),
                _buildValueRow("Avg Chat Intensity: ${_latestFeatureVector?.chatEnergyScore?.toStringAsFixed(4) ?? 'null'}"),
                _buildValueRow("Negative Chat Count: ${_latestFeatureVector?.negativeChatCount ?? 0}"),
                _buildValueRow("Raw Chat Risk Score: ${_reflection?.rawChatImpact.toStringAsFixed(1) ?? '--'}%"),
              ],
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Journal Sentiment Analysis ────────────────────────
            _buildSection("Journal Sentiment Analysis", [
              if (_latestJournal != null) ...[
                _buildValueRow("Journal #${_latestJournal!.id}", isCyan: true),
                _buildValueRow("Preview: ${_latestJournal!.preview}"),
                const SizedBox(height: 8),
                _buildScoreBar("Sentiment", _latestJournal!.sentimentScore, -1.0, 1.0),
                _buildScoreBar("Stress", _latestJournal!.stressScore, 0.0, 1.0),
                _buildScoreBar("Energy", _latestJournal!.energyScore, 0.0, 1.0),
                const SizedBox(height: 8),
                _buildValueRow("Keywords: ${_latestJournal!.emotionalKeywords ?? 'none'}"),
                _buildValueRow("Updated: ${_latestJournal!.updatedAt.toIso8601String().substring(0, 19)}"),
              ] else ...[
                _buildValueRow("No journal entries found", isCyan: true),
              ],
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Daily Mood Check-In ──────────────────────────────
            _buildSection("Daily Mood Check-In System", [
              _buildValueRow("Today's Mood: ${_todayMood?.moodLevel ?? 'Not logged'}"),
              _buildValueRow("Source: ${_todayMood?.source ?? '--'}"),
              _buildValueRow("Daily Reminder: Scheduled (7 PM)"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Burnout Engine Contributions ─────────────────────
            _buildSection("Burnout Engine — Raw Contributions", [
              _buildValueRow("Journal Contribution (40%):", isCyan: true),
              _buildValueRow("  Raw Impact: ${_reflection?.rawJournalImpact.toStringAsFixed(1) ?? '--'}%"),
              _buildValueRow("  Weighted: ${_reflection != null ? (_reflection!.rawJournalImpact * 0.40).toStringAsFixed(1) : '--'}%"),
              const SizedBox(height: 6),
              _buildValueRow("Chat Contribution (15%):", isCyan: true),
              _buildValueRow("  Raw Impact: ${_reflection?.rawChatImpact.toStringAsFixed(1) ?? '--'}%"),
              _buildValueRow("  Weighted: ${_reflection != null ? (_reflection!.rawChatImpact * 0.15).toStringAsFixed(1) : '--'}%"),
              const SizedBox(height: 6),
              _buildValueRow("Trend Contribution (10%):", isCyan: true),
              _buildValueRow("  Raw Impact: ${_reflection?.rawTrendImpact.toStringAsFixed(1) ?? '--'}%"),
              _buildValueRow("  Weighted: ${_reflection != null ? (_reflection!.rawTrendImpact * 0.10).toStringAsFixed(1) : '--'}%"),
              const SizedBox(height: 6),
              _buildValueRow("Activity Contribution (5%):", isCyan: true),
              _buildValueRow("  Raw Impact: ${_reflection?.rawActivityImpact.toStringAsFixed(1) ?? '--'}%"),
              _buildValueRow("  Weighted: ${_reflection != null ? (_reflection!.rawActivityImpact * 0.05).toStringAsFixed(1) : '--'}%"),
              const SizedBox(height: 6),
              _buildValueRow("Mood Contribution (30%):", isCyan: true),
              _buildValueRow("  Current Mood: ${_reflection?.currentMood ?? 'None'}"),
              _buildValueRow("  Adjustment: ${_reflection != null ? '${_reflection!.moodContribution >= 0 ? '+' : ''}${_reflection!.moodContribution.toStringAsFixed(1)}' : '--'}"),
              _buildDivider(),
              _buildValueRow("Burnout Before Mood: ${_reflection?.burnoutBeforeMoodAdjustment.toStringAsFixed(1) ?? '--'}"),
              _buildValueRow("Burnout After Mood:  ${_reflection?.burnoutAfterMoodAdjustment.toStringAsFixed(1) ?? '--'}"),
              _buildValueRow("Final Burnout Score: ${_reflection?.burnoutScore ?? '--'}", isCyan: true),
              const SizedBox(height: 6),
              _buildValueRow("Chat Details: ${_reflection?.chatContribution ?? 'None'}"),
              _buildValueRow("Journal Details: ${_reflection?.journalContribution ?? 'None'}"),
              _buildValueRow("Trend Details: ${_reflection?.trendContribution ?? 'None'}"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── App State & Delivery Tracking ────────────────────
            _buildSection("App State & Delivery Tracking", [
              _buildValueRow("Current App State: $_appState", isCyan: true),
              _buildValueRow("Foreground Notification Count: $_appForegroundCount"),
              _buildValueRow("Background Notification Count: $_appBackgroundCount"),
              _buildValueRow("Suppressed Notification Count: $_appSuppressedCount"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Notifications Debug (Enhanced) ───────────────────
            _buildSection("Notification Scheduler Status", [
              _buildValueRow("Notification Permission Granted: $_notifPermission", isCyan: true),
              _buildValueRow("Notification Scheduled: $_notifScheduled"),
              _buildValueRow("Next Scheduled Reminder: $_nextReminderType"),
              _buildValueRow("Notification Trigger Time: $_notifTriggerTime"),
              _buildValueRow("Last Notification Sent: $_lastNotifSent"),
              _buildValueRow("Background Delivery Enabled: $_bgDeliveryEnabled", isCyan: true),
              _buildDivider(),
              _buildValueRow("Active Dart Timers: $_dartTimerCount"),
              _buildDivider(),
              _buildValueRow("Total Notifications (Isar): $_totalNotificationsCount"),
              _buildValueRow("Unread: $_unreadNotificationsCount"),
              _buildValueRow("Pending Follow-Ups: $_pendingFollowUpsCount"),
              const SizedBox(height: 8),
              _buildValueRow("Notification Channel Status:", isCyan: true),
              _buildValueRow(_channelStatus),
              const SizedBox(height: 8),
              _buildValueRow("Notification Icon Status:", isCyan: true),
              _buildValueRow(_iconStatus),
              if (_pendingRequests.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildValueRow("Scheduled OS Requests:", isCyan: true),
                ..._pendingRequests.map((req) => _buildValueRow("  ID #${req.id}: ${req.title} -> ${req.body}")),
              ],
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Test Mode ────────────────────────────────────────
            _buildSection("Test Mode — Notification Delivery", [
              _buildValueRow("App State at Send Time: $_appState", isCyan: true),
              _buildValueRow("Foreground → In-App Snackbar (OS notification suppressed)"),
              _buildValueRow("Background → OS Android Notification"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _isSendingTest ? null : _sendTestReminder,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _isSendingTest ? Colors.grey[800] : Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Text(
                    _isSendingTest ? "SENDING..." : "SEND TEST REMINDER",
                    style: GoogleFonts.vt323(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _isSendingTest ? null : _sendTestReminder10s,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _isSendingTest ? Colors.grey[800] : Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Text(
                    _isSendingTest ? "SENDING..." : "SEND TEST REMINDER (10s)",
                    style: GoogleFonts.vt323(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (_testResult != null) ...[
                const SizedBox(height: 12),
                _buildValueRow("─── Test Result ───", isCyan: true),
                _buildValueRow("App State: ${_testResult!['appState'] ?? '--'}"),
                _buildValueRow("Delivery Path: ${_testResult!['deliveryPath'] ?? '--'}"),
                _buildValueRow("Expected: ${_testResult!['expected'] ?? '--'}"),
              ],
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Reflection Follow-Ups ────────────────────────────
            _buildSection("Reflection Follow-Ups", [
              _buildValueRow("Total Follow-Ups: ${_followUps.length}"),
              _buildValueRow("Active Follow-Ups: ${_followUps.where((f) => !f.resolved && !f.dismissed).length}"),
              const SizedBox(height: 10),
              if (_followUps.isEmpty)
                _buildValueRow("No follow-ups recorded yet")
              else
                ..._followUps.map((followUp) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildValueRow("ID #${followUp.id}: ${followUp.reason}", isCyan: true),
                      _buildValueRow("  Created At: ${followUp.createdAt.toIso8601String().substring(0, 19)}"),
                      _buildValueRow("  Status: ${followUp.resolved ? 'Resolved' : followUp.dismissed ? 'Dismissed' : 'Active'}"),
                      _buildValueRow("  Context Provided: ${followUp.userResponse ?? 'None'}"),
                    ],
                  ),
                )),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── AI Reflection Engine ─────────────────────────────
            _buildSection("AI Reflection Engine", [
              _buildValueRow("Burnout Explanation: ${_reflection?.burnoutExplanation ?? 'None'}"),
              const SizedBox(height: 6),
              _buildValueRow("Confidence: ${_reflection?.confidence.toStringAsFixed(1) ?? '--'}%"),
              _buildValueRow("Mood Score: ${_reflection?.moodScore ?? 'Not Logged'}"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Phase 2 AI Insight Generator ────────────────────
            _buildSection("Phase 2 AI Insight Generator", [
              if (_aiInsight != null) ...[
                _buildValueRow("Home Card Insight: ${_aiInsight!.homeCardInsight}"),
                _buildValueRow("Detailed Reflection: ${_aiInsight!.detailedReflection}"),
                _buildValueRow("Observation: ${_aiInsight!.observation}"),
                _buildValueRow("Suggestion: ${_aiInsight!.suggestion}"),
                const SizedBox(height: 10),
                _buildValueRow("History Days Available: ${_aiInsight!.historyDaysAvailable}"),
                _buildValueRow("Trend Available: ${_aiInsight!.trendAvailable}"),
                _buildValueRow("Average Comparison Available: ${_aiInsight!.averageComparisonAvailable}"),
                const SizedBox(height: 10),
                _buildValueRow("Available Signals:", isCyan: true),
                if (_aiInsight!.availableSignals.isEmpty)
                  _buildValueRow("  None")
                else
                  ..._aiInsight!.availableSignals.map((s) => _buildValueRow("  * $s")),
                const SizedBox(height: 10),
                _buildValueRow("Used Signals:", isCyan: true),
                if (_aiInsight!.signalsUsed.isEmpty)
                  _buildValueRow("  None")
                else
                  ..._aiInsight!.signalsUsed.map((s) => _buildValueRow("  + $s")),
                const SizedBox(height: 10),
                _buildValueRow("Confidence Contributions:", isCyan: true),
                _buildValueRow("  Base Confidence +20.0"),
                ..._aiInsight!.confidenceContributions.entries.map((e) => _buildValueRow("  ${e.key} +${e.value.toStringAsFixed(0)}")),
                _buildValueRow("  Final Confidence = ${_aiInsight!.confidence.toStringAsFixed(0)}%"),
                const SizedBox(height: 10),
                _buildValueRow("Signal Acceptance Reasons:", isCyan: true),
                if (_aiInsight!.signalAcceptanceReasons.isEmpty)
                  _buildValueRow("  None")
                else
                  ..._aiInsight!.signalAcceptanceReasons.map((r) => _buildValueRow("  + $r")),
                const SizedBox(height: 10),
                _buildValueRow("Signal Rejection Reasons:", isCyan: true),
                if (_aiInsight!.signalRejectionReasons.isEmpty)
                  _buildValueRow("  None")
                else
                  ..._aiInsight!.signalRejectionReasons.map((r) => _buildValueRow("  - $r")),
                const SizedBox(height: 10),
                _buildValueRow("Insight Factors Used:", isCyan: true),
                ..._aiInsight!.factorsUsed.map((f) => _buildValueRow("  - $f")),
                const SizedBox(height: 10),
                _buildValueRow("Generated At: ${_aiInsight!.generatedAt.toLocal().toString().split('.')[0]}"),
              ] else ...[
                _buildValueRow("No AI Insight Generated Yet", isCyan: true),
              ],
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Phase 3.2A Recovery Detection Engine ─────────────
            _buildSection("Recovery Detection Engine", [
              _buildValueRow("Detected Events: ${_recoveryEvents.length}"),
              if (_recoveryEvents.isEmpty)
                _buildValueRow("No recovery events detected", isCyan: true)
              else ...[
                ..._recoveryEvents.take(3).map((event) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildValueRow("Recovery Event: ${event.summary}", isCyan: true),
                      _buildValueRow("  Strength: ${event.recoveryStrength}"),
                      _buildValueRow("  Triggers: ${event.possibleTriggers.join(', ')}"),
                      _buildValueRow("  Mood Improvement: ${_moodValueToLevelString(event.startMood)} → ${_moodValueToLevelString(event.endMood)}"),
                      _buildValueRow("  Burnout Improvement: ${event.startBurnout.toStringAsFixed(0)} → ${event.endBurnout.toStringAsFixed(0)}"),
                      _buildValueRow("  Date: ${DateFormat('MMM d').format(event.startDate.toLocal())} to ${DateFormat('MMM d').format(event.endDate.toLocal())}"),
                    ],
                  ),
                )),
              ],
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _isDetectingRecovery
                    ? null
                    : () async {
                        setState(() => _isDetectingRecovery = true);
                        try {
                          await RecoveryDetectionService.instance.detectRecoveryEvents();
                          await _loadData();
                        } finally {
                          if (mounted) {
                            setState(() => _isDetectingRecovery = false);
                          }
                        }
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _isDetectingRecovery ? Colors.grey[800] : Colors.purpleAccent,
                    border: Border.all(color: Colors.purpleAccent, width: 2),
                  ),
                  child: _isDetectingRecovery
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : Text(
                          "TRIGGER RECOVERY DETECTION",
                          style: GoogleFonts.vt323(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Weekly Reflection Status ──────────────────────────
            _buildSection("Weekly Reflection Status", [
              _buildValueRow("Days Analysed: $_weeklyDaysAnalysed / 7"),
              _buildValueRow(
                  "Avg Mood: ${_weeklyReflection?.averageMoodScore.toStringAsFixed(1) ?? '--'} / 5.0"),
              _buildValueRow(
                  "Avg Burnout: ${_weeklyReflection?.averageBurnoutScore.toStringAsFixed(0) ?? '--'} / 100"),
              _buildValueRow(
                  "Mood Trend: ${_weeklyReflection?.moodTrend ?? '--'}",
                  isCyan: true),
              _buildValueRow(
                  "Burnout Trend: ${_weeklyReflection?.burnoutTrend ?? '--'}",
                  isCyan: true),
              _buildDivider(),
              _buildValueRow("Positive Indicators:", isCyan: true),
              if (_weeklyReflection == null ||
                  _weeklyReflection!.positiveIndicators.isEmpty)
                _buildValueRow("  None")
              else
                ..._weeklyReflection!.positiveIndicators
                    .map((s) => _buildValueRow("  + $s")),
              const SizedBox(height: 6),
              _buildValueRow("Negative Indicators:", isCyan: true),
              if (_weeklyReflection == null ||
                  _weeklyReflection!.negativeIndicators.isEmpty)
                _buildValueRow("  None")
              else
                ..._weeklyReflection!.negativeIndicators
                    .map((s) => _buildValueRow("  - $s")),
              const SizedBox(height: 6),
              _buildValueRow("Patterns Detected:", isCyan: true),
              if (_weeklyReflection == null ||
                  _weeklyReflection!.keyPatterns.isEmpty)
                _buildValueRow("  None")
              else
                ..._weeklyReflection!.keyPatterns
                    .map((s) => _buildValueRow("  * $s")),
              _buildDivider(),
              _buildValueRow(
                  "Raw Confidence: ${_weeklyReflection?.rawConfidence.toStringAsFixed(0) ?? '--'}%"),
              _buildValueRow(
                  "Confidence Cap: ${_weeklyReflection?.confidenceCap.toStringAsFixed(0) ?? '--'}%"),
              _buildValueRow(
                  "Final Confidence: ${_weeklyReflection?.confidence.toStringAsFixed(0) ?? '--'}%"),
              _buildValueRow(_weeklyReflection?.generatedAt != null
                  ? "Generated At: ${DateFormat('MMM d, h:mm a').format(_weeklyReflection!.generatedAt.toLocal())}"
                  : "Generated At: —"),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _isGeneratingWeekly
                    ? null
                    : () async {
                        setState(() => _isGeneratingWeekly = true);
                        try {
                          final r = await WeeklyReflectionService.instance
                              .generateReflection();
                          setState(() {
                            _weeklyReflection = r;
                            _isGeneratingWeekly = false;
                          });
                        } catch (e) {
                          setState(() => _isGeneratingWeekly = false);
                        }
                      },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _isGeneratingWeekly
                        ? Colors.grey[800]
                        : Colors.cyanAccent,
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                  ),
                  child: _isGeneratingWeekly
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                              color: Colors.black, strokeWidth: 2))
                      : Text(
                          "TRIGGER WEEKLY REFLECTION",
                          style: GoogleFonts.vt323(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Phase 3.2B Pattern Discovery Engine ─────────────
            _buildSection("Pattern Discovery Engine", [
              _buildValueRow("Pattern Candidates", isCyan: true),
              if (PatternDiscoveryService.lastDebugInfo.isEmpty)
                _buildValueRow("Run discovery to see candidates")
              else
                ...PatternDiscoveryService.lastDebugInfo.map((info) => Padding(
                  padding: const EdgeInsets.only(bottom: 12, left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildValueRow("Candidate: ${info.category}", isCyan: true),
                      _buildValueRow("  History Days Available: ${info.historyDaysAvailable}"),
                      _buildValueRow("  Required Occurrences: ${info.requiredOccurrences}"),
                      _buildValueRow("  Actual Occurrences: ${info.count}"),
                      _buildValueRow("  Acceptance Result: ${info.accepted ? 'ACCEPTED' : 'REJECTED'}"),
                      _buildValueRow("  Confidence: ${info.confidence}"),
                      _buildDivider(),
                      _buildValueRow("  Mood Evidence Available: ${info.mood != null ? 'Yes' : 'No'}"),
                      _buildValueRow("  Burnout Evidence Available: ${info.burnout != null ? 'Yes' : 'No'}"),
                      _buildValueRow("  Associated Mood Change: ${info.mood != null ? info.mood!.toStringAsFixed(1) : 'Insufficient Data'}"),
                      _buildValueRow("  Associated Burnout Change: ${info.burnout != null ? info.burnout!.toStringAsFixed(2) : 'Insufficient Data'}"),
                      _buildValueRow("  Reason: ${info.reason}"),
                    ],
                  ),
                )),
              _buildDivider(),
              _buildValueRow("Patterns Detected: ${_patternInsights.length}"),
              if (_patternInsights.isEmpty)
                _buildValueRow("No patterns detected (Need >= 2 evidence)", isCyan: true)
              else ...[
                ..._patternInsights.map((pattern) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildValueRow("Pattern: ${pattern.patternName}", isCyan: true),
                      _buildValueRow("  Description: ${pattern.description}"),
                      _buildValueRow("  Evidence Count: ${pattern.supportingEvidence} occurrences"),
                      _buildValueRow("  Confidence: ${pattern.confidence}"),
                      _buildValueRow("  Associated Outcome: ${pattern.associationType}"),
                      _buildValueRow("  Generated At: ${DateFormat('MMM d, h:mm a').format(pattern.generatedAt.toLocal())}"),
                    ],
                  ),
                )),
              ],
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _isDiscoveringPatterns
                    ? null
                    : () async {
                        setState(() => _isDiscoveringPatterns = true);
                        try {
                          await PatternDiscoveryService.instance.discoverPatterns();
                          await _loadData();
                        } finally {
                          if (mounted) {
                            setState(() => _isDiscoveringPatterns = false);
                          }
                        }
                      },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _isDiscoveringPatterns ? Colors.grey[800] : Colors.blueAccent,
                    border: Border.all(color: Colors.blueAccent, width: 2),
                  ),
                  child: _isDiscoveringPatterns
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                      : Text(
                          "TRIGGER PATTERN DISCOVERY",
                          style: GoogleFonts.vt323(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Timeline Events Debug ────────────────────────────
            _buildSection("Timeline Events Debug", [
              _buildValueRow("Timeline Events Generated: $_timelineTotalEvents", isCyan: true),
              _buildValueRow("Pattern Events: $_timelinePatternEvents"),
              _buildValueRow("Recovery Events: $_timelineRecoveryEvents"),
              _buildValueRow("Conflict Events: $_timelineConflictEvents"),
              _buildValueRow("Weekly Reflection Events: $_timelineWeeklyEvents"),
            ]),
            // ── Username Privacy ────────────────────────────────
            _buildSection("Username Privacy", [
              _buildValueRow("Test real-name filter rules.", isCyan: true),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/username-privacy-tester');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Text(
                    "OPEN USERNAME TESTER",
                    style: GoogleFonts.vt323(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Avatar Privacy ────────────────────────────────
            _buildSection("Avatar Privacy", [
              _buildValueRow("Test avatar face detection.", isCyan: true),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/avatar-privacy-tester');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Text(
                    "OPEN AVATAR TESTER",
                    style: GoogleFonts.vt323(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Pseudonymization Engine ────────────────────────────────
            _buildSection("Pseudonymization Engine", [
              _buildValueRow("Test conversation name replacement.", isCyan: true),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/pseudonymization-tester');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Text(
                    "OPEN PSEUDONYMIZATION TESTER",
                    style: GoogleFonts.vt323(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── Sanitized Storage Engine ────────────────────────────────
            _buildSection("Sanitized Storage", [
              _buildValueRow("Test sanitized community post storage.", isCyan: true),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/sanitized-storage-tester');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Text(
                    "OPEN SANITIZED STORAGE TESTER",
                    style: GoogleFonts.vt323(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── AI Community Recommendation Engine ────────────────────────────────
            _buildSection("Community Recommendation Engine", [
              _buildValueRow("Test wellness-based community recommendations.", isCyan: true),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/community-recommendation-tester');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Text(
                    "OPEN COMMUNITY REC TESTER",
                    style: GoogleFonts.vt323(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),

            // ── AI Situation Detection Engine ────────────────────────────────
            _buildSection("Situation Detection Engine", [
              _buildValueRow("Test detection of user wellness situations.", isCyan: true),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/situation-detection-tester');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    border: Border.all(color: Colors.greenAccent, width: 2),
                  ),
                  child: Text(
                    "OPEN SITUATION DETECTION TESTER",
                    style: GoogleFonts.vt323(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: _loadData,
        child: const Icon(Icons.refresh, color: Colors.black),
      ),
    );
  }

  String _moodValueToLevelString(double val) {
    if (val >= 5) return 'GREAT';
    if (val >= 4) return 'GOOD';
    if (val >= 3) return 'OKAY';
    if (val >= 2) return 'LOW';
    if (val >= 1) return 'STRUGGLING';
    return 'UNKNOWN';
  }

  Widget _buildDashedLine() {
    return Text(
      "------------------------",
      style: GoogleFonts.vt323(color: Colors.grey[600], fontSize: 18, letterSpacing: 2),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        "  ···",
        style: GoogleFonts.vt323(color: Colors.grey[700], fontSize: 14),
      ),
    );
  }

  Widget _buildValueRow(String text, {bool isCyan = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(
        text,
        style: GoogleFonts.vt323(
          color: isCyan ? Colors.cyanAccent : Colors.white,
          fontSize: 18,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildScoreBar(String label, double? value, double min, double max) {
    final displayValue = value?.toStringAsFixed(4) ?? 'null';
    final hasValue = value != null;

    double normalizedValue = 0.5;
    if (hasValue) {
      normalizedValue = ((value - min) / (max - min)).clamp(0.0, 1.0);
    }

    Color barColor;
    if (label.contains('Sentiment')) {
      barColor = (value ?? 0) >= 0 ? Colors.greenAccent : Colors.redAccent;
    } else if (label.contains('Stress') || label.contains('Intensity')) {
      barColor = (value ?? 0) > 0.5 ? Colors.redAccent : Colors.greenAccent;
    } else {
      barColor = (value ?? 0.5) > 0.5 ? Colors.greenAccent : Colors.redAccent;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: $displayValue",
            style: GoogleFonts.vt323(color: Colors.white, fontSize: 18, letterSpacing: 1),
          ),
          const SizedBox(height: 2),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: hasValue ? normalizedValue : 0,
              child: Container(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.vt323(
              color: Colors.orange[200] ?? Colors.orange,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
}
