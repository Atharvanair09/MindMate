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
}
