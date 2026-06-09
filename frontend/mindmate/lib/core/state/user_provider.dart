import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _userName = 'BlueTiger42';
  int _wellnessScore = 72;
  String? _selectedMood;

  // Avatar state — defaults to "Cosmic" style
  IconData _avatarIcon = Icons.auto_awesome;
  List<Color> _avatarGradient = const [Color(0xFF7B61FF), Color(0xFFB19DFF)];
  String _avatarLabel = 'Cosmic';

  /// If not null, the user picked a custom photo from their gallery.
  String? _customAvatarPath;

  String get userName => _userName;
  int get wellnessScore => _wellnessScore;
  String? get selectedMood => _selectedMood;
  IconData get avatarIcon => _avatarIcon;
  List<Color> get avatarGradient => _avatarGradient;
  String get avatarLabel => _avatarLabel;
  String? get customAvatarPath => _customAvatarPath;

  bool get hasCustomAvatar => _customAvatarPath != null;

  /// Called from ProfileSetupPage when the user confirms their identity.
  void updateProfile({
    required String username,
    required IconData avatarIcon,
    required List<Color> avatarGradient,
    required String avatarLabel,
    String? customAvatarPath,
  }) {
    _userName = username;
    _avatarIcon = avatarIcon;
    _avatarGradient = avatarGradient;
    _avatarLabel = avatarLabel;
    _customAvatarPath = customAvatarPath;
    notifyListeners();
  }

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
