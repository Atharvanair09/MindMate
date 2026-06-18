import 'package:isar/isar.dart';

part 'chat_message.g.dart';

@collection
class ChatMessage {
  Id id = Isar.autoIncrement;

  @Index()
  late String conversationId;

  late String role;

  late String message;

  @Index()
  late DateTime createdAt;

  double? sentimentScore;

  bool embeddingGenerated = false;

  int? embeddingId;
}
