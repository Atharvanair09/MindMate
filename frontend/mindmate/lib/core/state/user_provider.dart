import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName = "BlueTiger42";
  int _wellnessScore = 72;
  String? _selectedMood;

  String get userName => _userName;
  int get wellnessScore => _wellnessScore;
  String? get selectedMood => _selectedMood;

  void updateUserName(String newName) {
    _userName = newName;
    notifyListeners();
  }

  void updateMood(String mood, int scoreImpact) {
    _selectedMood = mood;
    _wellnessScore = (72 + scoreImpact).clamp(0, 100);
    notifyListeners();
  }
}
