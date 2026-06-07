import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class WeeklyChart extends StatelessWidget {
  const WeeklyChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Week at a Glance",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkText,
          ),
        ),
        AspectRatio(
          aspectRatio: 1.7,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
            children: [
              BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 10,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          final day = days[value.toInt()];
                          final isToday = value.toInt() == 3;
                          return Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              day,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                                color: isToday ? AppColors.primaryPurple : AppColors.lightText,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _makeGroupData(0, 5, false),
                    _makeGroupData(1, 4, false),
                    _makeGroupData(2, 6, false),
                    _makeGroupData(3, 9, true),
                    _makeGroupData(4, 7, false),
                    _makeGroupData(5, 5, false),
                    _makeGroupData(6, 6, false),
                  ],
                ),
              ),
              LineChart(
                LineChartData(
                  minX: 0,
                  maxX: 6,
                  minY: 0,
                  maxY: 10,
                  lineTouchData: const LineTouchData(enabled: false),
                  gridData: const FlGridData(show: false),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 5.5),
                        FlSpot(1, 4.5),
                        FlSpot(2, 6.5),
                        FlSpot(3, 9.5),
                        FlSpot(4, 7.5),
                        FlSpot(5, 5.5),
                        FlSpot(6, 6.5),
                      ],
                      isCurved: true,
                      color: AppColors.primaryPurple,
                      barWidth: 3,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      ],
    );
  }

  BarChartGroupData _makeGroupData(int x, double y, bool isSelected) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: isSelected ? AppColors.primaryPurple : AppColors.primaryPurple.withOpacity(0.2),
          width: 25,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12), bottom: Radius.circular(12)),
        ),
      ],
    );
  }
}
