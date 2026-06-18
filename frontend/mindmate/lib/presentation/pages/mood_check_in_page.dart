import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_nav.dart';
import 'daily_diary_page.dart';

class MoodCheckInPage extends StatefulWidget {
  const MoodCheckInPage({super.key});

  @override
  State<MoodCheckInPage> createState() => _MoodCheckInPageState();
}

class _MoodCheckInPageState extends State<MoodCheckInPage> {
  String? _selectedMood = 'GOOD'; // Pre-selected in the image

  final List<Map<String, dynamic>> _moods = [
    {
      'emoji': '⚡️',
      'title': 'GREAT',
      'description': 'UNSTOPPABLE ENERGY',
    },
    {
      'emoji': '✨',
      'title': 'GOOD',
      'description': 'POSITIVE VIBES',
    },
    {
      'emoji': '😐',
      'title': 'OKAY',
      'description': 'MAINTAINING LEVEL',
    },
    {
      'emoji': '☁️',
      'title': 'LOW',
      'description': 'FEELING DRAINED',
    },
    {
      'emoji': '🚨',
      'title': 'STRUGGLING',
      'description': 'NEED SUPPORT',
    },
  ];

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
                    "HOW ARE YOU\nDOING?",
                    style: GoogleFonts.anton(
                      fontSize: 48,
                      color: Colors.black,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  ..._moods.map((mood) => _buildMoodCard(
                        emoji: mood['emoji'],
                        title: mood['title'],
                        description: mood['description'],
                        isSelected: _selectedMood == mood['title'],
                        onTap: () => setState(() => _selectedMood = mood['title']),
                      )),
                ],
              ),
            ),            
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "WHAT'S GOING ON?",
                    style: GoogleFonts.anton(
                      fontSize: 30,
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

  Widget _buildMoodCard({
    required String emoji,
    required String title,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD600) : Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 16),
                Text(
                  title,
                  style: GoogleFonts.anton(
                    fontSize: 24,
                    color: Colors.black,
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
            Text(
              description,
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.black87 : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
