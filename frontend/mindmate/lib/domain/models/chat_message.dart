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

  /// Stress level: 0.0 (no stress) to 1.0 (extreme stress). Only set for user messages.
  double? stressScore;

  /// Emotional intensity: 0.0 (high energy / positive) to 1.0 (depleted / negative).
  /// Derived from inverted energy score. Only set for user messages.
  double? emotionalIntensity;

  bool embeddingGenerated = false;

  int? embeddingId;
}
