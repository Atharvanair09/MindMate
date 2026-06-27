import 'package:isar/isar.dart';

part 'community_membership.g.dart';

@collection
class CommunityMembership {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String communityName;
  
  late DateTime joinedAt;
  late DateTime lastVisitAt;
}
