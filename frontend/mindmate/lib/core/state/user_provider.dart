import 'package:flutter/material.dart';
import '../../core/constants/avatar_options.dart';
import '../../data/repositories/auth_repository.dart';

class UserProvider extends ChangeNotifier {
  // Username starts empty — populated from MongoDB on login via loadProfile()
  String _userName = '';
  int _wellnessScore = 72;
  String? _selectedMood;

  // Avatar state — defaults to "Cosmic" until profile is loaded
  IconData _avatarIcon = Icons.auto_awesome;
  List<Color> _avatarGradient = const [Color(0xFF7B61FF), Color(0xFFB19DFF)];
  String _avatarLabel = 'Cosmic';

  /// If not null, the user picked a custom photo from their gallery.
  String? _customAvatarPath;

  /// True once the profile has been fetched from MongoDB (or confirmed absent).
  bool _profileLoaded = false;

  String get userName => _userName;
  int get wellnessScore => _wellnessScore;
  String? get selectedMood => _selectedMood;
  IconData get avatarIcon => _avatarIcon;
  List<Color> get avatarGradient => _avatarGradient;
  String get avatarLabel => _avatarLabel;
  String? get customAvatarPath => _customAvatarPath;
  bool get profileLoaded => _profileLoaded;

  bool get hasCustomAvatar => _customAvatarPath != null;

  /// Fetches username + avatarLabel from MongoDB and restores them in-memory.
  /// Called once at app startup when a valid session exists.
  /// Falls back gracefully to defaults on network error.
  Future<void> loadProfile(AuthRepository repo) async {
    try {
      final profile = await repo.fetchUserProfile();
      if (profile != null) {
        final label = profile['avatarLabel'];
        final avatar = avatarByLabel(label);
        _userName = profile['username'] ?? '';
        _avatarIcon = avatar.icon;
        _avatarGradient = avatar.gradient;
        _avatarLabel = avatar.label;
        _customAvatarPath = null; // custom photos are device-local only
      }
    } catch (_) {
      // Network failure — silently keep defaults; user can fix in profile setup
    } finally {
      _profileLoaded = true;
      notifyListeners();
    }
  }

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
    _profileLoaded = true;
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
