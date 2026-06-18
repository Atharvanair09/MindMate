import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';
import 'chat_service.dart';

/// Handles API communication for chat, bypassing local database.
class ChatApiService {
  final ChatService _chatService;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  static const String _jwtKey = 'jwt_token';

  ChatApiService({ChatService? chatService})
      : _chatService = chatService ?? ChatService();

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

  Future<List<Map<String, dynamic>>> getConversations() async {
    final token = await _secureStorage.read(key: _jwtKey);
    if (token == null) throw Exception('Not authenticated');

    return _chatService.getConversations(token: token);
  }

  String newConversationId() => const Uuid().v4();
}
