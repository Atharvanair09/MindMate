import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/community_membership.dart';

class CommunityMembershipService {
  CommunityMembershipService._privateConstructor();
  static final CommunityMembershipService instance = CommunityMembershipService._privateConstructor();

  Isar get _isar => IsarDatabase.instance;

  Future<void> joinCommunity(String communityName) async {
    final existing = await _isar.communityMemberships
        .filter()
        .communityNameEqualTo(communityName)
        .findFirst();

    if (existing != null) return;

    final membership = CommunityMembership()
      ..communityName = communityName
      ..joinedAt = DateTime.now()
      ..lastVisitAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.communityMemberships.put(membership);
    });
  }

  Future<void> leaveCommunity(String communityName) async {
    await _isar.writeTxn(() async {
      final membership = await _isar.communityMemberships
          .filter()
          .communityNameEqualTo(communityName)
          .findFirst();
      if (membership != null) {
        await _isar.communityMemberships.delete(membership.id);
      }
    });
  }

  Future<bool> isJoined(String communityName) async {
    final membership = await _isar.communityMemberships
        .filter()
        .communityNameEqualTo(communityName)
        .findFirst();
    return membership != null;
  }

  Future<List<CommunityMembership>> getJoinedCommunities() async {
    return await _isar.communityMemberships.where().findAll();
  }

  Future<void> updateLastVisit(String communityName) async {
    await _isar.writeTxn(() async {
      final membership = await _isar.communityMemberships
          .filter()
          .communityNameEqualTo(communityName)
          .findFirst();
      if (membership != null) {
        membership.lastVisitAt = DateTime.now();
        await _isar.communityMemberships.put(membership);
      }
    });
  }
}
