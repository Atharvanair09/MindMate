import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/state/user_provider.dart';
import '../../data/repositories/auth_repository.dart';
import '../widgets/bottom_nav.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F0E9), // Beige
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F0E9),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(3.0),
          child: Container(
            color: Colors.black,
            height: 3.0,
          ),
        ),
        title: Row(
          children: [
            Text(
              'MINDMATE',
              style: GoogleFonts.spaceMono(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildCoreIdentityCard(context),
            const SizedBox(height: 24),
            Text(
              'SYSTEM SETTINGS',
              style: GoogleFonts.spaceMono(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            _buildSettingsList(context),
            const SizedBox(height: 24),
            _buildStatsRow(),
            const SizedBox(height: 32),
            _buildLogoutButton(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 24,
            width: double.infinity,
            color: const Color(0xFFB81D13), // Red footer
            alignment: Alignment.center,
            child: Text(
              'EMERGENCY HOTLINE: 988 // ALWAYS AVAILABLE',
              style: GoogleFonts.spaceMono(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const MindMateBottomNav(currentIndex: 4),
        ],
      ),
    );
  }

  Widget _buildCoreIdentityCard(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, user, _) {
        // Determine avatar
        Widget avatarChild;
        if (user.localAvatarPath != null) {
          avatarChild = Image.file(
            File(user.localAvatarPath!),
            fit: BoxFit.cover,
          );
        } else if (user.avatarImageBytes != null) {
          avatarChild = Image.memory(
            user.avatarImageBytes!,
            fit: BoxFit.cover,
          );
        } else if (user.avatarLabel.startsWith('CyberAvatar')) {
          final index = user.avatarLabel.replaceAll('CyberAvatar', '');
          avatarChild = Image.asset(
            'assets/avatars/avatar_$index.png',
            fit: BoxFit.cover,
          );
        } else {
          avatarChild = Center(
            child: Icon(
              user.avatarIcon,
              size: 40,
              color: Colors.white,
            ),
          );
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.black,
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
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'CORE IDENTITY // UNIT 042',
                    style: GoogleFonts.spaceMono(
                      color: const Color(0xFFFDEB00),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.qr_code_2, color: Colors.white, size: 20),
                ],
              ),
              const SizedBox(height: 24),
              // Avatar
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile-setup'),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: avatarChild,
                ),
              ),
              const SizedBox(height: 16),
              // Username
              Stack(
                children: [
                  Text(
                    user.userName.isNotEmpty ? user.userName.toUpperCase() : 'UNKNOWN',
                    style: GoogleFonts.spaceMono(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF00E5FF),
                    ),
                  ),
                  Positioned(
                    left: 2,
                    top: 2,
                    child: Text(
                      user.userName.isNotEmpty ? user.userName.toUpperCase() : 'UNKNOWN',
                      style: GoogleFonts.spaceMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFFF003C),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 1,
                    top: 1,
                    child: Text(
                      user.userName.isNotEmpty ? user.userName.toUpperCase() : 'UNKNOWN',
                      style: GoogleFonts.spaceMono(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Enrolled
              Text(
                'ENROLLED: SEPT 2024',
                style: GoogleFonts.spaceMono(
                  color: const Color(0xFFFDEB00),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SECURITY CLEARANCE',
                        style: GoogleFonts.spaceMono(
                          color: Colors.white54,
                          fontSize: 8,
                        ),
                      ),
                      Text(
                        'LEVEL 03 - VETERAN',
                        style: GoogleFonts.spaceMono(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    color: const Color(0xFFFDEB00),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: Text(
                      'VERIFIED',
                      style: GoogleFonts.spaceMono(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingsList(BuildContext context) {
    return Column(
      children: [
        _buildSettingsTile(
          title: 'PRIVACY (ON-DEVICE ONLY)',
          subtitle: 'Encryption protocol: RSA-4096',
          icon: Icons.lock_outline,
        ),
        const SizedBox(height: 8),
        _buildSettingsTile(
          title: 'DATA EXPORT (RAW)',
          subtitle: 'Format: .JSON / .CSV',
          icon: Icons.storage_rounded,
        ),
        const SizedBox(height: 8),
        _buildSettingsTile(
          title: 'RESET IDENTITY',
          subtitle: 'Warning: IRREVERSIBLE ACTION',
          icon: Icons.delete_outline,
          isDestructive: true,
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required String title,
    required String subtitle,
    required IconData icon,
    bool isDestructive = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.spaceMono(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: isDestructive ? const Color(0xFFB81D13) : Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          Icon(
            icon,
            color: isDestructive ? const Color(0xFFB81D13) : Colors.black,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Consumer<UserProvider>(
      builder: (context, user, _) {
        return Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
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
                    Text(
                      'FOCUS TIME',
                      style: GoogleFonts.spaceMono(
                        fontSize: 8,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '142h',
                      style: GoogleFonts.spaceMono(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
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
                decoration: BoxDecoration(
                  color: const Color(0xFFFDEB00),
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
                    Text(
                      'MOOD SCORE',
                      style: GoogleFonts.spaceMono(
                        fontSize: 8,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      (user.wellnessScore / 10).toStringAsFixed(1),
                      style: GoogleFonts.spaceMono(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _confirmLogout(context),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: const Color(0xFFB81D13),
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'LOGOUT',
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(Icons.exit_to_app, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  /// Shows a confirmation dialog, then clears credentials and navigates to login.
  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        backgroundColor: const Color(0xFFF2F0E9),
        title: Text(
          'LOG OUT?',
          style: GoogleFonts.spaceMono(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        content: Text(
          'You\'ll need your recovery phrase to log back in. Make sure you have it saved.',
          style: GoogleFonts.spaceMono(
            fontSize: 13,
            color: Colors.black87,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'CANCEL',
              style: GoogleFonts.spaceMono(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'LOG OUT',
              style: GoogleFonts.spaceMono(
                color: const Color(0xFFB81D13),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await AuthRepository().logout();
      if (context.mounted) {
        context.read<UserProvider>().reset();
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }
}
