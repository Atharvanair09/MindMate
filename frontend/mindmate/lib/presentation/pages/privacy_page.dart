import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/global_background.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

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
          'PRIVACY PROTOCOL',
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
                title: 'ON-DEVICE ONLY',
                description: 'All your journals, mood logs, and chat histories are processed and stored locally on your device. MindMate does not upload your personal logs to any remote server.',
                color: Colors.green,
                icon: Icons.phonelink_lock,
              ),
              const SizedBox(height: 16),
              _buildNeoCard(
                title: 'RSA-4096 ENCRYPTION',
                description: 'Your memory vault and stored entries are secured with military-grade RSA-4096 encryption. Decryption keys never leave your physical device.',
                color: Colors.cyan,
                icon: Icons.security,
              ),
              const SizedBox(height: 16),
              _buildNeoCard(
                title: 'PSEUDONYMIZATION',
                description: 'Any analytical queries or feature extraction models run locally. Identification metadata is completely stripped and replaced with temporary debug units.',
                color: Colors.yellow,
                icon: Icons.vpn_lock,
              ),
              const SizedBox(height: 16),
              _buildNeoCard(
                title: 'ZERO-KNOWLEDGE ARCHITECTURE',
                description: 'MindMate cannot read, sell, or analyze your journals. You own your data, your encryption keys, and your healing journey.',
                color: Colors.orange,
                icon: Icons.remove_red_eye_outlined,
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
