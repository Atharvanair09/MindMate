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
      backgroundColor: const Color(0xFFFBFAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF4B39EF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4B39EF),
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Color(0xFF4B39EF)),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildStatsRow(),
            const SizedBox(height: 30),
            _buildSettingsList(),
            const SizedBox(height: 40),
            _buildFooter(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 4),
    );
  }

  Widget _buildProfileHeader() {
    return Consumer<UserProvider>(
      builder: (context, user, _) {
        // Determine which avatar widget to show
        Widget avatarChild;
        if (user.localAvatarPath != null) {
          // Freshly picked this session — use file
          avatarChild = Image.file(
            File(user.localAvatarPath!),
            fit: BoxFit.cover,
            width: 140,
            height: 140,
          );
        } else if (user.avatarImageBytes != null) {
          // Restored from MongoDB (base64 data URL)
          avatarChild = Image.memory(
            user.avatarImageBytes!,
            fit: BoxFit.cover,
            width: 140,
            height: 140,
          );
        } else {
          // Default icon avatar
          avatarChild = Center(
            child: Icon(
              user.avatarIcon,
              size: 64,
              color: Colors.white,
            ),
          );
        }

        return Column(
          children: [
            // Avatar circle — tappable to change avatar
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/profile-setup'),
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: user.hasCustomAvatar
                          ? null
                          : LinearGradient(
                              colors: user.avatarGradient,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                      boxShadow: [
                        BoxShadow(
                          color: user.avatarGradient.first.withOpacity(0.4),
                          blurRadius: 28,
                          spreadRadius: 2,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipOval(child: avatarChild),
                  ),
                  // Camera badge signals the avatar is editable
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7B61FF), Color(0xFF9B84FF)],
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B61FF).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.edit_rounded,
                        size: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Username — immutable, no edit button
            Text(
              user.userName.isNotEmpty ? user.userName : '—',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E1E1E),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'This is you. Only you know it\'s you.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 12),
            // Level badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEEEBFF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    size: 16,
                    color: Color(0xFF7B61FF),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Level 5 — Inner Peace Seeker',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF7B61FF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStatCard('12', 'Total\nChats', const Color(0xFF4B39EF)),
          _buildStatCard('15', 'Day\nStreak', const Color(0xFF7B61FF)),
          _buildStatCard('4', 'Exercises\nDone', const Color(0xFFE54335)),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color color) {
    return Container(
      width: 105,
      height: 115,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF757575),
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildSettingsTile(
            icon: Icons.face_retouching_natural_rounded,
            title: 'Change Avatar',
            onTap: (context) =>
                Navigator.pushNamed(context, '/profile-setup'),
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            icon: Icons.notifications_none_rounded,
            title: 'Daily Reminders',
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy & Security',
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            icon: Icons.file_download_outlined,
            title: 'Data & Exports',
          ),
          const SizedBox(height: 16),
          _buildSettingsTile(
            icon: Icons.info_outline_rounded,
            title: 'About MindMate',
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    void Function(BuildContext)? onTap,
  }) {
    return Builder(builder: (context) {
      return GestureDetector(
        onTap: onTap != null ? () => onTap(context) : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F1FF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF7B61FF),
                  size: 24,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1E1E1E),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFBBBBBB),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFooter(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => _confirmLogout(context),
          child: Text(
            'Logout',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[500],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Version 1.2.0',
          style: GoogleFonts.poppins(
            fontSize: 12,
            color: Colors.grey[400],
          ),
        ),
      ],
    );
  }

  /// Shows a confirmation dialog, then clears credentials and navigates to login.
  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: Colors.white,
        title: Text(
          'Log out?',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: const Color(0xFF1E1E1E),
          ),
        ),
        content: Text(
          'You\'ll need your recovery phrase to log back in. Make sure you have it saved.',
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: const Color(0xFF7B61FF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              'Log out',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // 1. Clear JWT + UUID from secure storage
      await AuthRepository().logout();
      // 2. Reset in-memory user state so a new login starts fresh
      if (context.mounted) {
        context.read<UserProvider>().reset();
        // 3. Navigate to login and remove all previous routes
        Navigator.of(context).pushNamedAndRemoveUntil(
          '/login',
          (route) => false,
        );
      }
    }
  }
}
