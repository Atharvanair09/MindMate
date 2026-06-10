import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://mindmate-9jyw.onrender.com/api/auth';
  final String userUrl = 'https://mindmate-9jyw.onrender.com/api/user';

  // Standard timeout for lightweight calls
  static const _defaultTimeout = Duration(seconds: 30);
  // Longer timeout for image upload calls (base64 payload can be large + Render cold-start)
  static const _uploadTimeout = Duration(seconds: 60);

  Future<void> sendOtp(String email) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/send-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email}),
        )
        .timeout(_defaultTimeout);

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to send OTP';
      throw Exception(error);
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/verify-otp'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'email': email, 'otp': otp}),
        )
        .timeout(_defaultTimeout);

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['error'] ?? 'Invalid OTP';
      throw Exception(error);
    }
  }

  Future<String> register(String uuid, String recoveryPhraseHash) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'uuid': uuid,
            'recoveryPhraseHash': recoveryPhraseHash,
          }),
        ) 
        .timeout(_defaultTimeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Registration failed';
      throw Exception(error);
    }
  }

  Future<Map<String, String>> recoverAccount(String recoveryPhraseHash) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/recover'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'recoveryPhraseHash': recoveryPhraseHash}),
        )
        .timeout(_defaultTimeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'token': data['token'],
        'uuid': data['uuid'],
      };
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Recovery failed';
      throw Exception(error);
    }
  }

  /// First-time profile setup — saves username (immutable) + initial avatarLabel.
  /// Optionally sends [avatarImageUrl] (base64 data URL) to persist a custom photo.
  /// Uses a longer timeout because the base64 payload can be large.
  Future<void> setupProfile(
    String token,
    String username,
    String avatarLabel, {
    String? avatarImageUrl,
  }) async {
    final body = <String, dynamic>{
      'username': username,
      'avatarLabel': avatarLabel,
    };
    if (avatarImageUrl != null) {
      body['avatarImageUrl'] = avatarImageUrl;
    }

    final response = await http
        .patch(
          Uri.parse('$userUrl/profile/setup'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        )
        .timeout(avatarImageUrl != null ? _uploadTimeout : _defaultTimeout);

    if (response.statusCode != 200) {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to save profile';
      throw Exception('${response.statusCode}: $error');
    }
  }

  /// Updates the avatar label and optionally the custom photo URL.
  /// Pass [avatarImageUrl] as a base64 data URL to save a gallery image,
  /// or explicitly pass `null` to clear a previously stored custom photo.
  /// Uses a longer timeout because the base64 payload can be large.
  Future<void> updateAvatar(
    String token,
    String avatarLabel, {
    String? avatarImageUrl,
    bool clearImage = false,
  }) async {
    final body = <String, dynamic>{'avatarLabel': avatarLabel};
    if (clearImage || avatarImageUrl != null) {
      body['avatarImageUrl'] = avatarImageUrl;
    }

    final response = await http
        .patch(
          Uri.parse('$userUrl/profile/avatar'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        )
        .timeout(avatarImageUrl != null ? _uploadTimeout : _defaultTimeout);

    if (response.statusCode != 200) {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to update avatar';
      throw Exception('${response.statusCode}: $error');
    }
  }

  /// Fetches the stored username, avatarLabel, and avatarImageUrl for the
  /// authenticated user. Returns null values when not yet set.
  Future<Map<String, String?>> fetchProfile(String token) async {
    final response = await http
        .get(
          Uri.parse('$userUrl/profile'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(_defaultTimeout);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'username': data['username'] as String?,
        'avatarLabel': data['avatarLabel'] as String?,
        'avatarImageUrl': data['avatarImageUrl'] as String?,
      };
    } else {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to fetch profile';
      throw Exception('${response.statusCode}: $error');
    }
  }
}
