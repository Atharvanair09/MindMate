import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/bottom_nav.dart';
import '../../domain/models/community_recommendation.dart';
import '../../services/community/community_recommendation_service.dart';
import 'community_chat_page.dart';
import '../../domain/models/community_wellness.dart';
import '../../services/community/community_wellness_service.dart';
import '../widgets/global_background.dart';
import '../../services/community/community_membership_service.dart';
import '../../services/community/community_activity_engine.dart';

class CommunityInfo {
  final String name;
  final String description;
  final String members;
  final String activity;
  final Color color;

  const CommunityInfo(this.name, this.description, this.members, this.activity, this.color);
}

const List<CommunityInfo> allCommunities = [
  CommunityInfo('Exam Stress', 'Students supporting students through exams.', '124 Members', 'High Activity', Color(0xFFFFD600)),
  CommunityInfo('Sleep Recovery', 'Tips and support for better rest.', '89 Members', 'Medium Activity', Color(0xFF0D6EFD)),
  CommunityInfo('Burnout Recovery', 'Recover from exhaustion and overwork.', '210 Members', 'High Activity', Color(0xFFFF5252)),
  CommunityInfo('Relationship Support', 'Navigate family and romantic dynamics.', '150 Members', 'High Activity', Color(0xFF4CAF50)),
  CommunityInfo('Career Pressure', 'Navigating workplace challenges.', '105 Members', 'Medium Activity', Color(0xFF9C27B0)),
  CommunityInfo('Social Anxiety', 'A safe space for overcoming social fears.', '180 Members', 'High Activity', Color(0xFF00BCD4)),
  CommunityInfo('Motivation', 'Find purpose and overcome procrastination.', '320 Members', 'Very High Activity', Color(0xFFFF9800)),
  CommunityInfo('General Wellness', 'Maintain overall well-being and health.', '450 Members', 'Very High Activity', Color(0xFF4A4A4A)),
];

class InsightsPage extends StatefulWidget {
  const InsightsPage({super.key});

  @override
  State<InsightsPage> createState() => _InsightsPageState();
}

class _InsightsPageState extends State<InsightsPage> {
  List<CommunityRecommendation> _recommendations = [];
  Map<String, CommunityWellness> _wellnessMap = {};
  Map<String, CommunityMetrics> _metricsMap = {};
  Set<String> _joinedCommunities = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    final joined = await CommunityMembershipService.instance.getJoinedCommunities();
    final joinedNames = joined.map((c) => c.communityName).toSet();

    final futures = <Future<dynamic>>[
      CommunityRecommendationService.instance.generateRecommendations(),
      ...allCommunities.map((c) => CommunityWellnessService.instance.getWellnessForCommunity(c.name)),
      ...allCommunities.map((c) => CommunityActivityEngine.instance.getMetrics(c.name)),
    ];
    final results = await Future.wait(futures);
    final recs = results[0] as List<CommunityRecommendation>;
    
    final Map<String, CommunityWellness> wellnessMap = {};
    final Map<String, CommunityMetrics> metricsMap = {};
    
    for (var i = 0; i < allCommunities.length; i++) {
      wellnessMap[allCommunities[i].name] = results[i + 1] as CommunityWellness;
      metricsMap[allCommunities[i].name] = results[i + 1 + allCommunities.length] as CommunityMetrics;
    }
    
    if (mounted) {
      setState(() {
        _recommendations = recs;
        _wellnessMap = wellnessMap;
        _metricsMap = metricsMap;
        _joinedCommunities = joinedNames;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "COMMUNITIES",
          style: GoogleFonts.anton(
            color: Colors.black,
            fontSize: 24,
            letterSpacing: 1.0,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(2.0),
          child: Container(
            color: Colors.black,
            height: 2.0,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : GlobalBackgroundLayer(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_joinedCommunities.isNotEmpty) ...[
                    Text(
                      "JOINED COMMUNITIES",
                      style: GoogleFonts.anton(
                        color: Colors.black,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...allCommunities.where((info) => _joinedCommunities.contains(info.name)).map((info) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildCommunityCard(
                          title: info.name,
                          description: info.description,
                          members: info.members,
                          activity: info.activity,
                          backgroundColor: info.color,
                          wellness: _wellnessMap[info.name],
                          metrics: _metricsMap[info.name],
                          isJoined: true,
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                  ],
                  if (_recommendations.where((rec) => !_joinedCommunities.contains(rec.communityName)).isNotEmpty) ...[
                    Text(
                      "RECOMMENDED FOR YOU",
                      style: GoogleFonts.anton(
                        color: Colors.black,
                        fontSize: 36,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ..._recommendations.where((rec) => !_joinedCommunities.contains(rec.communityName)).map((rec) {
                      final info = allCommunities.firstWhere(
                        (c) => c.name == rec.communityName,
                        orElse: () => allCommunities.last,
                      );
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: _buildCommunityCard(
                          title: info.name,
                          description: info.description,
                          members: info.members,
                          activity: info.activity,
                          backgroundColor: info.color,
                          wellness: _wellnessMap[info.name],
                          metrics: _metricsMap[info.name],
                          isJoined: false,
                        ),
                      );
                    }).toList(),
                    const SizedBox(height: 20),
                  ],
                  Text(
                    "BROWSE COMMUNITIES",
                    style: GoogleFonts.anton(
                      color: Colors.black,
                      fontSize: 36,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...allCommunities.where((info) {
                    return !_joinedCommunities.contains(info.name) &&
                        !_recommendations.any((rec) => rec.communityName == info.name);
                  }).map((info) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: _buildCommunityCard(
                        title: info.name,
                        description: info.description,
                        members: info.members,
                        activity: info.activity,
                        backgroundColor: info.color,
                        wellness: _wellnessMap[info.name],
                        metrics: _metricsMap[info.name],
                        isJoined: false,
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                ],
              ),
              ),
            ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 3),
    );
  }

  Widget _buildCommunityCard({
    required String title,
    required String description,
    required String members,
    required String activity,
    required Color backgroundColor,
    CommunityWellness? wellness,
    CommunityMetrics? metrics,
    bool isJoined = false,
  }) {
    final isDarkBackground = backgroundColor.computeLuminance() < 0.5;
    final textColor = isDarkBackground ? Colors.white : Colors.black;
    final subtitleColor = isDarkBackground ? Colors.white.withOpacity(0.9) : Colors.black87;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CommunityChatPage(
              communityName: title,
              communityColor: backgroundColor,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.anton(
                          color: textColor,
                          fontSize: 22,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        style: GoogleFonts.spaceGrotesk(
                          color: subtitleColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isJoined) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check, color: Colors.green, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              "Joined",
                              style: GoogleFonts.spaceGrotesk(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () async {
                            await CommunityMembershipService.instance.leaveCommunity(title);
                            _loadRecommendations();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(color: textColor, width: 1.5),
                            ),
                            child: Text(
                              "Leave Community",
                              style: GoogleFonts.spaceGrotesk(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () async {
                      await CommunityMembershipService.instance.joinCommunity(title);
                      _loadRecommendations();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      color: Colors.black,
                      child: Text(
                        "JOIN",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDarkBackground ? Colors.black.withOpacity(0.2) : Colors.white.withOpacity(0.5),
                border: Border.all(color: textColor.withOpacity(0.5), width: 1),
              ),
              child: Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.people, size: 14, color: textColor),
                      const SizedBox(width: 6),
                      Text(
                        metrics != null ? '${metrics.totalMembers} Members' : members,
                        style: GoogleFonts.spaceGrotesk(
                          color: textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.local_fire_department, size: 14, color: textColor),
                      const SizedBox(width: 6),
                      Text(
                        metrics != null ? '${metrics.postsToday} Posts Today' : activity,
                        style: GoogleFonts.spaceGrotesk(
                          color: textColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  if (wellness != null)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          wellness.overallTrend == 'Healthy' ? Icons.check_circle :
                          wellness.overallTrend == 'Needs Attention' ? Icons.warning : Icons.trending_up,
                          size: 14,
                          color: textColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          wellness.overallTrend,
                          style: GoogleFonts.spaceGrotesk(
                            color: textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
