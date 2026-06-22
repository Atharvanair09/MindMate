import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ActivityHeatmap extends StatelessWidget {
  final Map<DateTime, int> data;
  final DateTime startDate;
  final DateTime endDate;

  const ActivityHeatmap({
    super.key,
    required this.data,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate total weeks between startDate and endDate
    final int totalDays = endDate.difference(startDate).inDays + 1;
    final int offset = startDate.weekday % 7; // Sunday = 0
    final int totalWeeks = ((totalDays + offset) / 7).ceil();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildMonthsHeader(totalWeeks),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(totalWeeks, (weekIndex) {
              return Padding(
                padding: const EdgeInsets.only(right: 2.0),
                child: Column(
                  children: List.generate(7, (dayIndex) {
                    final int dayOffset = weekIndex * 7 + dayIndex - offset;
                    if (dayOffset < 0 || dayOffset >= totalDays) {
                      return const SizedBox(width: 14, height: 14);
                    }
                    
                    final DateTime currentDate = startDate.add(Duration(days: dayOffset));
                    final int level = data[_normalizeDate(currentDate)] ?? 0;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: _buildSquare(level),
                    );
                  }),
                ),
              );
            }),
          ),
        ),
        const SizedBox(height: 16),
        _buildLegend(),
      ],
    );
  }

  Widget _buildMonthsHeader(int totalWeeks) {
    // Generate simplified month labels based on the weeks
    // This is a basic implementation, it could be improved to perfectly align with weeks
    List<Widget> monthLabels = [];
    DateTime currentDate = startDate;
    int currentMonth = -1;

    for (int i = 0; i < totalWeeks; i++) {
      if (currentDate.month != currentMonth) {
        monthLabels.add(
          SizedBox(
            width: 14.0 * 4 + 6.0, // Approximate width of 4 weeks
            child: Text(
              DateFormat('MMM').format(currentDate).toUpperCase(),
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        );
        currentMonth = currentDate.month;
      }
      currentDate = currentDate.add(const Duration(days: 7));
    }

    return Row(children: monthLabels);
  }

  Widget _buildSquare(int level) {
    Color fillColor;
    Color borderColor = Colors.black;

    switch (level) {
      case 1:
        fillColor = const Color(0xFF00BFFF); // Light Blue
        break;
      case 2:
        fillColor = const Color(0xFFFDEB00); // Yellow
        break;
      case 3:
        fillColor = Colors.black; // Black
        borderColor = const Color(0xFFFDEB00); // Yellow border for black
        break;
      case 0:
      default:
        fillColor = const Color(0xFFE5E2D9); // Empty beige
        break;
    }

    return Container(
      width: 14,
      height: 14,
      decoration: BoxDecoration(
        color: fillColor,
        border: Border.all(color: borderColor, width: 1.5),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      children: [
        Text(
          'LESS',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 8),
        _buildSquare(0),
        const SizedBox(width: 4),
        _buildSquare(1),
        const SizedBox(width: 4),
        _buildSquare(2),
        const SizedBox(width: 4),
        _buildSquare(3),
        const SizedBox(width: 8),
        Text(
          'MORE',
          style: GoogleFonts.spaceMono(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }
}
