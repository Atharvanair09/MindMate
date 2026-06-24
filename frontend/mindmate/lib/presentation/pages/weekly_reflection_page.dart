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
                    _buildInfluentialFactorsSection(),
                    const SizedBox(height: 20),
                    _buildIndicatorsSection(),
                    const SizedBox(height: 20),
                    _buildPatternsSection(),
                    const SizedBox(height: 20),
                    _buildRecommendationSection(),
                    const SizedBox(height: 20),
                    _buildDebugSection(),
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
              'Avg Mood', '${r.averageMoodScore.isNaN ? "0.0" : r.averageMoodScore.toStringAsFixed(1)} / 5.0'),
          _buildKvRow(
              'Avg Burnout', '${r.averageBurnoutScore.isNaN ? "0" : r.averageBurnoutScore.toStringAsFixed(0)} / 100'),
          _buildKvRow('Confidence', '${r.confidence.isNaN ? "0" : r.confidence.toStringAsFixed(0)}%'),
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

  // ── Influential Factors ───────────────────────────────────────────────────

  Widget _buildInfluentialFactorsSection() {
    final r = _reflection!;
    return _buildCard(
      header: 'MOST INFLUENTIAL FACTORS',
      headerTextColor: Colors.black,
      headerBgColor: const Color(0xFFFFD600),
      cardBgColor: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Positive:\n${_getFriendlyFactorName(r.mostPositiveInfluence)}',
            style: GoogleFonts.spaceMono(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF00C853),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            r.positiveInfluenceReason,
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              color: const Color(0xFFFFD600),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Negative:\n${_getFriendlyFactorName(r.mostNegativeInfluence)}',
            style: GoogleFonts.spaceMono(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            r.negativeInfluenceReason,
            style: GoogleFonts.spaceMono(
              fontSize: 14,
              color: const Color(0xFFFFD600),
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

  // ── Debug Page ────────────────────────────────────────────────────────────

  Widget _buildDebugSection() {
    final sum = _reflection!.baseConfidence +
        _reflection!.daysContribution +
        _reflection!.moodContribution +
        _reflection!.journalContribution +
        _reflection!.chatContribution +
        _reflection!.burnoutContribution +
        _reflection!.followUpContribution;
    final mismatch = (sum - _reflection!.rawConfidence).abs() > 0.1;

    return _buildCard(
      header: 'DEBUG PAGE',
      headerTextColor: const Color(0xFFFFD600),
      headerBgColor: Colors.black,
      cardBgColor: const Color(0xFFFFD600),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKvRow('History Sufficiency', _reflection!.historySufficiency),
          const SizedBox(height: 12),
          Text(
            'CONFIDENCE BREAKDOWN',
            style: GoogleFonts.anton(
              fontSize: 18,
              color: Colors.black,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          if (mismatch)
            Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.only(bottom: 8),
              color: Colors.redAccent.withOpacity(0.2),
              child: Text(
                '⚠️ Confidence breakdown mismatch detected.',
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          _buildKvRow('Base Confidence', '${_formatPercent(_reflection!.baseConfidence)}'),
          _buildKvRow('Days Contribution', '${_formatPercent(_reflection!.daysContribution)}'),
          _buildKvRow('Mood Contribution', '${_formatPercent(_reflection!.moodContribution)}'),
          _buildKvRow('Journal Contribution', '${_formatPercent(_reflection!.journalContribution)}'),
          _buildKvRow('Chat Contribution', '${_formatPercent(_reflection!.chatContribution)}'),
          _buildKvRow('Burnout Contribution', '${_formatPercent(_reflection!.burnoutContribution)}'),
          _buildKvRow('Follow-Up Contribution', '${_formatPercent(_reflection!.followUpContribution)}'),
          const Divider(color: Colors.black, thickness: 1),
          _buildKvRow('Raw Confidence', '${_formatPercent(_reflection!.rawConfidence)}'),
          _buildKvRow('Confidence Cap', '${_formatPercent(_reflection!.confidenceCap)}'),
          _buildKvRow('Final Confidence', '${_formatPercent(_reflection!.confidence)}'),
          const SizedBox(height: 16),
          Text(
            'INFLUENCE SCORES',
            style: GoogleFonts.anton(
              fontSize: 18,
              color: Colors.black,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 8),
          if (_reflection!.influenceScores.isNotEmpty)
            ..._reflection!.influenceScores.map((score) {
              final parts = score.split(':');
              return _buildKvRow(parts[0].trim(), parts.length > 1 ? parts[1].trim() : '');
            }),
          if (_reflection!.influenceScores.isEmpty)
            _buildEmptyNote('No influence scores calculated.'),
          const SizedBox(height: 16),
          _buildKvRow(
            'Top Positive Factor',
            _reflection!.topPositiveScore > 0 
                ? '${_reflection!.mostPositiveInfluence} (${_reflection!.topPositiveScore.toStringAsFixed(1)})' 
                : _reflection!.mostPositiveInfluence,
          ),
          _buildKvRow('Reason Selected', _reflection!.positiveInfluenceReason),
          const SizedBox(height: 8),
          _buildKvRow(
            'Top Negative Factor',
            _reflection!.topNegativeScore > 0 
                ? '${_reflection!.mostNegativeInfluence} (${_reflection!.topNegativeScore.toStringAsFixed(1)})' 
                : _reflection!.mostNegativeInfluence,
          ),
          _buildKvRow('Reason Selected', _reflection!.negativeInfluenceReason),
        ],
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

  String _getFriendlyFactorName(String internalName) {
    switch (internalName) {
      case 'Resolved Mood Conflicts':
        return 'Social Recovery';
      case 'Negative Chats':
        return 'Stressful Conversations';
      case 'Negative Journals':
        return 'Emotional Strain';
      case 'Repeated LOW Mood':
        return 'Persistent Low Mood';
      case 'Burnout Spikes':
        return 'Periods of Increased Stress';
      case 'Sleep Disruption':
        return 'Sleep Challenges';
      case 'Academic Stress':
        return 'Academic Pressure';
      case 'Work Stress':
        return 'Workload Pressure';
      case 'Academic/Work Stress':
        return 'Academic / Workload Pressure';
      case 'Positive Journals':
        return 'Positive Reflection';
      case 'Positive Chats':
        return 'Supportive Interactions';
      default:
        return internalName;
    }
  }

  String _formatPercent(double? value) {
    if (value == null || value.isNaN) return '0';
    return value.toStringAsFixed(0);
  }

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
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: GoogleFonts.spaceMono(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
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
    if (trend.contains('Improving')) {
      return const Color(0xFF00C853);
    } else if (trend.contains('Declining')) {
      return Colors.redAccent;
    }
    return const Color(0xFFFFD600);
  }

  String _moodTrendIcon(String trend) {
    if (trend.contains('Improving')) {
      return '📈';
    } else if (trend.contains('Declining')) {
      return '📉';
    } else if (trend == 'Insufficient Data') {
      return '❓';
    }
    return '➡️';
  }

  Color _burnoutTrendColor(String trend) {
    if (trend.contains('Improving')) {
      return const Color(0xFF00C853);
    } else if (trend.contains('Increasing')) {
      return Colors.redAccent;
    }
    return const Color(0xFFFFD600);
  }

  String _burnoutTrendIcon(String trend) {
    if (trend.contains('Improving')) {
      return '✅';
    } else if (trend.contains('Increasing')) {
      return '🔥';
    } else if (trend == 'Insufficient Data') {
      return '❓';
    }
    return '⚖️';
  }
}
