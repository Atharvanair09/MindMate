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
import 'daily_diary_page.dart';
import 'wellness_timeline_page.dart';
import '../../domain/models/journal_entry.dart';
import '../../domain/models/community_wellness.dart';
import '../../services/community/community_wellness_service.dart';
import '../../domain/models/preventive_intervention_plan.dart';
import '../widgets/global_background.dart';
import '../../services/wellness/preventive_intervention_planner.dart';
import '../../domain/models/coping_tool.dart';
import '../../services/wellness/coping_toolkit_service.dart';
import '../../domain/models/detected_situation.dart';
import '../../services/ml/situation_detection_engine.dart';
import '../../domain/models/early_warning.dart';
import '../../services/wellness/early_warning_engine.dart';
import '../../domain/models/burnout_forecast.dart';
import '../../services/wellness/burnout_forecast_engine.dart';
import '../widgets/explainable_ai_dashboard.dart';
import '../widgets/expandable_smart_card.dart';
import '../widgets/continuous_mood_selector.dart';

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
  PreventiveInterventionPlan? _preventivePlan;
  List<CopingTool> _recommendedTools = [];
  EarlyWarningAlert? _earlyWarning;

  // Explainable AI State
  BurnoutForecast? _burnoutForecast;
  List<DetectedSituation> _detectedSituations = [];

  bool _isTodayJournalWritten = false;
  List<bool> _weeklyJournalStreak = List.filled(7, false);

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

      ReflectionFollowUp? activePrompt =
          await ReflectionFollowUpService.instance.getActiveFollowUp();

      if (todayMood != null && activePrompt == null) {
        try {
          final created =
              await ReflectionFollowUpService.instance.detectAndSaveFollowUp();
          if (created) {
            activePrompt =
                await ReflectionFollowUpService.instance.getActiveFollowUp();
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

      final monitoredCommunities =
          await CommunityWellnessService.instance.getMonitoredCommunities();

      // Generate daily wellness plan dynamically
      PreventiveInterventionPlan? preventivePlan;
      List<CopingTool> recommendedTools = [];
      List<DetectedSituation> situations = [];
      try {
        preventivePlan = await PreventiveInterventionPlanner.instance.generatePlan();
        situations = await SituationDetectionEngine.instance.detectSituations();
        if (situations.isNotEmpty) {
          recommendedTools = CopingToolkitService.instance
              .getRecommendedTools(situations.first);
        } else {
          recommendedTools = CopingToolkitService.instance
              .getRecommendedTools(DetectedSituation(
            situationName: "General",
            confidence: 100,
            evidenceUsed: [],
            reason: "",
            keywordsTriggered: [],
            generatedAt: DateTime.now(),
          ));
        }
      } catch (e) {
        debugPrint('Error generating wellness plan: $e');
      }

      EarlyWarningAlert? earlyWarning;
      try {
        earlyWarning =
            await EarlyWarningEngine.instance.evaluateWarningStatus();
      } catch (e) {
        debugPrint('Error evaluating early warning: $e');
      }

      BurnoutForecast? burnoutForecast;
      try {
        burnoutForecast =
            await BurnoutForecastEngine.instance.getDailyForecast();
      } catch (e) {
        debugPrint('Error getting burnout forecast: $e');
      }

      bool isTodayJournalWritten = false;
      List<bool> weeklyJournalStreak = List.filled(7, false);
      try {
        final now = DateTime.now();
        final todayMidnight = DateTime(now.year, now.month, now.day);
        
        // 1. We will use the weekly journal streak to check if today's journal is written.

        // 2. Fetch weekly journal streak (last 7 days, including today)
        final startLimit = now.subtract(const Duration(days: 6));
        final startLimitMidnight = DateTime(startLimit.year, startLimit.month, startLimit.day);
        final weeklyJournals = await isar.journalEntrys
            .filter()
            .isDeletedEqualTo(false)
            .and()
            .journalDateBetween(startLimitMidnight, now)
            .findAll();

        weeklyJournalStreak = List.generate(7, (index) {
          final dateToCheck = startLimitMidnight.add(Duration(days: index));
          return weeklyJournals.any((j) =>
              j.journalDate.year == dateToCheck.year &&
              j.journalDate.month == dateToCheck.month &&
              j.journalDate.day == dateToCheck.day &&
              (j.content.trim().isNotEmpty || (j.pagesJson != null && j.pagesJson!.contains('"imagePath"'))));
        });
        
        isTodayJournalWritten = weeklyJournalStreak.last;
      } catch (e) {
        debugPrint('Error loading journal streak/status: $e');
      }

      if (mounted) {
        setState(() {
          _todayMood = todayMood;
          _activeFollowUp = activePrompt;
          _reflection = reflection;
          _aiInsight = aiInsight;
          _weeklyReflection = weeklyReflection;
          _monitoredCommunities = monitoredCommunities;
          _preventivePlan = preventivePlan;
          _recommendedTools = recommendedTools;
          _earlyWarning = earlyWarning;
          _burnoutForecast = burnoutForecast;
          _detectedSituations = situations;
          _isTodayJournalWritten = isTodayJournalWritten;
          _weeklyJournalStreak = weeklyJournalStreak;
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
      await ReflectionFollowUpService.instance
          .markResolved(_activeFollowUp!.id);
    }

    // Evaluate reflection follow-up based on the new mood state
    try {
      await ReflectionFollowUpService.instance.detectAndSaveFollowUp();
    } catch (e) {
      debugPrint("Error detecting reflection follow-up in _saveMood: $e");
    }

    final activeFollowUp =
        await ReflectionFollowUpService.instance.getActiveFollowUp();
    final updatedReflection =
        await ReflectionEngine.instance.getLatestReflection();
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
        _activeFollowUp =
            activeFollowUp; // Update with the new follow-up state (can be null or a newly triggered one)
        _showReflectionInput = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA), // Brighter variant of white
      body: GlobalBackgroundLayer(
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 24, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: _buildGreeting(context)),
                          if (_earlyWarning != null &&
                              _earlyWarning!.level != "Green")
                             _buildEarlyWarningCard(),
                        ],
                      ),
                      const SizedBox(height: 24),
                      _buildBurnoutCard(),
                      const SizedBox(height: 24),
                      _buildSectionTitle("HOW ARE YOU FEELING?"),
                      const SizedBox(height: 12),
                      if (_activeFollowUp != null) ...[
                        _buildReflectionFollowUpCard(),
                        const SizedBox(height: 12),
                      ],
                      _buildMoodSelector(),
                      const SizedBox(height: 24),
                      _buildColorfulButtons(),
                      const SizedBox(height: 24),
                      _buildWeeklyChart(),
                      const SizedBox(height: 24),
                      _buildWellnessPlanSection(),
                      const SizedBox(height: 50), // Space for bottom nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 0),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 44, bottom: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.black, width: 3.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 46),
          Text(
            "HOME",
            style: GoogleFonts.bebasNeue(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
              letterSpacing: 2.0,
            ),
          ),
          FutureBuilder<int>(
            future: NotificationService.instance.getUnreadCount(),
            builder: (context, snapshot) {
              final count = snapshot.data ?? 0;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(Icons.notifications_none,
                        color: Colors.black, size: 28),
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
      ),
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
          errorBuilder: (context, error, stackTrace) =>
              _buildDefaultIcon(userState),
        );
      } else {
        final bytes = userState.avatarImageBytes;
        if (bytes != null) {
          return Image.memory(
            bytes,
            width: 32,
            height: 32,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) =>
                _buildDefaultIcon(userState),
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
      style: GoogleFonts.bebasNeue(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        color: Colors.black,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildBurnoutCard() {
    final score = _reflection?.burnoutScore.toString() ?? "--";
    final level = _reflection?.burnoutLevel ?? "CALC...";
    final insight = _aiInsight?.homeCardInsight ??
        _reflection?.insight ??
        "Analyzing your latest activity...";
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
                color: Colors.cyanAccent, // Brighter cyan shadow
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
                  fontSize: 20,
                  color: Colors.cyanAccent,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ));
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
        color: const Color(0xFF00E5FF), // Brighter cyber cyan
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
                style: GoogleFonts.bebasNeue(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: 2,
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildCardButton(
                        label: "TELL ME MORE",
                        onTap: () {
                          setState(() {
                            _showReflectionInput = true;
                          });
                        },
                        backgroundColor: Colors.yellow,
                        textColor: Colors.black,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _buildCardButton(
                        label: "KEEP MOOD",
                        onTap: () async {
                          await ReflectionFollowUpService.instance
                              .markResolved(_activeFollowUp!.id);
                          setState(() {
                            _activeFollowUp = null;
                          });
                          await _loadData();
                        },
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                _buildCardButton(
                  label: "DISMISS",
                  onTap: () async {
                    await ReflectionFollowUpService.instance
                        .markDismissed(_activeFollowUp!.id);
                    setState(() {
                      _activeFollowUp = null;
                    });
                  },
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                ),
              ],
            ),
          ] else ...[
            Text(
              inputPrompt,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _reflectionController,
              decoration: InputDecoration(
                hintText: "Type optional context...",
                hintStyle:
                    GoogleFonts.vt323(color: Colors.grey[600], fontSize: 16),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                Expanded(
                  child: _buildCardButton(
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
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildCardButton(
                    label: "CANCEL",
                    onTap: () {
                      setState(() {
                        _showReflectionInput = false;
                      });
                    },
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                  ),
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
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.vt323(
              fontSize: 20,
              color: textColor,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ),
    );
  }

  Color _getMoodColor(String label) {
    switch (label.toUpperCase()) {
      case 'GREAT':
        return const Color(0xFF4CAF50); // Green
      case 'GOOD':
        return const Color(0xFF8BC34A); // Light Green/Lime
      case 'OKAY':
        return const Color(0xFFFFB300); // Yellow/Orange
      case 'LOW':
        return const Color(0xFFFF9800); // Orange
      case 'BAD':
      case 'STRUGGLING':
        return const Color(0xFFE53935); // Red
      default:
        return Colors.white;
    }
  }

  Color _getMoodTextColor(String label) {
    switch (label.toUpperCase()) {
      case 'GREAT':
      case 'LOW':
      case 'BAD':
      case 'STRUGGLING':
        return Colors.white;
      case 'GOOD':
      case 'OKAY':
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  Widget _buildMoodSelector() {
    if (_isLoading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.black));
    }

    return ContinuousMoodSelector(
      todayMood: _todayMood,
      insightText: _reflection?.insight ??
          "Thanks for checking in! Your mood has been recorded.",
      onMoodSelected: (index) {
        _saveMood(
            index, _activeFollowUp != null ? 'smart_prompt' : 'manual');
      },
      onChangeMood: () {
        setState(() {
          _todayMood = null;
        });
      },
    );
  }

  Widget _buildWeeklyChart() {
    List<double> weeklyBurnout = List.filled(7, 0.0);
    int todayIndex = DateTime.now().weekday - 1;
    String trendText = "ANALYZING TREND...";

    if (_burnoutForecast != null) {
      weeklyBurnout[todayIndex] = _burnoutForecast!.currentBurnout;
      
      int historyCount = _burnoutForecast!.historicalScores.length;
      for (int i = 1; i <= todayIndex; i++) {
        int historyIndex = historyCount - i;
        if (historyIndex >= 0) {
          weeklyBurnout[todayIndex - i] = _burnoutForecast!.historicalScores[historyIndex];
        } else {
          weeklyBurnout[todayIndex - i] = 0.0;
        }
      }

      for (int i = todayIndex + 1; i < 7; i++) {
        int daysAhead = i - todayIndex;
        if (daysAhead == 1) {
          weeklyBurnout[i] = _burnoutForecast!.forecastTomorrow;
        } else if (daysAhead <= 3) {
          weeklyBurnout[i] = _burnoutForecast!.forecast3Days;
        } else {
          weeklyBurnout[i] = _burnoutForecast!.forecast7Days;
        }
      }
      
      trendText = _burnoutForecast!.trend.toUpperCase();
    } else {
      // Dummy data if no forecast
      weeklyBurnout = [40, 70, 20, 50, 80, 40, 50];
    }

    Color trendColor = Colors.black;
    if (trendText.contains("INCREASING")) trendColor = Colors.redAccent;
    else if (trendText.contains("DECREASING")) trendColor = Colors.greenAccent;
    else if (trendText.contains("STABLE")) trendColor = Colors.orangeAccent;

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
              "THIS WEEK - BURNOUT RISK",
              style: GoogleFonts.vt323(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                // Grid lines
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (index) => Container(
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                ),
                // Bars
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: List.generate(7, (index) {
                      double val = weeklyBurnout[index].clamp(0, 100);
                      return _buildBar(val / 100.0, index == todayIndex, val.toInt());
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"].map((day) {
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
          const SizedBox(height: 20),
          // AI Insight
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_graph, color: trendColor, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "TREND: $trendText",
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(double fillPct, bool isHighlighted, int value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          value.toString(),
          style: GoogleFonts.vt323(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 24,
          height: 100 * fillPct,
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.yellow : Colors.black,
            border:
                isHighlighted ? Border.all(color: Colors.black, width: 1) : null,
          ),
        ),
      ],
    );
  }

  Widget _buildCopingToolkit() {
    if (_recommendedTools.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      children: _recommendedTools.map((tool) {
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
          child: Row(
            children: [
              Container(
                width: 80,
                padding: const EdgeInsets.symmetric(vertical: 24),
                decoration: const BoxDecoration(
                  color: Color(0xFFE0E0E0),
                  border:
                      Border(right: BorderSide(color: Colors.black, width: 2)),
                ),
                child: Icon(_getIconData(tool.iconName),
                    color: Colors.black, size: 32),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tool.name.toUpperCase(),
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        tool.description.toUpperCase(),
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
      }).toList(),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'timer':
        return Icons.timer;
      case 'list_alt':
        return Icons.list_alt;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'air':
        return Icons.air;
      case 'checklist':
        return Icons.checklist;
      case 'book':
        return Icons.book;
      case 'nightlight_round':
        return Icons.nightlight_round;
      case 'tips_and_updates':
        return Icons.tips_and_updates;
      case 'edit_note':
        return Icons.edit_note;
      case 'chat_bubble_outline':
        return Icons.chat_bubble_outline;
      case 'people_outline':
        return Icons.people_outline;
      default:
        return Icons.build;
    }
  }

  Widget _buildGreeting(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final userName = userProvider.userName.isNotEmpty
            ? userProvider.userName.toUpperCase()
            : "FRIEND";

        final now = DateTime.now();
        final formattedDate =
            DateFormat('EEEE, MMM d').format(now).toUpperCase();

        String greeting = "GOOD MORNING";
        if (now.hour >= 12 && now.hour < 17) {
          greeting = "GOOD AFTERNOON";
        } else if (now.hour >= 17) {
          greeting = "GOOD EVENING";
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$greeting,\n$userName",
              style: GoogleFonts.bebasNeue(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.0,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formattedDate,
              style: GoogleFonts.bebasNeue(
                fontSize: 16,
                color: Colors.grey[600],
                letterSpacing: 1.0,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEarlyWarningCard() {
    return Align(
        alignment: Alignment.centerRight,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.yellow,
            border: Border.all(color: Colors.black, width: 2),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(2, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: Icon(
              _earlyWarning!.level == "Red"
                  ? Icons.warning
                  : Icons.warning_amber,
              color: Colors.black,
              size: 28,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: const Color(0xFFF8F8F8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.black, width: 2),
                  ),
                  title: Text(
                    "EARLY WARNING",
                    style: GoogleFonts.vt323(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      letterSpacing: 2,
                    ),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _earlyWarning!.reasons.map((reason) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("•",
                                style: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                reason,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "CLOSE",
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: const BoxDecoration(
                            border: Border(
                                bottom:
                                    BorderSide(color: Colors.yellow, width: 2)),
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
                                        await NotificationService.instance
                                            .markAllAsRead();
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                          _showNotificationCenter(
                                              context); // reload popup
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
                                    child: const Icon(Icons.close,
                                        color: Colors.yellow, size: 20),
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 40),
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
                                  separatorBuilder: (context, index) =>
                                      Container(
                                    height: 1,
                                    color: Colors.grey[900],
                                  ),
                                  itemBuilder: (context, index) {
                                    final notification = notifications[index];
                                    IconData iconData =
                                        Icons.notifications_none;
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

                                    final timeStr = DateFormat('h:mm a')
                                        .format(notification.createdAt);

                                    return InkWell(
                                      onTap: () async {
                                        if (!notification.read) {
                                          await NotificationService.instance
                                              .markAsRead(notification.id);
                                          if (context.mounted) {
                                            Navigator.of(context).pop();
                                            _showNotificationCenter(
                                                context); // reload popup
                                            setState(
                                                () {}); // refresh home badge
                                          }
                                        }
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 4),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(iconData,
                                                color: iconColor, size: 20),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        notification.title
                                                            .toUpperCase(),
                                                        style:
                                                            GoogleFonts.vt323(
                                                          color: notification
                                                                  .read
                                                              ? Colors.grey
                                                              : Colors.white,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      Text(
                                                        timeStr,
                                                        style:
                                                            GoogleFonts.vt323(
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
                                                      color: notification.read
                                                          ? Colors.grey[600]
                                                          : Colors.grey[300],
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
    if (_preventivePlan == null || _preventivePlan!.actions.isEmpty) {
      return const SizedBox.shrink();
    }

    Color statusColor = Colors.grey[700]!; // Stable
    if (_preventivePlan!.forecastTrend == "Improving") {
      statusColor = Colors.green[700]!;
    }
    if (_preventivePlan!.forecastTrend == "Needs Attention") {
      statusColor = Colors.red[700]!;
    }

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
                _preventivePlan!.forecastTrend.toUpperCase(),
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
              ..._preventivePlan!.actions.asMap().entries.map((entry) {
                int index = entry.key;
                var action = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            // Toggle completion status locally
                            _preventivePlan!.actions[index] = action.copyWith(
                                isCompleted: !action.isCompleted);
                          });
                        },
                        child: Container(
                          width: 24,
                          height: 24,
                          margin: const EdgeInsets.only(right: 12, top: 2),
                          decoration: BoxDecoration(
                            color: action.isCompleted
                                ? Colors.blueAccent[700]
                                : Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: action.isCompleted
                              ? const Icon(Icons.check,
                                  size: 16, color: Colors.white)
                              : null,
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              action.text,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: action.isCompleted
                                    ? Colors.grey[500]
                                    : Colors.black87,
                                decoration: action.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            if (action.explanation.isNotEmpty && !action.isCompleted) ...[
                              const SizedBox(height: 4),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.auto_awesome, color: Colors.yellow[800], size: 14),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      action.explanation,
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ],
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

  Widget _buildWeeklyStreakGraph() {
    final now = DateTime.now();
    final startLimit = now.subtract(const Duration(days: 6));
    final startLimitMidnight = DateTime(startLimit.year, startLimit.month, startLimit.day);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        border: Border.all(color: Colors.black, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "WEEKLY STREAK",
            style: GoogleFonts.vt323(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final date = startLimitMidnight.add(Duration(days: index));
              final dayLabel = DateFormat('E').format(date).toUpperCase().substring(0, 1);
              final isWritten = _weeklyJournalStreak[index];
              final isToday = index == 6;

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: isWritten
                          ? Colors.black
                          : Colors.white,
                      border: Border.all(
                        color: Colors.black,
                        width: isToday ? 2.5 : 1.5,
                      ),
                    ),
                    child: Center(
                      child: isWritten
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    dayLabel,
                    style: GoogleFonts.vt323(
                      fontSize: 16,
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? Colors.black : Colors.black87,
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildColorfulButtons() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ExpandableSmartCard(
              id: 'journal_btn',
              backgroundColor: const Color(0xFFFF9FF3), // Pink
              padding: const EdgeInsets.symmetric(horizontal: 20),
              collapsedChild: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.book, size: 28, color: Colors.black),
                    const SizedBox(height: 8),
                    Text(
                      "JOURNAL",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              expandedChild: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.book, size: 32, color: Colors.black),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "PRIVATE JOURNAL",
                            style: GoogleFonts.bebasNeue(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildWeeklyStreakGraph(),
                    const SizedBox(height: 12),
                    Text(
                      _isTodayJournalWritten
                          ? "Feel like talking more?"
                          : "What's on your mind today?",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DailyDiaryPage(),
                            ),
                          ).then((_) {
                            _loadData();
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              _isTodayJournalWritten ? "EDIT ENTRY" : "NEW ENTRY",
                              style: GoogleFonts.vt323(
                                fontSize: 22,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ExpandableSmartCard(
              id: 'community_wellness_btn',
              backgroundColor: const Color(0xFF48DBFB), // Blue
              padding: const EdgeInsets.symmetric(horizontal: 20),
              collapsedChild: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people, size: 28, color: Colors.black),
                    const SizedBox(height: 8),
                    Text(
                      "COMMUNITY\nWELLNESS",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              expandedChild: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Community Wellness",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ..._monitoredCommunities.map((wellness) {
                      Color trendColor = Colors.greenAccent;
                      if (wellness.overallTrend == 'Needs Attention') {
                        trendColor = Colors.redAccent;
                      }
                      if (wellness.overallTrend == 'Improving') {
                        trendColor = Colors.orangeAccent;
                      }

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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
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
                                  color: wellness.overallTrend == 'Needs Attention'
                                      ? Colors.red[700]
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ExpandableSmartCard(
              id: 'wellness_timeline_btn',
              backgroundColor: const Color(0xFF1DD1A1), // Green
              padding: const EdgeInsets.symmetric(horizontal: 20),
              collapsedChild: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.timeline, size: 28, color: Colors.black),
                    const SizedBox(height: 8),
                    Text(
                      "WELLNESS\nTIMELINE",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.bebasNeue(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              expandedChild: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Emotional Journey",
                      style: GoogleFonts.bebasNeue(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Track how your burnout risk and sentiment change daily.",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const WellnessTimelinePage(),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: Center(
                            child: Text(
                              "OPEN FULL TIMELINE",
                              style: GoogleFonts.vt323(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorfulButton({
    required String title,
    required IconData icon,
    required Color color,
    required Color shadowColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Colors.black, width: 2),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 28, color: Colors.black),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.bebasNeue(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
