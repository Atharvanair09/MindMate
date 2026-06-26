class CommunityWellness {
  final String communityName;
  final double averageMood; // 1 to 5
  final double averageBurnout; // 0 to 100
  final double negativeConversationRate; // percentage
  final double positiveConversationRate; // percentage
  final int supportiveReplies;
  final String overallTrend; // 'Healthy', 'Needs Attention', 'Improving'
  final String? alertMessage; // Optional alert like "Stress level increased this week."

  CommunityWellness({
    required this.communityName,
    required this.averageMood,
    required this.averageBurnout,
    required this.negativeConversationRate,
    required this.positiveConversationRate,
    required this.supportiveReplies,
    required this.overallTrend,
    this.alertMessage,
  });
}
