import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MindMateBottomNav extends StatelessWidget {
  final int currentIndex;
  const MindMateBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFF2F0E9), // Beige
        border: Border(
          top: BorderSide(color: Colors.black, width: 2),
        ),
      ),
      child: Row(
        children: [
          _buildNavItem(context, 0, Icons.home_outlined, "HOME"),
          _buildNavItem(context, 1, Icons.chat_bubble_outline, "CHAT"),
          _buildNavItem(context, 2, Icons.book_outlined, "JOURNAL"),
          _buildNavItem(context, 3, Icons.message_rounded, "MESSAGES"),
          _buildNavItem(context, 4, Icons.person_outline, "PROFILE"),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (index == currentIndex) return;
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              break;
            case 1:
              Navigator.pushNamed(context, '/chat');
              break;
            case 2:
              Navigator.pushNamed(context, '/mood-check-in');
              break;
            case 3:
              Navigator.pushNamed(context, '/insights');
              break;
            case 4:
              Navigator.pushNamed(context, '/profile-page');
              break;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFDEB00) : Colors.transparent,
            border: isSelected 
              ? const Border(
                  left: BorderSide(color: Colors.black, width: 2),
                  right: BorderSide(color: Colors.black, width: 2),
                )
              : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: Colors.black),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.spaceMono(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
