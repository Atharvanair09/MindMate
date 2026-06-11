import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service layer for communicating with the MindMate chat backend.
/// Mirrors the pattern used by [AuthService].
class ChatService {
  final String baseUrl = 'https://mindmate-9jyw.onrender.com/api/v1/chat';

  static const _defaultTimeout = Duration(seconds: 30);

  /// POST /api/v1/chat/message
  /// Sends a user message and returns the AI response.
  Future<Map<String, dynamic>> sendMessage({
    required String token,
    required String message,
    required String conversationId,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/message'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode({
            'message': message,
            'conversation_id': conversationId,
          }),
        )
        .timeout(_defaultTimeout);

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to send message';
      throw Exception(error);
    }
  }

  /// GET /api/v1/chat/history?conversation_id=X
  /// Fetches decrypted message history for a conversation.
  Future<List<Map<String, dynamic>>> getHistory({
    required String token,
    required String conversationId,
  }) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/history?conversation_id=$conversationId'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(_defaultTimeout);

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.cast<Map<String, dynamic>>();
    } else {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to fetch history';
      throw Exception(error);
    }
  }

  /// GET /api/v1/chat/conversations
  /// Lists all conversation IDs with a last-message preview.
  Future<List<Map<String, dynamic>>> getConversations({
    required String token,
  }) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/conversations'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        )
        .timeout(_defaultTimeout);

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.cast<Map<String, dynamic>>();
    } else {
      final error =
          jsonDecode(response.body)['error'] ?? 'Failed to fetch conversations';
      throw Exception(error);
    }
  }
}
