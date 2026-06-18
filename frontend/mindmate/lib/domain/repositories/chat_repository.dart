import '../models/chat_message.dart';
import 'base_repository.dart';

abstract class ChatRepository extends BaseRepository<ChatMessage> {
  Future<List<ChatMessage>> getHistory({required String conversationId});
}
