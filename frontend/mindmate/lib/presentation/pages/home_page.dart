import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/state/user_provider.dart';
import '../widgets/bottom_nav.dart';
import 'developer_debug_page.dart';
import 'insight_detail_page.dart';
import '../../domain/models/reflection_result.dart';
import '../../services/ml/reflection_engine.dart';
import '../../domain/models/daily_mood_check_in.dart';
import '../../data/database/isar_database.dart';
import 'package:isar/isar.dart';
import '../../services/notifications/notification_service.dart';
import '../../services/reflection_follow_up/reflection_follow_up_service.dart';
import '../../services/ml/feature_pipeline.dart';
import '../../services/ml/ai_insight_generator.dart';
import '../../domain/models/reflection_follow_up.dart';
import '../../domain/models/ai_insight_result.dart';
import '../../domain/models/app_notification.dart';
import 'package:intl/intl.dart';
import '../../domain/models/weekly_reflection.dart';
import '../../services/weekly_reflection/weekly_reflection_service.dart';
import 'weekly_reflection_page.dart';
import 'wellness_timeline_page.dart';
import '../../domain/models/community_wellness.dart';
import '../../services/community/community_wellness_service.dart';
import '../../domain/models/wellness_plan.dart';
import '../../services/ml/wellness_plan_generator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedMoodIndex = -1;
  ReflectionResult? _reflection;
  AiInsightResult? _aiInsight;
  WeeklyReflection? _weeklyReflection;
  bool _isLoading = true;
  DailyMoodCheckIn? _todayMood;
  ReflectionFollowUp? _activeFollowUp;
  bool _showReflectionInput = false;
  final TextEditingController _reflectionController = TextEditingController();
  List<CommunityWellness> _monitoredCommunities = [];
  WellnessPlan? _wellnessPlan;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _reflectionController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      await NotificationService.instance.requestPermissions();
      await NotificationService.instance.scheduleDailyMoodReminder();
    } catch (e) {
      debugPrint("Error in notification setup: $e");
    }

    try {
      final isar = IsarDatabase.instance;
      final now = DateTime.now();
      final todayMidnight = DateTime.utc(now.year, now.month, now.day);
      
      final todayMood = await isar.dailyMoodCheckIns
        .where()
        .dateEqualTo(todayMidnight)
        .findFirst();

      ReflectionFollowUp? activePrompt = await ReflectionFollowUpService.instance.getActiveFollowUp();
      
      if (todayMood != null && activePrompt == null) {
        try {
          final created = await ReflectionFollowUpService.instance.detectAndSaveFollowUp();
          if (created) {
            activePrompt = await ReflectionFollowUpService.instance.getActiveFollowUp();
            await NotificationService.instance.sendSmartMoodReminder();
            await ReflectionFollowUpService.instance.recordFollowUpShown();
          }
        } catch (e) {
          debugPrint("Error in reflection follow-up logic: $e");
        }
      }

      final reflection = await ReflectionEngine.instance.getLatestReflection();
      final vector = await FeaturePipeline.instance.getLatestVector();
      AiInsightResult? aiInsight;
      if (vector != null) {
        aiInsight = await AiInsightGenerator.instance.generateInsight(
          currentReflection: reflection,
          latestVector: vector,
          activeFollowUp: activePrompt,
        );
      }

      // Load weekly reflection (non-blocking, best-effort)
      WeeklyReflection? weeklyReflection;
      try {
        // Auto-generate if conditions are met
        if (await WeeklyReflectionService.instance.shouldAutoGenerate()) {
          weeklyReflection =
              await WeeklyReflectionService.instance.generateReflection();
        } else {
          weeklyReflection =
              await WeeklyReflectionService.instance.getLatestReflection();
        }
      } catch (e) {
        debugPrint('Error loading weekly reflection: $e');
      }

      final monitoredCommunities = await CommunityWellnessService.instance.getMonitoredCommunities();

      // Generate daily wellness plan dynamically
      WellnessPlan? wellnessPlan;
      try {
        wellnessPlan = await WellnessPlanGenerator.instance.generatePlan();
      } catch (e) {
        debugPrint('Error generating wellness plan: $e');
      }

      if (mounted) {
        setState(() {
          _todayMood = todayMood;
          _activeFollowUp = activePrompt;
          _reflection = reflection;
          _aiInsight = aiInsight;
          _weeklyReflection = weeklyReflection;
          _monitoredCommunities = monitoredCommunities;
          _wellnessPlan = wellnessPlan;
          _isLoading = false;
          
          if (todayMood != null) {
            final levels = ["GREAT", "GOOD", "OKAY", "LOW", "STRUGGLING"];
            _selectedMoodIndex = levels.indexOf(todayMood.moodLevel);
          } else if (reflection.moodScore != null) {
            _selectedMoodIndex = 5 - reflection.moodScore!;
          }
        });
      }
    } catch (e) {
      debugPrint("Error loading home page data: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveMood(int index, String source) async {
    final levels = ["GREAT", "GOOD", "OKAY", "LOW", "STRUGGLING"];
    final moodLevel = levels[index];
    
    final isar = IsarDatabase.instance;
    final now = DateTime.now();
    final todayMidnight = DateTime.utc(now.year, now.month, now.day);
    
    DailyMoodCheckIn moodToSave;
    
    if (_todayMood != null) {
      moodToSave = _todayMood!;
      moodToSave.moodLevel = moodLevel;
      moodToSave.updatedAt = now;
      moodToSave.source = source;
    } else {
      moodToSave = DailyMoodCheckIn()
        ..date = todayMidnight
        ..moodLevel = moodLevel
        ..createdAt = now
        ..updatedAt = now
        ..source = source;
    }
    
    await isar.writeTxn(() async {
      await isar.dailyMoodCheckIns.put(moodToSave);
    });

    // Run feature pipeline to update burnout and reflections based on new mood
    await FeaturePipeline.instance.triggerPipeline();

    if (_activeFollowUp != null) {
      await ReflectionFollowUpService.instance.markResolved(_activeFollowUp!.id);
    }

    // Evaluate reflection follow-up based on the new mood state
    try {
      await ReflectionFollowUpService.instance.detectAndSaveFollowUp();
    } catch (e) {
      debugPrint("Error detecting reflection follow-up in _saveMood: $e");
    }

    final activeFollowUp = await ReflectionFollowUpService.instance.getActiveFollowUp();
    final updatedReflection = await ReflectionEngine.instance.getLatestReflection();
    final vector = await FeaturePipeline.instance.getLatestVector();
    AiInsightResult? aiInsight;
    if (vector != null) {
      aiInsight = await AiInsightGenerator.instance.generateInsight(
        currentReflection: updatedReflection,
        latestVector: vector,
        activeFollowUp: activeFollowUp,
      );
    }
    
    // We've logged a mood today, so we can cancel the daily reminder
    await NotificationService.instance.cancelDailyMoodReminder();

    if (mounted) {
      setState(() {
        _todayMood = moodToSave;
        _selectedMoodIndex = index;
        _reflection = updatedReflection;
        _aiInsight = aiInsight;
        _activeFollowUp = activeFollowUp; // Update with the new follow-up state (can be null or a newly triggered one)
        _showReflectionInput = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8), // Light grey background
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 24),
              _buildBurnoutCard(),
              const SizedBox(height: 24),
              _buildCommunityWellnessSection(),
              const SizedBox(height: 24),
              _buildSectionTitle("HOW ARE YOU FEELING?"),
              const SizedBox(height: 12),
              if (_activeFollowUp != null) ...[
                _buildReflectionFollowUpCard(),
                const SizedBox(height: 12),
              ],
              _buildMoodSelector(),
              const SizedBox(height: 24),
              _buildActionButtons(),
              const SizedBox(height: 24),
              _buildWeeklyChart(),
              const SizedBox(height: 24),
              _buildWellnessPlanSection(),
              const SizedBox(height: 24),
              _buildSectionTitle("STUDENT RESOURCES"),
              const SizedBox(height: 12),
              _buildResourceCard(),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 0),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            final userName = userProvider.userName.isNotEmpty 
                ? userProvider.userName 
                : "Friend";
            return Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: ClipRect(
                    child: _buildAvatarImage(userProvider),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  userName.toUpperCase(),
                  style: GoogleFonts.vt323(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    letterSpacing: 1.8,
                  ),
                ),
              ],
            );
          },
        ),
        FutureBuilder<int>(
          future: NotificationService.instance.getUnreadCount(),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            return Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none, color: Colors.black, size: 28),
                  onPressed: () => _showNotificationCenter(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                if (count > 0)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Center(
                        child: Text(
                          count.toString(),
                          style: GoogleFonts.vt323(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildAvatarImage(UserProvider userState) {
    if (userState.localAvatarPath != null) {
      return Image.file(
        File(userState.localAvatarPath!),
        width: 32,
        height: 32,
        fit: BoxFit.cover,
      );
    }
    
    final imageUrl = userState.avatarImageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          width: 32,
          height: 32,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(userState),
        );
      } else {
        final bytes = userState.avatarImageBytes;
        if (bytes != null) {
          return Image.memory(
            bytes,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(userState),
          );
        }
      }
    }

    return _buildDefaultIcon(userState);
  }

  Widget _buildDefaultIcon(UserProvider userState) {
    if (userState.avatarLabel.startsWith('CyberAvatar')) {
      final index = userState.avatarLabel.replaceAll('CyberAvatar', '');
      return Image.asset(
        'assets/avatars/avatar_$index.png',
        width: 32,
        height: 32,
        fit: BoxFit.cover,
      );
    }
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: userState.avatarGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          userState.avatarIcon,
          size: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.vt323(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        letterSpacing: 3,
      ),
    );
  }

  Widget _buildBurnoutCard() {
    final score = _reflection?.burnoutScore.toString() ?? "--";
    final level = _reflection?.burnoutLevel ?? "CALC...";
    final insight = _aiInsight?.homeCardInsight ?? _reflection?.insight ?? "Analyzing your latest activity...";
    Color levelColor = Colors.greenAccent;
    if (level == 'MODERATE') levelColor = Colors.orangeAccent;
    if (level == 'HIGH') levelColor = Colors.redAccent;

    return GestureDetector(
      onTap: () {
        if (_aiInsight != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InsightDetailPage(insight: _aiInsight!),
            ),
          );
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BURNOUT RISK",
                    style: GoogleFonts.vt323(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    level,
                    style: GoogleFonts.inter(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: levelColor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    score,
                    style: GoogleFonts.spaceMono(
                      fontSize: 56,
                      fontWeight: FontWeight.w400,
                      color: Colors.yellow,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 6,
                    height: 60,
                    color: Colors.yellow,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(height: 2, color: Colors.grey[800]),
          const SizedBox(height: 12),
          Text(
            insight,
            style: GoogleFonts.vt323(
              fontSize: 18,
              color: Colors.yellow,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildCommunityWellnessSection() {
    if (_monitoredCommunities.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("COMMUNITY WELLNESS"),
        const SizedBox(height: 12),
        ..._monitoredCommunities.map((wellness) {
          Color trendColor = Colors.greenAccent;
          if (wellness.overallTrend == 'Needs Attention') trendColor = Colors.redAccent;
          if (wellness.overallTrend == 'Improving') trendColor = Colors.orangeAccent;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      wellness.communityName.toUpperCase(),
                      style: GoogleFonts.vt323(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black,
                      child: Text(
                        wellness.overallTrend.toUpperCase(),
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: trendColor,
                        ),
                      ),
                    ),
                  ],
                ),
                if (wellness.alertMessage != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    wellness.alertMessage!,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: wellness.overallTrend == 'Needs Attention' ? Colors.red[700] : Colors.black87,
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildReflectionFollowUpCard() {
    String inputPrompt = "What changed since your journal entry?";
    if (_activeFollowUp!.journalNegativeMoodMismatch) {
      inputPrompt = "Anything that improved your day?";
    } else if (_activeFollowUp!.journalPositiveMoodMismatch) {
      inputPrompt = "Anything that made things more difficult?";
    }

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(6, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "✨ REFLECTION FOLLOW-UP",
                style: GoogleFonts.vt323(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _activeFollowUp!.message,
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          if (!_showReflectionInput) ...[
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildCardButton(
                    label: "TELL ME MORE",
                    onTap: () {
                      setState(() {
                        _showReflectionInput = true;
                      });
                    },
                    backgroundColor: Colors.yellow,
                    textColor: Colors.black,
                  ),
                  const SizedBox(width: 8),
                  _buildCardButton(
                    label: "KEEP CURRENT MOOD",
                    onTap: () async {
                      await ReflectionFollowUpService.instance.markResolved(_activeFollowUp!.id);
                      setState(() {
                        _activeFollowUp = null;
                      });
                      await _loadData();
                    },
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  _buildCardButton(
                    label: "DISMISS",
                    onTap: () async {
                      await ReflectionFollowUpService.instance.markDismissed(_activeFollowUp!.id);
                      setState(() {
                        _activeFollowUp = null;
                      });
                    },
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  ),
                ],
              ),
            ),
          ] else ...[
            Text(
              inputPrompt,
              style: GoogleFonts.vt323(
                fontSize: 16,
                color: Colors.black87,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reflectionController,
              decoration: InputDecoration(
                hintText: "Type optional context...",
                hintStyle: GoogleFonts.vt323(color: Colors.grey[600], fontSize: 16),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.zero,
                  borderSide: const BorderSide(color: Colors.yellow, width: 3),
                ),
              ),
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black),
              maxLines: 2,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildCardButton(
                  label: "SAVE CONTEXT",
                  onTap: () async {
                    await ReflectionFollowUpService.instance.markResolved(
                      _activeFollowUp!.id,
                      userResponse: _reflectionController.text,
                    );
                    _reflectionController.clear();
                    setState(() {
                      _activeFollowUp = null;
                      _showReflectionInput = false;
                    });
                    await _loadData();
                  },
                  backgroundColor: Colors.yellow,
                  textColor: Colors.black,
                ),
                const SizedBox(width: 8),
                _buildCardButton(
                  label: "CANCEL",
                  onTap: () {
                    setState(() {
                      _showReflectionInput = false;
                    });
                  },
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCardButton({
    required String label,
    required VoidCallback onTap,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: Colors.black, width: 2),
        ),
        child: Text(
          label,
          style: GoogleFonts.vt323(
            fontSize: 16,
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildMoodSelector() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.black));
    }

    final moods = [
      {"emoji": "😄", "label": "GREAT"},
      {"emoji": "😊", "label": "GOOD"},
      {"emoji": "😐", "label": "OKAY"},
      {"emoji": "😔", "label": "LOW"},
      {"emoji": "🚨", "label": "BAD"},
    ];

    if (_todayMood != null) {
      final currentMood = moods.firstWhere((m) => m["label"] == _todayMood!.moodLevel, orElse: () => moods[2]);
      
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(currentMood["emoji"]!, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Mood: ${currentMood["label"]!}",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _reflection?.insight ?? "Thanks for checking in! Your mood has been recorded.",
                        style: GoogleFonts.vt323(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                setState(() {
                  _todayMood = null; // Set to null to show selector again
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: Text(
                  "CHANGE MOOD",
                  style: GoogleFonts.vt323(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(moods.length, (index) {
        final isSelected = _selectedMoodIndex == index;
        return GestureDetector(
          onTap: () {
            _saveMood(index, _activeFollowUp != null ? 'smart_prompt' : 'manual');
          },
          child: Container(
            width: (MediaQuery.of(context).size.width - 40 - 48) / 5, // Auto-size based on screen width
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.yellow : Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  offset: isSelected ? const Offset(4, 4) : const Offset(3, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  moods[index]["emoji"]!,
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 8),
                Text(
                  moods[index]["label"]!,
                  style: GoogleFonts.vt323(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ));
      }),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.yellow,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeveloperDebugPage(),
                          ),
                        );
                      },
                      child: Text(
                        "CHAT",
                        style: GoogleFonts.inter(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "talk to someone →",
                      style: GoogleFonts.vt323(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "JOURNAL",
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: Colors.yellow,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "private. on-device →",
                      style: GoogleFonts.vt323(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const WellnessTimelinePage(),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "WELLNESS TIMELINE",
                  style: GoogleFonts.inter(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "view your emotional journey →",
                  style: GoogleFonts.vt323(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 2),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black, width: 3)),
            ),
            child: Text(
              "THIS WEEK",
              style: GoogleFonts.vt323(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: Stack(
              children: [
                // Grid lines
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    4,
                    (index) => Container(
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                // Bars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBar(0.4, false),
                      _buildBar(0.7, false),
                      _buildBar(0.2, false),
                      _buildBar(0.5, false),
                      _buildBar(0.8, true), // Friday highlighted
                      _buildBar(0.4, false),
                      _buildBar(0.5, false),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"].map((day) {
              return Text(
                day,
                style: GoogleFonts.vt323(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double fillPct, bool isHighlighted) {
    return Container(
      width: 24,
      height: 120 * fillPct,
      decoration: BoxDecoration(
        color: isHighlighted ? Colors.yellow : Colors.black,
        border: isHighlighted ? Border.all(color: Colors.black, width: 1) : null,
      ),
    );
  }

  Widget _buildResourceCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.black, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(4, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            padding: const EdgeInsets.symmetric(vertical: 24),
            decoration: const BoxDecoration(
              color: Color(0xFFE0E0E0),
              border: Border(right: BorderSide(color: Colors.black, width: 2)),
            ),
            child: const Icon(Icons.menu_book, color: Colors.black, size: 32),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "EXAM ANXIETY GUIDE",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "5 MIN READ •\nSURVIVAL TIPS",
                    style: GoogleFonts.vt323(
                      fontSize: 14,
                      color: Colors.grey[600],
                      letterSpacing: 1.5,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationCenter(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (context) {
        return Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, right: 20),
            child: Material(
              color: Colors.transparent,
              child: FutureBuilder<List<AppNotification>>(
                future: NotificationService.instance.getNotifications(),
                builder: (context, snapshot) {
                  final notifications = snapshot.data ?? [];
                  return Container(
                    width: 320,
                    constraints: const BoxConstraints(
                      maxHeight: 450,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.yellow, width: 3),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.yellow,
                          offset: Offset(4, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Header
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: Colors.yellow, width: 2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "NOTIFICATIONS",
                                style: GoogleFonts.vt323(
                                  color: Colors.yellow,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              Row(
                                children: [
                                  if (notifications.any((n) => !n.read))
                                    GestureDetector(
                                      onTap: () async {
                                        await NotificationService.instance.markAllAsRead();
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                          _showNotificationCenter(context); // reload popup
                                          setState(() {}); // refresh home badge
                                        }
                                      },
                                      child: Text(
                                        "READ ALL",
                                        style: GoogleFonts.vt323(
                                          color: Colors.cyanAccent,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 12),
                                  GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const Icon(Icons.close, color: Colors.yellow, size: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // List
                        Flexible(
                          child: notifications.isEmpty
                              ? Container(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  child: Center(
                                    child: Text(
                                      "ALL CLEAR",
                                      style: GoogleFonts.vt323(
                                        color: Colors.grey,
                                        fontSize: 20,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.all(8),
                                  itemCount: notifications.length,
                                  separatorBuilder: (context, index) => Container(
                                    height: 1,
                                    color: Colors.grey[900],
                                  ),
                                  itemBuilder: (context, index) {
                                    final notification = notifications[index];
                                    IconData iconData = Icons.notifications_none;
                                    Color iconColor = Colors.white;
                                    
                                    switch (notification.type) {
                                      case 'ai_insight':
                                        iconData = Icons.auto_awesome;
                                        iconColor = Colors.yellow;
                                        break;
                                      case 'reflection_follow_up':
                                        iconData = Icons.chat_bubble_outline;
                                        iconColor = Colors.greenAccent;
                                        break;
                                      case 'burnout_alert':
                                        iconData = Icons.warning_amber;
                                        iconColor = Colors.redAccent;
                                        break;
                                      case 'mood_reminder':
                                        iconData = Icons.mood;
                                        iconColor = Colors.purpleAccent;
                                        break;
                                      case 'system':
                                        iconData = Icons.info_outline;
                                        iconColor = Colors.blueAccent;
                                        break;
                                      case 'conflict_reminder':
                                        iconData = Icons.compare_arrows;
                                        iconColor = Colors.orangeAccent;
                                        break;
                                      case 'recovery_event':
                                        iconData = Icons.trending_up;
                                        iconColor = Colors.green;
                                        break;
                                      case 'pattern_discovery':
                                        iconData = Icons.psychology;
                                        iconColor = Colors.purpleAccent;
                                        break;
                                      case 'weekly_reflection_ready':
                                        iconData = Icons.calendar_today;
                                        iconColor = Colors.cyanAccent;
                                        break;
                                      case 'group_recommendation':
                                        iconData = Icons.group;
                                        iconColor = Colors.blue;
                                        break;
                                    }

                                    final timeStr = DateFormat('h:mm a').format(notification.createdAt);

                                    return InkWell(
                                      onTap: () async {
                                        if (!notification.read) {
                                          await NotificationService.instance.markAsRead(notification.id);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                            _showNotificationCenter(context); // reload popup
                                            setState(() {}); // refresh home badge
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Icon(iconData, color: iconColor, size: 20),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(
                                                        notification.title.toUpperCase(),
                                                        style: GoogleFonts.vt323(
                                                          color: notification.read ? Colors.grey : Colors.white,
                                                          fontSize: 16,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        timeStr,
                                                        style: GoogleFonts.vt323(
                                                          color: Colors.grey,
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    notification.description,
                                                    style: GoogleFonts.inter(
                                                      color: notification.read ? Colors.grey[600] : Colors.grey[300],
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            if (!notification.read) ...[
                                              const SizedBox(width: 6),
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Colors.yellow,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildWellnessPlanSection() {
    if (_wellnessPlan == null || _wellnessPlan!.actions.isEmpty) {
      return const SizedBox.shrink();
    }

    Color statusColor = Colors.grey[700]!; // Stable
    if (_wellnessPlan!.planStatus == "Improving") statusColor = Colors.green[700]!;
    if (_wellnessPlan!.planStatus == "Needs Attention") statusColor = Colors.red[700]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: _buildSectionTitle("TODAY'S WELLNESS PLAN"),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              margin: const EdgeInsets.only(bottom: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Text(
                _wellnessPlan!.planStatus.toUpperCase(),
                style: GoogleFonts.spaceGrotesk(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(4, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TARGET: ${_wellnessPlan!.primarySituation.toUpperCase()}",
                    style: GoogleFonts.vt323(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent[700],
                      letterSpacing: 1.2,
                    ),
                  ),
                  Icon(Icons.assignment, color: Colors.blueAccent[700], size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Container(height: 2, color: Colors.grey[200]),
              const SizedBox(height: 12),
              ..._wellnessPlan!.actions.asMap().entries.map((entry) {
                int index = entry.key;
                WellnessAction action = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle completion status locally
                            _wellnessPlan!.actions[index] = action.copyWith(isCompleted: !action.isCompleted);
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 12, top: 2),
                          decoration: BoxDecoration(
                            color: action.isCompleted ? Colors.blueAccent[700] : Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: action.isCompleted 
                              ? const Icon(Icons.check, size: 16, color: Colors.white)
                              : null,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          action.text,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: action.isCompleted ? Colors.grey[500] : Colors.black87,
                            decoration: action.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }
}
