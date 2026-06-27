import 'package:isar/isar.dart';

part 'anonymous_post.g.dart';

@collection
class AnonymousPost {
  Id id = Isar.autoIncrement;

  late String originalText;
  late String sanitizedText;
  late String conversationId;
  late DateTime timestamp;

  // Storing Alias Mapping Metadata as a JSON string for debug purposes
  late String aliasMappingMetadata;

  // New Phase 9 additions
  int upvotes = 0;
  int replyCount = 0;
  int? parentPostId; // For threading replies
  bool isMock = false; // To distinguish between user-generated and mock data
}
