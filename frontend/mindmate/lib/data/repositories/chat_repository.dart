import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import '../services/chat_service.dart';

/// Repository layer for chat — manages auth token access and delegates
/// to [ChatService]. Mirrors the [AuthRepository] pattern.
class ChatRepository {
  final ChatService _chatService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _jwtKey = 'jwt_token';

  ChatRepository({ChatService? chatService})
      : _chatService = chatService ?? ChatService();

  /// Sends a message and returns the backend response:
  /// { response: string, emotion_detected: string, show_escalation: bool }
  Future<Map<String, dynamic>> sendMessage({
    required String message,
    required String conversationId,
  }) async {
    final token = await _secureStorage.read(key: _jwtKey);
    if (token == null) throw Exception('Not authenticated');

    return _chatService.sendMessage(
      token: token,
      message: message,
      conversationId: conversationId,
    );
  }

  /// Fetches the full message history for a conversation.
  /// Returns a list of { role, message, emotion, timestamp }.
  Future<List<Map<String, dynamic>>> getHistory({
    required String conversationId,
  }) async {
    final token = await _secureStorage.read(key: _jwtKey);
    if (token == null) throw Exception('Not authenticated');

    return _chatService.getHistory(
      token: token,
      conversationId: conversationId,
    );
  }

  /// Lists all conversations for this user.
  Future<List<Map<String, dynamic>>> getConversations() async {
    final token = await _secureStorage.read(key: _jwtKey);
    if (token == null) throw Exception('Not authenticated');

    return _chatService.getConversations(token: token);
  }

  /// Generates a new unique conversation ID.
  String newConversationId() => const Uuid().v4();
}
