import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/colors.dart';
import '../../core/state/user_provider.dart';
import '../widgets/wellness_score_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/check_in_card.dart';
import '../widgets/action_card.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              _buildTopBar(context),
              const SizedBox(height: 24),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return WellnessScoreCard(score: userProvider.wellnessScore);
                },
              ),
              const SizedBox(height: 32),
              const MoodSelector(),
              const SizedBox(height: 32),
              const WeeklyChart(),
              const SizedBox(height: 32),
              const CheckInCard(),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ActionCard(
                      title: "Breathe",
                      subtitle: "3 min focus",
                      icon: Icons.air,
                      bgColor: AppColors.breatheBg,
                      iconColor: Colors.redAccent,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ActionCard(
                      title: "Coping",
                      subtitle: "Reading",
                      icon: Icons.menu_book,
                      bgColor: AppColors.copingBg,
                      iconColor: AppColors.primaryPurple,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 0),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Demonstrating dynamic name update
          context.read<UserProvider>().updateUserName("BlueTiger46");
        },
        backgroundColor: AppColors.primaryPurple,
        mini: true,
        child: const Icon(Icons.refresh, color: Colors.white),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userState, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Image.network(
                        'https://api.dicebear.com/7.x/adventurer/png?seed=Felix',
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      "Hey, ${userState.userName} 👋",
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4B39EF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.notifications_none_outlined, color: AppColors.darkText, size: 24),
            ),
          ],
        );
      },
    );
  }
}