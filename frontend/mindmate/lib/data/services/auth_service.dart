import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'https://mindmate-9jyw.onrender.com/api/auth';
  final String userUrl = 'https://mindmate-9jyw.onrender.com/api/user';

  Future<void> sendOtp(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['error'] ?? 'Failed to send OTP';
      throw Exception(error);
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body)['error'] ?? 'Invalid OTP';
      throw Exception(error);
    }
  }

  Future<String> register(String uuid, String recoveryPhraseHash) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uuid': uuid,
        'recoveryPhraseHash': recoveryPhraseHash,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['token'];
    } else {
      final error = jsonDecode(response.body)['error'] ?? 'Registration failed';
      throw Exception(error);
    }
  }

  Future<Map<String, String>> recoverAccount(String recoveryPhraseHash) async {
    final response = await http.post(
      Uri.parse('$baseUrl/recover'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'recoveryPhraseHash': recoveryPhraseHash}),
    );

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
  /// [token] is the JWT bearer token.
  Future<void> setupProfile(
      String token, String username, String avatarLabel) async {
    final response = await http.patch(
      Uri.parse('$userUrl/profile/setup'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'username': username, 'avatarLabel': avatarLabel}),
    );

    if (response.statusCode != 200) {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to save profile';
      throw Exception(error);
    }
  }

  /// Updates the avatar label only — username is never touched.
  Future<void> updateAvatar(String token, String avatarLabel) async {
    final response = await http.patch(
      Uri.parse('$userUrl/profile/avatar'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'avatarLabel': avatarLabel}),
    );

    if (response.statusCode != 200) {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to update avatar';
      throw Exception(error);
    }
  }

  /// Fetches the stored username and avatarLabel for the authenticated user.
  /// Returns null values when the profile has not been set yet.
  Future<Map<String, String?>> fetchProfile(String token) async {
    final response = await http.get(
      Uri.parse('$userUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return {
        'username': data['username'] as String?,
        'avatarLabel': data['avatarLabel'] as String?,
      };
    } else {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to fetch profile';
      throw Exception(error);
    }
  }
}
