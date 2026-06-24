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

class MoodCheckInPage extends StatefulWidget {
  const MoodCheckInPage({super.key});

  @override
  State<MoodCheckInPage> createState() => _MoodCheckInPageState();
}

class _MoodCheckInPageState extends State<MoodCheckInPage> {
  WeeklyReflection? _weeklyReflection;
  List<RecoveryEvent> _recoveryEvents = [];
  bool _isDetectingRecovery = false;

  @override
  void initState() {
    super.initState();
    _loadWeeklyReflection();
    _loadRecoveryEvents();
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF6EE), // Light beige background
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAF6EE),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "JOURNAL",
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
      body: SingleChildScrollView(
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
                    "🔥 5 DAY STREAK",
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
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WHAT'S GOING ON?",
                    style: GoogleFonts.anton(
                      fontSize: 48,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Log It Button
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DailyDiaryPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        border: Border.all(color: Colors.black, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFFFD600), // Yellow shadow
                            offset: Offset(4, 4),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "LOG IT →",
                            style: GoogleFonts.anton(
                              color: Colors.white,
                              fontSize: 24,
                              letterSpacing: 1.0,
                            ),
                          ),
                          const Icon(Icons.check_circle_outline, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
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
                  Container(
                    width: 4,
                    height: 40,
                    color: Colors.black,
                    margin: const EdgeInsets.symmetric(horizontal: 28),
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
          Text(
            "RECOVERY DETECTION",
            style: GoogleFonts.anton(
              fontSize: 48,
              color: Colors.black,
              height: 1.0,
            ),
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
            ..._recoveryEvents.take(3).map((event) => Container(
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
