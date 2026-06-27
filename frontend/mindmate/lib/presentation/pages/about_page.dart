import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/global_background.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
        title: Text(
          'ABOUT MINDMATE',
          style: GoogleFonts.anton(
            fontSize: 26,
            color: Colors.black,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: GlobalBackgroundLayer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNeoCard(
                title: 'WHAT IS MINDMATE?',
                description: 'MindMate is a decentralized, privacy-first mental health companion. It utilizes localized machine learning models to detect mood changes, track burnout forecast, and recommend wellness plans without compromising your real-world identity.',
                color: Colors.purple,
                icon: Icons.psychology,
              ),
              const SizedBox(height: 16),
              _buildNeoCard(
                title: 'OUR CORE MISSION',
                description: 'To democratize mental wellness tracking while guaranteeing absolute privacy. By employing advanced on-device edge AI and client-side encryption, we make sure that your thoughts remain strictly yours.',
                color: Colors.pink,
                icon: Icons.favorite,
              ),
              const SizedBox(height: 16),
              _buildNeoCard(
                title: 'SYSTEM SPECIFICATIONS',
                description: 'Client Version: v1.0.4\nProtocol: v5.3-Alpha\nLocal Storage: Isar Local DB\nBuild Stamp: 2026.06.27',
                color: Colors.amber,
                icon: Icons.settings_suggest_outlined,
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNeoCard({
    required String title,
    required String description,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
            blurRadius: 0,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.anton(
                    fontSize: 18,
                    color: Colors.black,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
