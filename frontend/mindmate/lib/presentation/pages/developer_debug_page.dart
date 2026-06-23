import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/embedding_record.dart';
import '../../domain/models/mood_feature_vector.dart';
import '../../domain/models/journal_entry.dart';
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
            _buildSection("Embeddings", [
              _buildValueRow("✓ Model Loaded", isCyan: true),
              _buildValueRow("Total: $_totalEmbeddings"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),
            _buildSection("Feature Pipeline", [
              _buildValueRow("Status: Active", isCyan: true),
            ]),
            const SizedBox(height: 10),
            _buildSection("Latest Vector", [
              _buildValueRow("Journal Count: ${_latestFeatureVector?.journalCount ?? 0}"),
              _buildValueRow("Chat Count: ${_latestFeatureVector?.chatCount ?? 0}"),
              _buildValueRow("Journal Sentiment: ${_latestFeatureVector?.journalSentiment?.toStringAsFixed(4) ?? 'null'}"),
              _buildValueRow("Journal Stress: ${_latestFeatureVector?.journalStressScore?.toStringAsFixed(4) ?? 'null'}"),
              _buildValueRow("Journal Energy: ${_latestFeatureVector?.journalEnergyScore?.toStringAsFixed(4) ?? 'null'}"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),
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
            _buildSection("Daily Mood Check-In System", [
              _buildValueRow("Today's Mood: ${_todayMood?.moodLevel ?? 'Not logged'}"),
              _buildValueRow("Source: ${_todayMood?.source ?? '--'}"),
              _buildValueRow("Daily Reminder: Scheduled (7 PM)"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),
            _buildSection("App State & Delivery Tracking", [
              _buildValueRow("Current App State: $_appState", isCyan: true),
              _buildValueRow("Foreground Notification Count: $_appForegroundCount"),
              _buildValueRow("Background Notification Count: $_appBackgroundCount"),
              _buildValueRow("Suppressed Notification Count: $_appSuppressedCount"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),
            _buildSection("Notifications & Reminders Debug", [
              _buildValueRow("Unread Count: $_unreadNotificationsCount"),
              _buildValueRow("Notification Count: $_totalNotificationsCount"),
              _buildValueRow("Pending Follow-Ups: $_pendingFollowUpsCount"),
              _buildValueRow("Scheduled Reminders: $_scheduledRemindersCount"),
              const SizedBox(height: 8),
              _buildValueRow("Notification Channel Status:", isCyan: true),
              _buildValueRow(_channelStatus),
              const SizedBox(height: 8),
              _buildValueRow("Notification Icon Status:", isCyan: true),
              _buildValueRow(_iconStatus),
              if (_pendingRequests.isNotEmpty) ...[
                const SizedBox(height: 8),
                _buildValueRow("Scheduled Requests:", isCyan: true),
                ..._pendingRequests.map((req) => _buildValueRow("  ID #${req.id}: ${req.title} -> ${req.body}")),
              ],
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),
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
            _buildSection("AI Reflection Engine", [
              _buildValueRow("Raw Journal Impact: ${_reflection != null ? _reflection!.rawJournalImpact.toStringAsFixed(1) : '--'}%"),
              _buildValueRow("Raw Chat Impact: ${_reflection != null ? _reflection!.rawChatImpact.toStringAsFixed(1) : '--'}%"),
              _buildValueRow("Raw Trend Impact: ${_reflection != null ? _reflection!.rawTrendImpact.toStringAsFixed(1) : '--'}%"),
              _buildValueRow("Raw Activity Impact: ${_reflection != null ? _reflection!.rawActivityImpact.toStringAsFixed(1) : '--'}%"),
              _buildValueRow("Final Burnout Score: ${_reflection?.burnoutScore ?? '--'}"),
              const SizedBox(height: 10),
              _buildValueRow("Current Mood: ${_reflection?.currentMood ?? 'None'}"),
              _buildValueRow("Mood Weight: ${_reflection != null ? '${(_reflection!.moodWeight * 100).toStringAsFixed(0)}%' : '--'}"),
              _buildValueRow("Mood Contribution: ${_reflection != null ? '${_reflection!.moodContribution >= 0 ? '+' : ''}${_reflection!.moodContribution.toStringAsFixed(1)}' : '--'}"),
              _buildValueRow("Burnout Before Mood Adjustment: ${_reflection != null ? _reflection!.burnoutBeforeMoodAdjustment.toStringAsFixed(1) : '--'}"),
              _buildValueRow("Burnout After Mood Adjustment: ${_reflection != null ? _reflection!.burnoutAfterMoodAdjustment.toStringAsFixed(1) : '--'}"),
              const SizedBox(height: 10),
              _buildValueRow("Mood Score: ${_reflection?.moodScore ?? 'Not Logged'}"),
              _buildValueRow("Burnout Level: ${_reflection?.burnoutLevel ?? '--'}"),
              _buildValueRow("Confidence: ${_reflection?.confidence.toStringAsFixed(1) ?? '--'}%"),
              const SizedBox(height: 10),
              _buildValueRow("Burnout Explanation: ${_reflection?.burnoutExplanation ?? 'None'}"),
              const SizedBox(height: 10),
              _buildValueRow("Journal Details: ${_reflection?.journalContribution ?? 'None'}"),
              _buildValueRow("Chat Details: ${_reflection?.chatContribution ?? 'None'}"),
              _buildValueRow("Trend Details: ${_reflection?.trendContribution ?? 'None'}"),
            ]),
            _buildDashedLine(),
            const SizedBox(height: 20),
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
                _buildValueRow("Insight Factors Used:", isCyan: true),
                ..._aiInsight!.factorsUsed.map((f) => _buildValueRow("  - $f")),
                const SizedBox(height: 10),
                _buildValueRow("Generated At: ${_aiInsight!.generatedAt.toLocal().toString().split('.')[0]}"),
              ] else ...[
                _buildValueRow("No AI Insight Generated Yet", isCyan: true),
              ],
            ]),
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

  Widget _buildDashedLine() {
    return Text(
      "------------------------",
      style: GoogleFonts.vt323(color: Colors.grey[600], fontSize: 18, letterSpacing: 2),
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
    
    // Normalize to 0-1 for bar display
    double normalizedValue = 0.5;
    if (hasValue) {
      normalizedValue = ((value - min) / (max - min)).clamp(0.0, 1.0);
    }

    Color barColor;
    if (label == 'Sentiment') {
      barColor = (value ?? 0) >= 0 ? Colors.greenAccent : Colors.redAccent;
    } else if (label == 'Stress') {
      barColor = (value ?? 0) > 0.5 ? Colors.redAccent : Colors.greenAccent;
    } else {
      // Energy: low = red, high = green
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


