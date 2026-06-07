import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';
import '../widgets/mood_check_in_widgets.dart';
import '../widgets/bottom_nav.dart';

class MoodCheckInPage extends StatefulWidget {
  const MoodCheckInPage({super.key});

  @override
  State<MoodCheckInPage> createState() => _MoodCheckInPageState();
}

class _MoodCheckInPageState extends State<MoodCheckInPage> {
  String? _selectedMood;

  final List<Map<String, dynamic>> _moods = [
    {
      'emoji': '🤩',
      'title': 'Great',
      'description': 'Everything feels amazing',
      'bg': AppColors.greatBg,
      'text': AppColors.greatText,
    },
    {
      'emoji': '😊',
      'title': 'Good',
      'description': 'Everything feels manageable',
      'bg': AppColors.goodBg,
      'text': AppColors.goodText,
    },
    {
      'emoji': '😐',
      'title': 'Okay',
      'description': 'Getting by, one step at a time',
      'bg': AppColors.okayBg,
      'text': AppColors.okayText,
    },
    {
      'emoji': '😔',
      'title': 'Low',
      'description': 'Feeling a bit down',
      'bg': AppColors.lowBg,
      'text': AppColors.lowText,
    },
    {
      'emoji': '😫',
      'title': 'Struggling',
      'description': "It's a tough day",
      'bg': AppColors.strugglingBg,
      'text': AppColors.strugglingText,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B39EF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Mood Check-in",
          style: GoogleFonts.poppins(
            color: const Color(0xFF4B39EF),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 18,
              backgroundImage: const NetworkImage('https://api.dicebear.com/7.x/avataaars/png?seed=Mimi'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const StreakCard(),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Text(
                    "How are you feeling\ntoday?",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1E1E1E),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Take a moment to check in with yourself.",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.lightText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ..._moods.map((mood) => SelectableMoodCard(
                  emoji: mood['emoji'],
                  title: mood['title'],
                  description: mood['description'],
                  bgColor: mood['bg'],
                  textColor: mood['text'],
                  isSelected: _selectedMood == mood['title'],
                  onTap: () => setState(() => _selectedMood = mood['title']),
                )),
            const SizedBox(height: 24),
            Text(
              "What's the reason?",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintText: "Exams, sleep, friends...",
                hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
                filled: true,
                fillColor: const Color(0xFFF6F5FF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: AppColors.logMoodGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {},
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
                    Text(
                      "Log Mood",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 2),
    );
  }
}
