import 'dart:math';
import 'package:isar/isar.dart';
import '../../data/database/isar_database.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/chat_message.dart';
import '../../domain/models/reflection_result.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../domain/models/pattern_insight.dart';
import '../../domain/models/recovery_event.dart';
import '../../domain/models/community_recommendation.dart';
import '../ml/reflection_engine.dart';
import '../weekly_reflection/weekly_reflection_service.dart';
import '../pattern/pattern_discovery_service.dart';

class CommunityRecommendationService {
  CommunityRecommendationService._privateConstructor();
  static final CommunityRecommendationService instance = CommunityRecommendationService._privateConstructor();

  // Keyword mappings for different communities
  final Map<String, List<String>> _communityKeywords = {
    'Exam Stress': ['exam', 'assignment', 'study', 'grades', 'college', 'university', 'test'],
    'Sleep Recovery': ['sleep', 'insomnia', 'awake', 'tired', 'fatigue', 'rest'],
    'Burnout Recovery': ['overwhelmed', 'burnout', 'exhausted', 'drained', 'overwork', 'pressure'],
    'Relationship Support': ['friend', 'family', 'partner', 'breakup', 'relationship', 'lonely', 'isolated'],
    'Career Pressure': ['job', 'work', 'boss', 'career', 'promotion', 'salary', 'manager', 'fired'],
    'Social Anxiety': ['party', 'group', 'meeting', 'awkward', 'nervous', 'presentation', 'shy'],
    'Motivation': ['goals', 'lazy', 'stuck', 'unmotivated', 'purpose', 'discipline', 'procrastination', 'meaning'],
    'General Wellness': ['health', 'diet', 'gym', 'meditation', 'routine', 'habit', 'wellness']
  };

  // State to store debug information for the tester page
  Map<String, double> lastConfidenceScores = {};
  Map<String, String> lastMatchReasons = {};
  List<String> lastDetectedTags = [];

  Future<List<CommunityRecommendation>> generateRecommendations() async {
    final isar = IsarDatabase.instance;
    final now = DateTime.now();
    final sevenDaysAgo = now.subtract(const Duration(days: 7));

    // Gather inputs
    final recentJournals = await isar.journalEntrys.filter().createdAtGreaterThan(sevenDaysAgo).findAll();
    final recentChats = await isar.chatMessages.filter().roleEqualTo('user').and().createdAtGreaterThan(sevenDaysAgo).findAll();
    
    final latestReflection = await ReflectionEngine.instance.getLatestReflection();
    final weeklyReflection = await WeeklyReflectionService.instance.getLatestReflection();
    final patterns = await PatternDiscoveryService.instance.getPatterns();

    // Map to hold scores
    Map<String, double> scores = {};
    for (var community in _communityKeywords.keys) {
      scores[community] = 0.0;
    }
    Map<String, String> reasons = {};
    Set<String> detectedTags = {};

    // 1. Text Analysis (Journals & Chats)
    String allText = '';
    for (var j in recentJournals) allText += ' ${j.preview.toLowerCase()}';
    for (var c in recentChats) allText += ' ${c.message.toLowerCase()}';

    for (var entry in _communityKeywords.entries) {
      String community = entry.key;
      List<String> keywords = entry.value;
      
      int matchCount = 0;
      for (var kw in keywords) {
        if (allText.contains(kw)) {
          matchCount++;
          detectedTags.add(kw);
        }
      }

      if (matchCount > 0) {
        scores[community] = scores[community]! + (matchCount * 15.0);
        reasons[community] = "Recent activity mentions keywords related to this community.";
      }
    }

    // 2. Burnout Score Metrics
    if (latestReflection != null) {
      if (latestReflection.burnoutScore > 70) {
        scores['Burnout Recovery'] = (scores['Burnout Recovery'] ?? 0) + 40.0;
        reasons['Burnout Recovery'] = "Your recent burnout score indicates a need for recovery.";
      }
      if (latestReflection.currentMood != null && latestReflection.currentMood!.toLowerCase().contains("tired")) {
        scores['Sleep Recovery'] = (scores['Sleep Recovery'] ?? 0) + 20.0;
        reasons['Sleep Recovery'] = "Your recent mood logs indicate fatigue.";
      }
    }

    // 3. Weekly Reflection & Trends
    if (weeklyReflection != null) {
      String weeklyText = (weeklyReflection.negativeIndicators.join(' ') + ' ' + weeklyReflection.keyPatterns.join(' ')).toLowerCase();
      
      for (var entry in _communityKeywords.entries) {
        String community = entry.key;
        for (var kw in entry.value) {
          if (weeklyText.contains(kw)) {
            scores[community] = scores[community]! + 25.0;
            reasons[community] = "Identified as a key theme in your weekly reflection.";
            detectedTags.add(kw);
            break; 
          }
        }
      }
    }

    // 4. Patterns
    for (var pattern in patterns) {
      String patternText = (pattern.patternName + ' ' + pattern.description).toLowerCase();
      if (patternText.contains("sleep")) {
        scores['Sleep Recovery'] = scores['Sleep Recovery']! + 30.0;
        reasons['Sleep Recovery'] = "A pattern related to sleep was detected.";
        detectedTags.add("pattern:sleep");
      }
      if (patternText.contains("work")) {
        scores['Career Pressure'] = scores['Career Pressure']! + 30.0;
        reasons['Career Pressure'] = "A pattern related to work stress was detected.";
        detectedTags.add("pattern:work");
      }
    }

    // Base default reason if none exist but score > 0
    for (var community in scores.keys) {
      if (scores[community]! > 0 && !reasons.containsKey(community)) {
        reasons[community] = "Recommended based on your recent wellness activity.";
      }
    }

    // Ensure general wellness has a baseline
    if (scores['General Wellness'] == 0.0) {
      scores['General Wellness'] = 10.0;
      reasons['General Wellness'] = "A great place to maintain overall well-being.";
    }

    // Save debug info
    lastDetectedTags = detectedTags.toList();
    lastConfidenceScores = {};
    for (var entry in scores.entries) {
      // Cap confidence at 98%
      lastConfidenceScores[entry.key] = min(98.0, entry.value);
    }
    lastMatchReasons = Map.from(reasons);

    // Create and sort recommendations
    List<CommunityRecommendation> recommendations = [];
    for (var community in scores.keys) {
      if (lastConfidenceScores[community]! > 0) {
        recommendations.add(CommunityRecommendation(
          communityName: community,
          matchReason: reasons[community] ?? "Recommended based on your profile.",
          confidence: lastConfidenceScores[community]!,
        ));
      }
    }

    // Sort by confidence descending
    recommendations.sort((a, b) => b.confidence.compareTo(a.confidence));

    // Return top 3
    return recommendations.take(3).toList();
  }
}
