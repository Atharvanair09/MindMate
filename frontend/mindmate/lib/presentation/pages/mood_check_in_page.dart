import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:isar/isar.dart';
import 'package:intl/intl.dart';
import '../widgets/bottom_nav.dart';
import 'daily_diary_page.dart';
import 'weekly_reflection_page.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../services/weekly_reflection/weekly_reflection_service.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/recovery_event.dart';
import '../../services/ml/recovery_detection_service.dart';
import '../widgets/global_background.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/daily_mood_check_in.dart';

class MoodCheckInPage extends StatefulWidget {
  const MoodCheckInPage({super.key});

  @override
  State<MoodCheckInPage> createState() => _MoodCheckInPageState();
}

class _MoodCheckInPageState extends State<MoodCheckInPage> {
  WeeklyReflection? _weeklyReflection;
  List<RecoveryEvent> _recoveryEvents = [];
  bool _isDetectingRecovery = false;
  int _streakCount = 0;

  bool _showAllRecovery = false;
  bool _isWeeklySummaryExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadWeeklyReflection();
    _loadRecoveryEvents();
    _loadStreak();
  }

  Future<void> _loadWeeklyReflection() async {
    final r = await WeeklyReflectionService.instance.getLatestReflection();
    if (mounted) setState(() => _weeklyReflection = r);
  }

  Future<void> _loadRecoveryEvents() async {
    final isar = IsarDatabase.instance;
    final recoveryEvents = await isar.recoveryEvents
        .where()
        .sortByGeneratedAtDesc()
        .findAll();
    if (mounted) {
      setState(() => _recoveryEvents = recoveryEvents);
    }
  }

  Future<void> _loadStreak() async {
    try {
      final isar = IsarDatabase.instance;
      final Set<String> activeDates = {};

      // 1. Mood Check-ins
      final moods = await isar.dailyMoodCheckIns.where().findAll();
      for (final m in moods) {
        activeDates.add("${m.date.year}-${m.date.month.toString().padLeft(2, '0')}-${m.date.day.toString().padLeft(2, '0')}");
      }

      // 2. Journal Entries
      final journals = await isar.journalEntrys.filter().isDeletedEqualTo(false).findAll();
      for (final j in journals) {
        final localDate = j.journalDate.toLocal();
        activeDates.add("${localDate.year}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}");
      }

      // 3. Chats (where role == 'user')
      final chats = await isar.chatMessages.filter().roleEqualTo('user').findAll();
      for (final c in chats) {
        final localDate = c.createdAt.toLocal();
        activeDates.add("${localDate.year}-${localDate.month.toString().padLeft(2, '0')}-${localDate.day.toString().padLeft(2, '0')}");
      }

      int streak = 0;
      DateTime dateToCheck = DateTime.now();
      String todayStr = "${dateToCheck.year}-${dateToCheck.month.toString().padLeft(2, '0')}-${dateToCheck.day.toString().padLeft(2, '0')}";

      if (activeDates.contains(todayStr)) {
        while (true) {
          final checkStr = "${dateToCheck.year}-${dateToCheck.month.toString().padLeft(2, '0')}-${dateToCheck.day.toString().padLeft(2, '0')}";
          if (activeDates.contains(checkStr)) {
            streak++;
            dateToCheck = dateToCheck.subtract(const Duration(days: 1));
          } else {
            break;
          }
        }
      } else {
        dateToCheck = dateToCheck.subtract(const Duration(days: 1));
        while (true) {
          final checkStr = "${dateToCheck.year}-${dateToCheck.month.toString().padLeft(2, '0')}-${dateToCheck.day.toString().padLeft(2, '0')}";
          if (activeDates.contains(checkStr)) {
            streak++;
            dateToCheck = dateToCheck.subtract(const Duration(days: 1));
          } else {
            break;
          }
        }
      }

      if (mounted) {
        setState(() {
          _streakCount = streak;
        });
      }
    } catch (e) {
      debugPrint("Error calculating activity streak: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "INSIGHTS",
          style: GoogleFonts.anton(
            color: Colors.black,
            fontSize: 26,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.black,
            height: 2.0,
          ),
        ),
      ),
      body: GlobalBackgroundLayer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Streak Banner
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFFD600), // Yellow
                border: Border(
                  bottom: BorderSide(color: Colors.black, width: 2),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "🔥 $_streakCount DAY STREAK",
                    style: GoogleFonts.anton(
                      color: Colors.black,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                  Text(
                    "KEEP GOING",
                    style: GoogleFonts.anton(
                      color: Colors.black,
                      fontSize: 14,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            _buildWeeklySummarySection(),
            
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "HOW ARE YOU DOING?",
                    style: GoogleFonts.anton(
                      fontSize: 46,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  if (_weeklyReflection != null)
                    _buildWeeklyStatusCard()
                  else
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "No reflection generated yet.\nKeep logging your mood!",
                        style: GoogleFonts.spaceMono(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            _buildRecoverySection(),
            const SizedBox(height: 50)
          ],
        ),
      ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 2),
    );
  }

  Widget _buildWeeklyStatusCard() {
    final r = _weeklyReflection!;

    Color moodColor;
    switch (r.moodTrend) {
      case 'Improving':
        moodColor = const Color(0xFF00C853);
        break;
      case 'Declining':
        moodColor = Colors.redAccent;
        break;
      default:
        moodColor = Colors.orange;
    }

    Color burnoutColor;
    switch (r.burnoutTrend) {
      case 'Improving':
        burnoutColor = const Color(0xFF00C853);
        break;
      case 'Increasing':
        burnoutColor = Colors.redAccent;
        break;
      default:
        burnoutColor = Colors.orange;
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const WeeklyReflectionPage(),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFFD600),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'WEEKLY REFLECTION',
                    style: GoogleFonts.anton(
                      color: const Color(0xFFFFD600),
                      fontSize: 20,
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    'view full →',
                    style: GoogleFonts.spaceMono(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Mood Trend
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MOOD TREND',
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.moodTrend.toUpperCase(),
                          style: GoogleFonts.anton(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Divider
                  Center(
                    child: Container(
                      width: 4,
                      height: 40,
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(horizontal: 28),
                    ),
                  ),
                  // Burnout Trend
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'BURNOUT TREND',
                          style: GoogleFonts.spaceMono(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          r.burnoutTrend.toUpperCase(),
                          style: GoogleFonts.anton(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecoverySection() {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  "RECOVERY DETECTION",
                  style: GoogleFonts.anton(
                    fontSize: 48,
                    color: Colors.black,
                    height: 1.0,
                  ),
                ),
              ),
              if (_recoveryEvents.length > 1)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _showAllRecovery = !_showAllRecovery;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.black, width: 2),
                    ),
                    child: Text(
                      _showAllRecovery ? "LESS ↑" : "ALL →",
                      style: GoogleFonts.spaceMono(
                        color: const Color(0xFFFFD600), // Yellow accent text on black block
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          if (_recoveryEvents.isEmpty)
            Text(
              "No recovery events detected",
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                color: Colors.black54,
              ),
            )
          else ...[
            ...(_showAllRecovery ? _recoveryEvents : _recoveryEvents.take(1)).map((event) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.summary.toUpperCase(),
                    style: GoogleFonts.anton(
                      fontSize: 24,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildRecoveryDetailRow("STRENGTH", event.recoveryStrength),
                  _buildRecoveryDetailRow("TRIGGERS", event.possibleTriggers.join(', ')),
                  _buildRecoveryDetailRow("MOOD", "${_moodValueToLevelString(event.startMood)} → ${_moodValueToLevelString(event.endMood)}"),
                  _buildRecoveryDetailRow("BURNOUT", "${event.startBurnout.toStringAsFixed(0)} → ${event.endBurnout.toStringAsFixed(0)}"),
                  _buildRecoveryDetailRow("DATE", "${DateFormat('MMM d').format(event.startDate.toLocal())} - ${DateFormat('MMM d').format(event.endDate.toLocal())}"),
                ],
              ),
            )),
          ],
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _isDetectingRecovery
                ? null
                : () async {
                    setState(() => _isDetectingRecovery = true);
                    try {
                      await RecoveryDetectionService.instance.detectRecoveryEvents();
                      await _loadRecoveryEvents();
                    } finally {
                      if (mounted) {
                        setState(() => _isDetectingRecovery = false);
                      }
                    }
                  },
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                color: _isDetectingRecovery ? Colors.grey[400] : const Color(0xFFB388FF), // Purple accent
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black, // Shadow
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isDetectingRecovery)
                    const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2),
                    )
                  else
                    Text(
                      "TRIGGER RECOVERY DETECTION",
                      style: GoogleFonts.anton(
                        color: Colors.black,
                        fontSize: 20,
                        letterSpacing: 1.0,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklySummarySection() {
    if (_weeklyReflection == null) {
      return const SizedBox.shrink();
    }

    final r = _weeklyReflection!;

    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WEEKLY SUMMARY",
            style: GoogleFonts.anton(
              fontSize: 48,
              color: Colors.black,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AVG MOOD",
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${r.averageMoodScore.toStringAsFixed(1)} / 5.0",
                        style: GoogleFonts.anton(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black,
                        offset: Offset(4, 4),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AVG BURNOUT",
                        style: GoogleFonts.spaceMono(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${r.averageBurnoutScore.toStringAsFixed(0)} / 100",
                        style: GoogleFonts.anton(
                          fontSize: 20,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () {
              setState(() {
                _isWeeklySummaryExpanded = !_isWeeklySummaryExpanded;
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFE0F7FA),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    color: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "AI DETAILED REFLECTION",
                            style: GoogleFonts.anton(
                              color: Colors.white,
                              fontSize: 18,
                              letterSpacing: 1,
                            ),
                          ),
                        ),
                        Icon(
                          _isWeeklySummaryExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.summary,
                          style: GoogleFonts.spaceMono(
                            fontSize: 13,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        if (_isWeeklySummaryExpanded) ...[
                          const SizedBox(height: 16),
                          Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "OBSERVATIONS & SUGGESTIONS",
                            style: GoogleFonts.anton(
                              fontSize: 16,
                              color: Colors.black,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            r.suggestion,
                            style: GoogleFonts.spaceMono(
                              fontSize: 13,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                          ),
                          if (r.keyPatterns.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            Text(
                              "KEY PATTERNS DETECTED:",
                              style: GoogleFonts.spaceMono(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ...r.keyPatterns.map((pattern) => Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("• ", style: GoogleFonts.spaceMono(fontWeight: FontWeight.bold)),
                                  Expanded(
                                    child: Text(
                                      pattern,
                                      style: GoogleFonts.spaceMono(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecoveryDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.spaceMono(
                fontSize: 12,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
}
