import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFFF9F9FF);
  static const Color primaryPurple = Color(0xFF7B61FF);
  static const Color secondaryPurple = Color(0xFF9484FF);
  static const Color darkText = Color(0xFF1E1E1E);
  static const Color lightText = Color(0xFF757575);
  static const Color cardBg = Colors.white;
  static const Color shadowColor = Color(0x1A000000);
  
  static const Color wellnessGradientStart = Color(0xFF8E76FF);
  static const Color wellnessGradientEnd = Color(0xFFB19DFF);
  
  static const Color moodGreat = Color(0xFFFFD166);
  static const Color moodGood = Color(0xFF06D6A0);
  static const Color moodNeutral = Color(0xFF118AB2);
  static const Color moodSad = Color(0xFFEF476F);
  static const Color moodAwful = Color(0xFF073B4C);
  
  static const Color streakBg = Color(0xFFFFF9E7);
  static const Color greatBg = Color(0xFFE9F7EF);
  static const Color goodBg = Color(0xFFFFFBE6);
  static const Color okayBg = Color(0xFFFFF5EB);
  static const Color lowBg = Color(0xFFF4EFFF);
  static const Color strugglingBg = Color(0xFFFFEBEE);

  static const Color greatText = Color(0xFF27AE60);
  static const Color goodText = Color(0xFFD4AC0D);
  static const Color okayText = Color(0xFFE67E22);
  static const Color lowText = Color(0xFF8E44AD);
  static const Color strugglingText = Color(0xFFC0392B);

  static const Color reflectBg = Color(0xFFF3F1FF);
  static const Color breatheBg = Color(0xFFFFF1F1);
  static const Color copingBg = Color(0xFFF1F4FF);
  
  static const LinearGradient wellnessGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [wellnessGradientStart, wellnessGradientEnd],
  );

  static const LinearGradient logMoodGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
  );
}
