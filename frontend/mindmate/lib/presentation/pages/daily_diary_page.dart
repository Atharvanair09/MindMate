import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../core/constants/colors.dart';

class LinedPaperPainter extends CustomPainter {
  final double lineHeight;
  final Color lineColor;

  LinedPaperPainter({required this.lineHeight, required this.lineColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.0;

    // Draw lines starting from the first line height
    for (double i = lineHeight; i < size.height; i += lineHeight) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DailyDiaryPage extends StatefulWidget {
  const DailyDiaryPage({super.key});

  @override
  State<DailyDiaryPage> createState() => _DailyDiaryPageState();
}

class _DailyDiaryPageState extends State<DailyDiaryPage> {
  final TextEditingController _diaryController = TextEditingController();
  int _wordCount = 0;

  @override
  void initState() {
    super.initState();
    _diaryController.addListener(() {
      final text = _diaryController.text.trim();
      setState(() {
        _wordCount = text.isEmpty ? 0 : text.split(RegExp(r'\s+')).length;
      });
    });
  }

  @override
  void dispose() {
    _diaryController.dispose();
    super.dispose();
  }

  String _getFormattedDate() {
    final now = DateTime.now();
    final month = DateFormat('MMMM').format(now);
    final day = now.day;
    String suffix = 'th';
    if (day % 10 == 1 && day != 11) suffix = 'st';
    else if (day % 10 == 2 && day != 12) suffix = 'nd';
    else if (day % 10 == 3 && day != 13) suffix = 'rd';
    return "Today, $month $day$suffix";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF9FF), // Very light purple/grey tint
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B39EF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Daily Diary",
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B39EF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getFormattedDate(),
              style: GoogleFonts.poppins(
                fontSize: 26,
                color: Colors.black,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 16),
            
            // Diary Entry Card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Text Area
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Stack(
                      children: [
                        // Faint lines background using CustomPaint
                        Positioned.fill(
                          child: CustomPaint(
                            painter: LinedPaperPainter(
                              lineHeight: 16 * 1.8, // Match font size * height
                              lineColor: const Color(0xFFE5E0FF), // Faint purple line
                            ),
                          ),
                        ),
                        TextField(
                          controller: _diaryController,
                          maxLines: 12,
                          minLines: 10,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: const Color(0xFF1E1E1E),
                            height: 1.8, // Line height
                          ),
                          decoration: InputDecoration(
                            hintText: "How are you really doing? Write it out...",
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey.shade400,
                              fontSize: 16,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero, // Important to align text with lines
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Bottom Actions of the Card
                  Padding(
                    padding: const EdgeInsets.only(left: 16, right: 20, bottom: 16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.image_outlined),
                          color: const Color(0xFF4B39EF),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.mic_none_outlined),
                          color: const Color(0xFF4B39EF),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined),
                          color: const Color(0xFF4B39EF),
                          onPressed: () {},
                        ),
                        const Spacer(),
                        Text(
                          "$_wordCount words",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Safe Space Quote Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EDFF),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Small icon instead of network image to avoid 404s
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E0FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.spa_rounded,
                      color: Color(0xFF4B39EF),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      '"This is your safe space. There are no wrong words here."',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: const Color(0xFF4B39EF),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Save Button
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFF7042C1), // A pleasant purple
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7042C1).withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  // Save logic
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.save_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      "Save to my diary",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
