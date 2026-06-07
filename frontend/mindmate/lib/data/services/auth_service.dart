import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  final String baseUrl = 'http://192.168.1.8:3000/api/auth'; // Adjust for web/iOS if needed

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
}
