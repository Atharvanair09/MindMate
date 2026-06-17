import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/state/user_provider.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Hardcoded for UI demo
  int _selectedMoodIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 24),
              _buildBurnoutCard(),
              const SizedBox(height: 24),
              _buildSectionTitle("HOW ARE YOU FEELING?"),
              const SizedBox(height: 12),
              _buildMoodSelector(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildWeeklyChart(),
              const SizedBox(height: 24),
              _buildSectionTitle("STUDENT RESOURCES"),
              const SizedBox(height: 12),
              _buildResourceCard(),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 0),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final userName = userProvider.userName.isNotEmpty 
                ? userProvider.userName 
                : "Friend";
            return Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: ClipRect(
                    child: _buildAvatarImage(userProvider),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  userName.toUpperCase(),
                  style: GoogleFonts.vt323(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.8,
                  ),
                ),
              ],
            );
          },
        ),
        const Icon(Icons.notifications_none, color: Colors.black, size: 28),
      ],
    );
  }

  Widget _buildAvatarImage(UserProvider userState) {
    if (userState.localAvatarPath != null) {
      return Image.file(
        File(userState.localAvatarPath!),
        width: 32,
        height: 32,
        fit: BoxFit.cover,
      );
    }
    
    final imageUrl = userState.avatarImageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(userState),
        );
      } else {
        final bytes = userState.avatarImageBytes;
        if (bytes != null) {
          return Image.memory(
            bytes,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(userState),
          );
        }
      }
    }

    return _buildDefaultIcon(userState);
  }

  Widget _buildDefaultIcon(UserProvider userState) {
    if (userState.avatarLabel.startsWith('CyberAvatar')) {
      final index = userState.avatarLabel.replaceAll('CyberAvatar', '');
      return Image.asset(
        'assets/avatars/avatar_$index.png',
        width: 32,
        height: 32,
        fit: BoxFit.cover,
      );
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: userState.avatarGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          userState.avatarIcon,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.vt323(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        letterSpacing: 3,
      ),
    );
  }

  Widget _buildBurnoutCard() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "BURNOUT RISK",
                style: GoogleFonts.vt323(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "LOW",
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.greenAccent,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                "72",
                style: GoogleFonts.spaceMono(
                  fontSize: 56,
                  fontWeight: FontWeight.w400,
                  color: Colors.yellow,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                width: 6,
                height: 60,
                color: Colors.yellow,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMoodSelector() {
    final moods = [
      {"emoji": "🤩", "label": "GREAT"},
      {"emoji": "😊", "label": "GOOD"},
      {"emoji": "😐", "label": "OKAY"},
      {"emoji": "😔", "label": "LOW"},
      {"emoji": "😵", "label": "G.O"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(moods.length, (index) {
        final isSelected = _selectedMoodIndex == index;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMoodIndex = index;
            });
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 40 - 48) / 5, // Auto-size based on screen width
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.yellow : Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: isSelected ? const Offset(4, 4) : const Offset(3, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  moods[index]["emoji"]!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  moods[index]["label"]!,
                  style: GoogleFonts.vt323(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ));
      }),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.yellow,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "CHAT",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "talk to someone →",
                  style: GoogleFonts.vt323(
                    fontSize: 18,
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
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "JOURNAL",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.yellow,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "private. on-device →",
                  style: GoogleFonts.vt323(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
            ),
            child: Text(
              "THIS WEEK",
              style: GoogleFonts.vt323(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                // Grid lines
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (index) => Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                // Bars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(0.4, false),
                      _buildBar(0.7, false),
                      _buildBar(0.2, false),
                      _buildBar(0.5, false),
                      _buildBar(0.8, true), // Friday highlighted
                      _buildBar(0.4, false),
                      _buildBar(0.5, false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"].map((day) {
              return Text(
                day,
                style: GoogleFonts.vt323(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double fillPct, bool isHighlighted) {
    return Container(
      width: 24,
      height: 120 * fillPct,
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.yellow : Colors.black,
        border: isHighlighted ? Border.all(color: Colors.black, width: 1) : null,
      ),
    );
  }

  Widget _buildResourceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: const BoxDecoration(
              color: Color(0xFFE0E0E0),
              border: Border(right: BorderSide(color: Colors.black, width: 2)),
            ),
            child: const Icon(Icons.menu_book, color: Colors.black, size: 32),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "EXAM ANXIETY GUIDE",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "5 MIN READ •\nSURVIVAL TIPS",
                    style: GoogleFonts.vt323(
                      fontSize: 14,
                      color: Colors.grey[600],
                      letterSpacing: 1.5,
                      height: 1.5,
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
}
