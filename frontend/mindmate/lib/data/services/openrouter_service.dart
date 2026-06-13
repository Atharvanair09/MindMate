import 'dart:convert';
import 'package:http/http.dart' as http;

class Message {
  final String role;
  final String content;

  Message({required this.role, required this.content});

  Map<String, String> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}

class OpenRouterService {
  final List<Message> _conversationHistory = [];
  String _backendUrl = '';
  String _authToken = '';

  void setConfig(String url, String token) {
    _backendUrl = url;
    _authToken = token;
  }

  OpenRouterService() {
    // Add initial system message
    _conversationHistory.add(Message(
      role: 'system',
      content: 'You are a compassionate mental health support companion named MindMate. Speak naturally, warmly, and conversationally. Keep responses concise and human-like. Ask thoughtful follow-up questions. Do not claim to be a licensed therapist. Encourage professional help when appropriate.'
    ));
  }

  void _addMessage(Message message) {
    _conversationHistory.add(message);
    // Keep only the latest 20 messages, plus the system prompt (which should ideally always be there)
    // We'll keep the system prompt at index 0 and trim the rest.
    if (_conversationHistory.length > 21) {
      _conversationHistory.removeAt(1);
    }
  }

  void clearHistory() {
    if (_conversationHistory.length > 1) {
      _conversationHistory.removeRange(1, _conversationHistory.length);
    }
  }

  Future<String> sendMessage(String text, {int retryCount = 0}) async {
    _addMessage(Message(role: 'user', content: text));

    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/api/v1/voice/chat'),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'messages': _conversationHistory.map((m) => m.toJson()).toList(),
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply = data['choices'][0]['message']['content'];
        _addMessage(Message(role: 'assistant', content: reply));
        return reply;
      } else {
        print("OpenRouter API Error: ${response.statusCode} - ${response.body}");
        throw Exception("Failed to get response");
      }
    } catch (e) {
      print("OpenRouter Error: $e");
      if (retryCount < 1) {
        print("Retrying OpenRouter request...");
        return sendMessage(text, retryCount: retryCount + 1);
      }
      // Revert the user message if it completely failed
      if (_conversationHistory.isNotEmpty && _conversationHistory.last.role == 'user') {
        _conversationHistory.removeLast();
      }
      return "I couldn't respond right now. Please try again.";
    }
  }
}
