import 'dart:math';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/anonymous_post.dart';
import 'community_membership_service.dart';
import 'community_socket_service.dart';

class CommunityMetrics {
  final int totalMembers;
  final int activeMembersToday;
  final int postsToday;
  final int postsThisWeek;
  final int repliesToday;
  final double avgRepliesPerPost;
  final List<String> trendingTopics;
  final String mostActiveHours;
  final List<String> mostHelpfulContributors;
  final int newestMembersThisWeek;
  final DateTime lastActivityTime;

  CommunityMetrics({
    required this.totalMembers,
    required this.activeMembersToday,
    required this.postsToday,
    required this.postsThisWeek,
    required this.repliesToday,
    required this.avgRepliesPerPost,
    required this.trendingTopics,
    required this.mostActiveHours,
    required this.mostHelpfulContributors,
    required this.newestMembersThisWeek,
    required this.lastActivityTime,
  });
}

class CommunityActivityEngine {
  CommunityActivityEngine._privateConstructor();
  static final CommunityActivityEngine instance = CommunityActivityEngine._privateConstructor();

  Isar get _isar => IsarDatabase.instance;

  // Base simulation data to ensure communities don't appear empty locally
  final Map<String, int> _baseMembers = {
    'Exam Stress': 124,
    'Sleep Recovery': 89,
    'Burnout Recovery': 210,
    'Relationship Support': 150,
    'Career Pressure': 105,
    'Social Anxiety': 180,
    'Motivation': 320,
    'General Wellness': 450,
  };

  final Map<String, List<String>> _topics = {
    'Exam Stress': ['Finals', 'Study Tips', 'Time Management'],
    'Sleep Recovery': ['Insomnia', 'Deep Sleep', 'Routines'],
    'Burnout Recovery': ['Taking Breaks', 'Overwork', 'Mental Health Day'],
    'Relationship Support': ['Communication', 'Boundaries', 'Trust'],
    'Career Pressure': ['Imposter Syndrome', 'Promotions', 'Work-Life Balance'],
    'Social Anxiety': ['Small Talk', 'Group Settings', 'Confidence'],
    'Motivation': ['Goal Setting', 'Discipline', 'Procrastination'],
    'General Wellness': ['Meditation', 'Healthy Diet', 'Exercise'],
  };

  Future<CommunityMetrics> getMetrics(String communityName) async {
    final availableTopics = _topics[communityName] ?? ['General', 'Support', 'Advice'];
    
    // Fetch dynamic metrics from backend via Socket.IO
    final backendMetrics = await CommunitySocketService.instance.getMetrics(communityName);
    
    int activeMembers = backendMetrics['activeMembers'] ?? 1;
    int totalMembers = backendMetrics['totalMembers'] ?? _baseMembers[communityName] ?? 50;
    int postsToday = backendMetrics['messagesToday'] ?? 0;
    int repliesToday = backendMetrics['repliesToday'] ?? 0;

    return CommunityMetrics(
      totalMembers: totalMembers,
      activeMembersToday: activeMembers,
      postsToday: postsToday,
      postsThisWeek: postsToday + 12, // mock value as backend doesn't track this yet
      repliesToday: repliesToday,
      avgRepliesPerPost: postsToday > 0 ? (repliesToday / postsToday) : 0.0,
      trendingTopics: availableTopics.take(2).toList(),
      mostActiveHours: "18:00 - 20:00", // static for now
      mostHelpfulContributors: [],
      newestMembersThisWeek: 3,
      lastActivityTime: DateTime.now(),
    );
  }
}
