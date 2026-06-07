import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import '../widgets/bottom_nav.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: const NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=John'),
          ),
        ),
        title: Text(
          "Your Insights",
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B39EF),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: AppColors.darkText),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTimeFilter(),
            const SizedBox(height: 24),
            _buildSummaryCards(),
            const SizedBox(height: 32),
            _buildWeeklyTrend(),
            const SizedBox(height: 32),
            _buildInsightMessage(),
            const SizedBox(height: 32),
            _buildTopStressors(),
            const SizedBox(height: 32),
            _buildMonthlyHeatmap(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 3),
    );
  }

  Widget _buildTimeFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F1FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "This Month",
            style: GoogleFonts.poppins(
              color: AppColors.primaryPurple,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: AppColors.primaryPurple),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _summaryItem("😐", "Avg Mood", "3.2/5"),
        _summaryItem("☀️", "Best Day", "Thu"),
        _summaryItem("🔥", "Streak", "5 days"),
      ],
    );
  }

  Widget _summaryItem(String icon, String label, String value) {
    return Container(
      width: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12, color: AppColors.lightText),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4B39EF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyTrend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Weekly Trend",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            Text(
              "Last 7 Days",
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.lightText),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 180,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: FlTitlesData(
                show: true,
                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: const TextStyle(color: Colors.grey, fontSize: 10),
                    ),
                    reservedSize: 22,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                      if (value >= 0 && value < 7) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(days[value.toInt()], style: const TextStyle(fontSize: 10)),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                     FlSpot(0, 2),
                     FlSpot(1, 2.5),
                     FlSpot(2, 3.8),
                     FlSpot(3, 3),
                     FlSpot(4, 2.2),
                     FlSpot(5, 1.8),
                     FlSpot(6, 1.7),
                  ],
                  isCurved: true,
                  color: AppColors.primaryPurple,
                  barWidth: 3,
                  dotData: FlDotData(
                    show: true,
                    getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                      color: AppColors.primaryPurple,
                      radius: index == 2 || index == 3 ? 3 : 0,
                    ),
                  ),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryPurple.withOpacity(0.2),
                        AppColors.primaryPurple.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInsightMessage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F4FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              "\"You tend to feel better mid-week. Sunday evenings show a dip — possibly pre-week anxiety. Try a 5-min breathing exercise Sunday nights.\"",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
                color: const Color(0xFF4A4A4A),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopStressors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Top Stressors This Week",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _stressorChip("Exams x4", const Color(0xFFEBF5FF), Colors.blue),
            const SizedBox(width: 12),
            _stressorChip("Sleep x3", const Color(0xFFFFF4E7), Colors.orange),
            const SizedBox(width: 12),
            _stressorChip("Placements x2", const Color(0xFFE9F7EF), Colors.green),
          ],
        ),
      ],
    );
  }

  Widget _stressorChip(String label, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: text.withOpacity(0.1)),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: text,
        ),
      ),
    );
  }

  Widget _buildMonthlyHeatmap() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Monthly Heatmap",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText,
              ),
            ),
            Row(
              children: [
                _heatmapLegend(const Color(0xFF00D6A0)),
                _heatmapLegend(const Color(0xFFFFD166)),
                _heatmapLegend(const Color(0xFFEF476F)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
               _buildHeatmapHeader(),
               const SizedBox(height: 12),
               _buildHeatmapGrid(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _heatmapLegend(Color color) {
    return Container(
      width: 12,
      height: 12,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildHeatmapHeader() {
    const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((d) => SizedBox(
        width: 30,
        child: Center(child: Text(d, style: const TextStyle(fontSize: 10, color: Colors.grey))),
      )).toList(),
    );
  }

  Widget _buildHeatmapGrid() {
    final List<Color?> grid = [
      null, null, const Color(0xFF00D6A0), const Color(0xFFFFD166), const Color(0xFF00D6A0), const Color(0xFFFFD166), const Color(0xFFEF476F),
      const Color(0xFFFFD166), const Color(0xFF00D6A0), const Color(0xFF00D6A0), const Color(0xFF00D6A0), const Color(0xFFFFD166), null, const Color(0xFFEF476F),
      const Color(0xFFFFD166), const Color(0xFFFFD166), const Color(0xFF00D6A0), const Color(0xFF00D6A0), const Color(0xFF00D6A0), const Color(0xFF00D6A0), const Color(0xFFFFD166),
      const Color(0xFF00D6A0), const Color(0xFFFFD166), const Color(0xFF00D6A0), const Color(0xFF00D6A0), null, null, null,
      null, null, null, null, null, null, null,
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: grid.map((color) => Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color ?? const Color(0xFFF3F3F5),
          borderRadius: BorderRadius.circular(8),
        ),
      )).toList(),
    );
  }
}
