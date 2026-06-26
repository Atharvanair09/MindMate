import '../../domain/models/community_wellness.dart';

class CommunityWellnessService {
  CommunityWellnessService._();
  static final instance = CommunityWellnessService._();

  Future<CommunityWellness> getWellnessForCommunity(String communityName) async {
    // Mocking wellness data based on community names as requested
    
    // Artificial delay to simulate network/processing
    await Future.delayed(const Duration(milliseconds: 400));
    
    if (communityName.toLowerCase().contains("exam")) {
      return CommunityWellness(
        communityName: communityName,
        averageMood: 2.1,
        averageBurnout: 75.0,
        negativeConversationRate: 65.0,
        positiveConversationRate: 35.0,
        supportiveReplies: 142,
        overallTrend: 'Needs Attention',
        alertMessage: 'Stress level increased this week.',
      );
    } else if (communityName.toLowerCase().contains("burnout")) {
      return CommunityWellness(
        communityName: communityName,
        averageMood: 4.2,
        averageBurnout: 40.0,
        negativeConversationRate: 20.0,
        positiveConversationRate: 80.0,
        supportiveReplies: 405,
        overallTrend: 'Improving',
        alertMessage: 'Positive recovery trend observed.',
      );
    } else if (communityName.toLowerCase().contains("social anxiety")) {
      return CommunityWellness(
        communityName: communityName,
        averageMood: 2.8,
        averageBurnout: 60.0,
        negativeConversationRate: 50.0,
        positiveConversationRate: 50.0,
        supportiveReplies: 210,
        overallTrend: 'Needs Attention',
        alertMessage: 'Increase in anxiety-related discussions.',
      );
    } else if (communityName.toLowerCase().contains("sleep")) {
      return CommunityWellness(
        communityName: communityName,
        averageMood: 3.5,
        averageBurnout: 50.0,
        negativeConversationRate: 40.0,
        positiveConversationRate: 60.0,
        supportiveReplies: 120,
        overallTrend: 'Healthy',
      );
    } else {
      // Default healthy community
      return CommunityWellness(
        communityName: communityName,
        averageMood: 4.5,
        averageBurnout: 30.0,
        negativeConversationRate: 15.0,
        positiveConversationRate: 85.0,
        supportiveReplies: 320,
        overallTrend: 'Healthy',
      );
    }
  }

  Future<List<CommunityWellness>> getMonitoredCommunities() async {
    // Return a mocked list of monitored communities for the home card
    return [
      await getWellnessForCommunity("Exam Stress"),
      await getWellnessForCommunity("Burnout Recovery"),
      await getWellnessForCommunity("Social Anxiety"),
    ];
  }
}
