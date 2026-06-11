import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../core/constants/colors.dart';
import '../../core/state/user_provider.dart';
import '../widgets/wellness_score_card.dart';
import '../widgets/mood_selector.dart';
import '../widgets/weekly_chart.dart';
import '../widgets/check_in_card.dart';
import '../widgets/action_card.dart';
import '../widgets/bottom_nav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _animateWidget(const SizedBox(height: 20), 0),
              _animateWidget(_buildTopBar(context), 1),
              _animateWidget(const SizedBox(height: 24), 2),
              _animateWidget(
                Consumer<UserProvider>(
                  builder: (context, userProvider, child) {
                    return WellnessScoreCard(score: userProvider.wellnessScore);
                  },
                ),
                3,
              ),
              _animateWidget(const SizedBox(height: 32), 4),
              _animateWidget(const MoodSelector(), 5),
              _animateWidget(const SizedBox(height: 32), 6),
              _animateWidget(const WeeklyChart(), 7),
              _animateWidget(const SizedBox(height: 32), 8),
              _animateWidget(const CheckInCard(), 9),
              _animateWidget(const SizedBox(height: 32), 10),
              _animateWidget(
                Row(
                  children: [
                    Expanded(
                      child: ActionCard(
                        title: "Breathe",
                        subtitle: "3 min focus",
                        icon: Icons.air,
                        bgColor: AppColors.breatheBg,
                        iconColor: Colors.redAccent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ActionCard(
                        title: "Coping",
                        subtitle: "Reading",
                        icon: Icons.menu_book,
                        bgColor: AppColors.copingBg,
                        iconColor: AppColors.primaryPurple,
                      ),
                    ),
                  ],
                ),
                11,
              ),
              const SizedBox(height: 100), // Space for bottom nav
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MindMateBottomNav(currentIndex: 0),
    );
  }

  Widget _animateWidget(Widget child, int index) {
    return _FadeInOnScroll(
      key: ValueKey('home_widget_$index'),
      child: child,
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userState, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: _buildAvatarImage(userState),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: "Hey, ",
                            style: GoogleFonts.poppins(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          TextSpan(
                            text: userState.userName.isEmpty
                                ? "Friend"
                                : userState.userName,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF4B39EF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.notifications_none_outlined, color: AppColors.darkText, size: 24),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAvatarImage(UserProvider userState) {
    if (userState.localAvatarPath != null) {
      return Image.file(
        File(userState.localAvatarPath!),
        width: 44,
        height: 44,
        fit: BoxFit.cover,
      );
    }
    
    final imageUrl = userState.avatarImageUrl;
    if (imageUrl != null && imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        return Image.network(
          imageUrl,
          width: 44,
          height: 44,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(userState),
        );
      } else {
        final bytes = userState.avatarImageBytes;
        if (bytes != null) {
          return Image.memory(
            bytes,
            width: 44,
            height: 44,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(userState),
          );
        }
      }
    }

    return _buildDefaultIcon(userState);
  }

  Widget _buildDefaultIcon(UserProvider userState) {
    return Container(
      width: 44,
      height: 44,
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
          size: 22,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FadeInOnScroll extends StatefulWidget {
  final Widget child;
  const _FadeInOnScroll({super.key, required this.child});

  @override
  State<_FadeInOnScroll> createState() => _FadeInOnScrollState();
}

class _FadeInOnScrollState extends State<_FadeInOnScroll> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isVisible = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutQuart,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: widget.key!,
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.1 && !_isVisible) {
          if (mounted) {
            setState(() {
              _isVisible = true;
            });
            _controller.forward();
          }
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Opacity(
            opacity: _animation.value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - _animation.value)),
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
