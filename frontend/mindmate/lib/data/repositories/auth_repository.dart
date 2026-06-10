import 'dart:io';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:crypto/crypto.dart';
import '../services/auth_service.dart';

class AuthRepository {
  final AuthService _authService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _jwtKey = 'jwt_token';
  static const String _uuidKey = 'device_uuid';

  AuthRepository({AuthService? authService})
      : _authService = authService ?? AuthService();

  Future<bool> hasValidSession() async {
    final token = await _secureStorage.read(key: _jwtKey);
    return token != null && token.isNotEmpty;
  }

  Future<void> sendOtp(String email) async {
    await _authService.sendOtp(email);
  }

  Future<void> verifyOtp(String email, String otp) async {
    await _authService.verifyOtp(email, otp);
  }

  String generateRecoveryPhrase() {
    return bip39.generateMnemonic();
  }

  String _hashPhrase(String phrase) {
    final bytes = utf8.encode(phrase);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<void> registerWithPhrase(String phrase) async {
    // Generate UUID for the device
    final uuid = const Uuid().v4();
    final hash = _hashPhrase(phrase);

    final token = await _authService.register(uuid, hash);

    await _secureStorage.write(key: _uuidKey, value: uuid);
    await _secureStorage.write(key: _jwtKey, value: token);
  }

  Future<void> recoverAccount(String phrase) async {
    final hash = _hashPhrase(phrase);
    final result = await _authService.recoverAccount(hash);

    await _secureStorage.write(key: _jwtKey, value: result['token']!);
    await _secureStorage.write(key: _uuidKey, value: result['uuid']!);
  }

  /// First-time profile setup: persists [username] (immutable) + [avatarLabel].
  /// Optionally uploads [imageFile] as a base64 data URL for the custom avatar.
  /// No-ops silently if no JWT is present (should not happen in normal flow).
  Future<void> setupUserProfile(
    String username,
    String avatarLabel, {
    File? imageFile,
  }) async {
    final token = await _secureStorage.read(key: _jwtKey);
    if (token == null) return;

    String? avatarImageUrl;
    if (imageFile != null) {
      avatarImageUrl = await _fileToBase64DataUrl(imageFile);
    }

    await _authService.setupProfile(
      token,
      username,
      avatarLabel,
      avatarImageUrl: avatarImageUrl,
    );
  }

  /// Updates avatar only — never modifies the username.
  /// Optionally uploads [imageFile] as a base64 data URL for the custom avatar.
  /// Pass [clearImage] as true to remove a previously stored custom photo.
  Future<void> updateUserAvatar(
    String avatarLabel, {
    File? imageFile,
    bool clearImage = false,
  }) async {
    final token = await _secureStorage.read(key: _jwtKey);
    if (token == null) return;

    String? avatarImageUrl;
    if (imageFile != null) {
      avatarImageUrl = await _fileToBase64DataUrl(imageFile);
    }

    await _authService.updateAvatar(
      token,
      avatarLabel,
      avatarImageUrl: avatarImageUrl,
      clearImage: clearImage,
    );
  }

  /// Fetches the stored profile from MongoDB.
  /// Returns `null` if the user hasn't completed profile setup yet.
  /// The returned map includes: username, avatarLabel, avatarImageUrl (nullable).
  Future<Map<String, String?>?> fetchUserProfile() async {
    final token = await _secureStorage.read(key: _jwtKey);
    if (token == null) return null;
    try {
      final profile = await _authService.fetchProfile(token);
      // If both identity fields are null, profile hasn't been set up yet
      if (profile['username'] == null && profile['avatarLabel'] == null) {
        return null;
      }
      return profile;
    } catch (_) {
      // Network error — don't crash; caller will fall back to defaults
      return null;
    }
  }

  /// Clears all stored credentials. Call on logout.
  Future<void> logout() async {
    await _secureStorage.delete(key: _jwtKey);
    await _secureStorage.delete(key: _uuidKey);
  }

  // ── Helpers ──────────────────────────────────────────────────────────────────

  /// Reads [file] and returns it as a base64-encoded data URL string,
  /// e.g. "data:image/jpeg;base64,/9j/4AAQ...".
  Future<String> _fileToBase64DataUrl(File file) async {
    final bytes = await file.readAsBytes();
    final base64Str = base64Encode(bytes);
    // Determine a simple MIME type from the extension
    final ext = file.path.split('.').last.toLowerCase();
    final mime = (ext == 'png') ? 'image/png' : 'image/jpeg';
    return 'data:$mime;base64,$base64Str';
  }
}
