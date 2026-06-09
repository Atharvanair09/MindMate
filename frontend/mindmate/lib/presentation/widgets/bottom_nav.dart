import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/colors.dart';

class MindMateBottomNav extends StatelessWidget {
  final int currentIndex;
  const MindMateBottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w500),
        ),
        indicatorColor: AppColors.primaryPurple.withOpacity(0.1),
      ),
      child: NavigationBar(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.white,
        selectedIndex: currentIndex,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: (index) {
          if (index == currentIndex) return;
          
          switch (index) {
            case 0:
              Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
              break;
            case 1:
              // Navigator.pushNamed(context, '/journal');
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
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_filled, color: AppColors.primaryPurple),
            label: "Home",
          ),
          NavigationDestination(icon: Icon(Icons.edit_note), label: "Journal"),
          NavigationDestination(
            icon: Icon(Icons.sentiment_satisfied_alt),
            selectedIcon: Icon(Icons.sentiment_satisfied_alt, color: AppColors.primaryPurple),
            label: "Mood",
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics_outlined),
            selectedIcon: Icon(Icons.analytics, color: AppColors.primaryPurple),
            label: "Insights",
          ),
          NavigationDestination(icon: Icon(Icons.person_outline), label: "Profile"),
        ],
      ),
    );
  }
}
