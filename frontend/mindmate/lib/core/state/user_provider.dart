import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../core/constants/avatar_options.dart';
import '../../data/repositories/auth_repository.dart';

class UserProvider extends ChangeNotifier {
  // Username starts empty — populated from MongoDB on login via loadProfile().
  // Once set, it is NEVER changed again (immutable by design).
  String _userName = '';
  int _wellnessScore = 72;
  String? _selectedMood;

  // Avatar state — defaults to "Cosmic" until profile is loaded
  IconData _avatarIcon = Icons.auto_awesome;
  List<Color> _avatarGradient = const [Color(0xFF7B61FF), Color(0xFFB19DFF)];
  String _avatarLabel = 'Cosmic';

  /// If not null, the user has a custom avatar stored as a base64 data URL
  /// (loaded from MongoDB) or as a local file path (picked this session).
  String? _avatarImageUrl; // base64 data URL from server
  String? _localAvatarPath; // ephemeral local path picked this session

  /// True once the profile has been fetched from MongoDB (or confirmed absent).
  bool _profileLoaded = false;

  String get userName => _userName;
  int get wellnessScore => _wellnessScore;
  String? get selectedMood => _selectedMood;
  IconData get avatarIcon => _avatarIcon;
  List<Color> get avatarGradient => _avatarGradient;
  String get avatarLabel => _avatarLabel;
  bool get profileLoaded => _profileLoaded;

  /// The persisted base64 data URL for the custom avatar (from MongoDB).
  String? get avatarImageUrl => _avatarImageUrl;

  /// True when the user has a custom photo avatar (either local or persisted).
  bool get hasCustomAvatar => _localAvatarPath != null || _avatarImageUrl != null;

  /// Returns decoded bytes for the avatar image to display with Image.memory.
  /// Prefers the locally picked file (this session) over the persisted URL.
  /// Returns null if no custom avatar is set.
  Uint8List? get avatarImageBytes {
    if (_localAvatarPath != null) {
      // Will be read by the UI directly from file; return null here.
      return null;
    }
    if (_avatarImageUrl != null) {
      try {
        final dataUrl = _avatarImageUrl!;
        final commaIdx = dataUrl.indexOf(',');
        if (commaIdx != -1) {
          return base64Decode(dataUrl.substring(commaIdx + 1));
        }
      } catch (_) {}
    }
    return null;
  }

  /// Local file path picked this session (not yet persisted / already saved).
  String? get localAvatarPath => _localAvatarPath;

  /// True when the user has a username assigned (profile setup completed).
  bool get hasUsername => _userName.isNotEmpty;

  /// Fetches username + avatarLabel + avatarImageUrl from MongoDB and restores
  /// them in-memory. Called once at app startup when a valid session exists.
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
        // Restore persisted custom photo (base64 data URL)
        _avatarImageUrl = profile['avatarImageUrl'];
        _localAvatarPath = null; // local paths don't survive restarts
      }
    } catch (_) {
      // Network failure — silently keep defaults; user can fix in profile setup
    } finally {
      _profileLoaded = true;
      notifyListeners();
    }
  }

  /// Called from ProfileSetupPage on first-time setup — sets username + avatar.
  /// [localImagePath] is the ephemeral local path of a gallery-picked image.
  /// [persistedImageUrl] is the base64 data URL already saved to MongoDB.
  /// Username is written once here and never changed afterwards.
  void updateProfile({
    required String username,
    required IconData avatarIcon,
    required List<Color> avatarGradient,
    required String avatarLabel,
    String? localImagePath,
    String? persistedImageUrl,
  }) {
    _userName = username;
    _avatarIcon = avatarIcon;
    _avatarGradient = avatarGradient;
    _avatarLabel = avatarLabel;
    _localAvatarPath = localImagePath;
    _avatarImageUrl = persistedImageUrl;
    _profileLoaded = true;
    notifyListeners();
  }

  /// Called when the user updates their avatar only (after initial setup).
  /// [localImagePath] is ephemeral; [persistedImageUrl] is the server-saved URL.
  /// Username is intentionally NOT touched.
  void updateAvatar({
    required IconData avatarIcon,
    required List<Color> avatarGradient,
    required String avatarLabel,
    String? localImagePath,
    String? persistedImageUrl,
  }) {
    _avatarIcon = avatarIcon;
    _avatarGradient = avatarGradient;
    _avatarLabel = avatarLabel;
    _localAvatarPath = localImagePath;
    _avatarImageUrl = persistedImageUrl;
    notifyListeners();
  }

  void updateMood(String mood, int scoreImpact) {
    _selectedMood = mood;
    _wellnessScore = (72 + scoreImpact).clamp(0, 100);
    notifyListeners();
  }

  /// Resets all state back to defaults. Call this on logout before
  /// navigating back to the login screen.
  void reset() {
    _userName = '';
    _wellnessScore = 72;
    _selectedMood = null;
    _avatarIcon = Icons.auto_awesome;
    _avatarGradient = const [Color(0xFF7B61FF), Color(0xFFB19DFF)];
    _avatarLabel = 'Cosmic';
    _avatarImageUrl = null;
    _localAvatarPath = null;
    _profileLoaded = false;
    notifyListeners();
  }
}
