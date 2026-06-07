import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/state/user_provider.dart';

class MoodSelector extends StatelessWidget {
  const MoodSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final moods = [
      {'emoji': '🤩', 'label': 'Great', 'impact': 8},
      {'emoji': '😊', 'label': 'Good', 'impact': 4},
      {'emoji': '😐', 'label': 'Neutral', 'impact': 0},
      {'emoji': '😔', 'label': 'Sad', 'impact': -5},
      {'emoji': '😢', 'label': 'Awful', 'impact': -12},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "How are you feeling?",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.darkText,
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/mood-check-in'),
              child: Text(
                "Full Check-in",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = (constraints.maxWidth - 40) / 5;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: moods.map((mood) {
                    final isSelected = userProvider.selectedMood == mood['label'];
                    return GestureDetector(
                      onTap: () {
                        userProvider.updateMood(
                          mood['label'] as String,
                          mood['impact'] as int,
                        );
                      },
                      child: Column(
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: itemWidth,
                            height: itemWidth,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryPurple : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: isSelected 
                                      ? AppColors.primaryPurple.withOpacity(0.3) 
                                      : Colors.black.withOpacity(0.05),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                mood['emoji'] as String,
                                style: TextStyle(fontSize: itemWidth * 0.45),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            mood['label'] as String,
                            style: GoogleFonts.poppins(
                              fontSize: (itemWidth * 0.25).clamp(10, 12),
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.primaryPurple : AppColors.lightText,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
