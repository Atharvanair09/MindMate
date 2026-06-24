import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../services/weekly_reflection/weekly_reflection_service.dart';

class WeeklyReflectionPage extends StatefulWidget {
  const WeeklyReflectionPage({super.key});

  @override
  State<WeeklyReflectionPage> createState() => _WeeklyReflectionPageState();
}

class _WeeklyReflectionPageState extends State<WeeklyReflectionPage> {
  WeeklyReflection? _reflection;
  bool _isLoading = true;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    final r = await WeeklyReflectionService.instance.getLatestReflection();
    if (mounted) setState(() {
      _reflection = r;
      _isLoading = false;
    });
  }

  Future<void> _generate() async {
    setState(() => _isGenerating = true);
    try {
      final r = await WeeklyReflectionService.instance.generateReflection();
      if (mounted) setState(() {
        _reflection = r;
        _isGenerating = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isGenerating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating reflection: $e',
                style: GoogleFonts.spaceMono(fontSize: 14, color: Colors.black, fontWeight: FontWeight.bold)),
            backgroundColor: const Color(0xFFFFD600),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          'WEEKLY REFLECTION',
          style: GoogleFonts.anton(
            color: Colors.black,
            fontSize: 26,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_reflection == null) ...[
                    _buildEmptyState(),
                  ] else ...[
                    _buildOverviewSection(),
                    const SizedBox(height: 20),
                    _buildTrendSection(),
                    const SizedBox(height: 20),
                    _buildIndicatorsSection(),
                    const SizedBox(height: 20),
                    _buildPatternsSection(),
                    const SizedBox(height: 20),
                    _buildRecommendationSection(),
                    const SizedBox(height: 20),
                  ],
                  _buildGenerateButton(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD600),
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📊 NO REFLECTION YET',
            style: GoogleFonts.anton(
              fontSize: 24,
              color: Colors.black,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Keep logging your mood daily. A weekly reflection generates automatically after 7 days of data, or tap the button below to generate one now.',
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Overview ─────────────────────────────────────────────────────────────

  Widget _buildOverviewSection() {
    final r = _reflection!;
    final dateRange =
        '${DateFormat('MMM d').format(r.weekStartDate)} – ${DateFormat('MMM d, yyyy').format(r.weekEndDate)}';
    final genDate = DateFormat('MMM d, h:mm a').format(r.generatedAt.toLocal());

    return _buildCard(
      header: 'OVERVIEW',
      headerTextColor: const Color(0xFFFFD600),
      headerBgColor: Colors.black,
      cardBgColor: const Color(0xFFFFD600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKvRow('Period', dateRange),
          _buildKvRow(
              'Avg Mood', '${r.averageMoodScore.toStringAsFixed(1)} / 5.0'),
          _buildKvRow(
              'Avg Burnout', '${r.averageBurnoutScore.toStringAsFixed(0)} / 100'),
          _buildKvRow('Confidence', '${r.confidence.toStringAsFixed(0)}%'),
          _buildKvRow('Generated', genDate),
          const SizedBox(height: 8),
          Text(
            r.summary,
            style: GoogleFonts.spaceMono(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ── Trends ────────────────────────────────────────────────────────────────

  Widget _buildTrendSection() {
    final r = _reflection!;
    return Row(
      children: [
        Expanded(child: _buildTrendCard('MOOD', r.moodTrend, _moodTrendColor(r.moodTrend), _moodTrendIcon(r.moodTrend))),
        const SizedBox(width: 16),
        Expanded(child: _buildTrendCard('BURNOUT', r.burnoutTrend, _burnoutTrendColor(r.burnoutTrend), _burnoutTrendIcon(r.burnoutTrend))),
      ],
    );
  }

  Widget _buildTrendCard(String label, String trend, Color color, String icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.spaceMono(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            icon,
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 4),
          Text(
            trend.toUpperCase(),
            style: GoogleFonts.anton(
              fontSize: 24,
              color: color,
              letterSpacing: 1.0,
            ),
          ),
        ],
      ),
    );
  }

  // ── Indicators ────────────────────────────────────────────────────────────

  Widget _buildIndicatorsSection() {
    final r = _reflection!;
    return Column(
      children: [
        _buildCard(
          header: '✅ POSITIVE INDICATORS',
          headerTextColor: Colors.white,
          headerBgColor: Colors.black,
          cardBgColor: const Color(0xFFFFD600),
          child: r.positiveIndicators.isEmpty
              ? _buildEmptyNote('No positive indicators detected this week.')
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: r.positiveIndicators
                      .map((s) => _buildBullet(s, Colors.greenAccent))
                      .toList(),
                ),
        ),
        const SizedBox(height: 16),
        _buildCard(
          header: '⚠️ NEGATIVE INDICATORS',
          headerTextColor: Colors.black,
          headerBgColor: const Color(0xFFFFD600),
          cardBgColor: Colors.black,
          child: r.negativeIndicators.isEmpty
              ? _buildEmptyNote('No significant negative indicators this week.', color: Colors.white70)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: r.negativeIndicators
                      .map((s) => _buildBullet(s, Colors.redAccent, textColor: Colors.white))
                      .toList(),
                ),
        ),
      ],
    );
  }

  // ── Patterns ──────────────────────────────────────────────────────────────

  Widget _buildPatternsSection() {
    final r = _reflection!;
    return _buildCard(
      header: '🔍 PATTERNS DETECTED',
      headerTextColor: const Color(0xFFFFD600),
      headerBgColor: Colors.black,
      cardBgColor: const Color(0xFFFFD600),
      child: r.keyPatterns.isEmpty
          ? _buildEmptyNote('Not enough data to detect patterns yet.', color: Colors.black54)
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: r.keyPatterns
                  .map((p) => _buildBullet(p, Colors.black))
                  .toList(),
            ),
    );
  }

  // ── Recommendation ────────────────────────────────────────────────────────

  Widget _buildRecommendationSection() {
    return _buildCard(
      header: '💡 RECOMMENDATION',
      headerTextColor: Colors.black,
      headerBgColor: const Color(0xFFFFD600),
      cardBgColor: Colors.black,
      child: Text(
        _reflection!.suggestion,
        style: GoogleFonts.spaceMono(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          height: 1.5,
        ),
      ),
    );
  }

  // ── Generate Button ───────────────────────────────────────────────────────

  Widget _buildGenerateButton() {
    return GestureDetector(
      onTap: _isGenerating ? null : _generate,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _isGenerating ? Colors.grey[700] : Colors.black,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(color: Color(0xFFFFD600), offset: Offset(4, 4), blurRadius: 0)
          ],
        ),
        child: Center(
          child: _isGenerating
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                      color: Color(0xFFFFD600), strokeWidth: 2.5),
                )
              : Text(
                  'GENERATE REFLECTION',
                  style: GoogleFonts.anton(
                    fontSize: 24,
                    color: const Color(0xFFFFD600),
                    letterSpacing: 1.0,
                  ),
                ),
        ),
      ),
    );
  }

  // ── Shared Widgets ────────────────────────────────────────────────────────

  Widget _buildCard({
    required String header,
    required Color headerTextColor,
    Color headerBgColor = Colors.black,
    Color cardBgColor = Colors.white,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBgColor,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: headerBgColor,
            child: Text(
              header,
              style: GoogleFonts.anton(
                fontSize: 20,
                color: headerTextColor,
                letterSpacing: 1.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildKvRow(String key, String value, {Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            key,
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor.withOpacity(0.6),
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text, Color dotColor, {Color textColor = Colors.black87}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5, right: 8),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: dotColor,
                border: Border.all(color: Colors.black, width: 1),
              ),
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.spaceMono(
                fontSize: 15,
                color: textColor,
                height: 1.45,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyNote(String text, {Color color = Colors.grey}) {
    return Text(
      text,
      style: GoogleFonts.spaceMono(
        fontSize: 14,
        color: color,
        letterSpacing: 0.5,
      ),
    );
  }

  // ── Colour / Icon helpers ─────────────────────────────────────────────────

  Color _moodTrendColor(String trend) {
    switch (trend) {
      case 'Improving':
        return const Color(0xFF00C853);
      case 'Declining':
        return Colors.redAccent;
      default:
        return const Color(0xFFFFD600);
    }
  }

  String _moodTrendIcon(String trend) {
    switch (trend) {
      case 'Improving':
        return '📈';
      case 'Declining':
        return '📉';
      default:
        return '➡️';
    }
  }

  Color _burnoutTrendColor(String trend) {
    switch (trend) {
      case 'Improving':
        return const Color(0xFF00C853);
      case 'Increasing':
        return Colors.redAccent;
      default:
        return const Color(0xFFFFD600);
    }
  }

  String _burnoutTrendIcon(String trend) {
    switch (trend) {
      case 'Improving':
        return '✅';
      case 'Increasing':
        return '🔥';
      default:
        return '⚖️';
    }
  }
}
