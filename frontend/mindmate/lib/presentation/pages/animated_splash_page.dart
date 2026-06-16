import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'home_page.dart';

class AnimatedSplashPage extends StatefulWidget {
  final String nextRoute;

  const AnimatedSplashPage({super.key, required this.nextRoute});

  @override
  State<AnimatedSplashPage> createState() => _AnimatedSplashPageState();
}

class _AnimatedSplashPageState extends State<AnimatedSplashPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleUpAnim;
  late Animation<double> splitAnim;
  late Animation<double> underlineAnim;
  late Animation<double> zoomOutAnim;
  late Animation<double> alignAnim;
  late Animation<double> fadeUIAnim;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 6500));

    scaleUpAnim = Tween<double>(begin: 0.35, end: 0.45).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.18, curve: Curves.easeOutCubic))
    );

    splitAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.18, 0.36, curve: Curves.easeInOutExpo))
    );

    underlineAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.18, 0.36, curve: Curves.easeOutCubic))
    );

    zoomOutAnim = Tween<double>(begin: 0.45, end: 0.75).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.73, curve: Curves.easeInOutCubic))
    );

    alignAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.55, 0.73, curve: Curves.easeInOutCubic))
    );

    fadeUIAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.64, 1.0, curve: Curves.easeIn))
    );

    _controller.forward().then((_) {
      if (widget.nextRoute == '/home' && mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const HomePage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      } else if (mounted) {
        // If it's login, we restore system UI and stay on this page to let user interact with buttons
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isLogin = widget.nextRoute == '/login';

    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double currentScale = 1.0;
            if (_controller.value <= 0.18) {
              currentScale = scaleUpAnim.value;
            } else if (_controller.value <= 0.55) {
              currentScale = 0.45;
            } else {
              currentScale = zoomOutAnim.value;
            }

            bool isBold = _controller.value >= 0.18;
            String t1 = isBold ? "MIND" : "Mind";
            String t2 = isBold ? "MATE" : "Mate";
            Color color = isBold ? const Color(0xFFFFD700) : Colors.white;
            double letterSpacing = isBold ? 3.0 : 0.0;
            
            TextStyle mainStyle = isBold 
                ? GoogleFonts.anton(fontSize: 160, color: color, height: 1.0, letterSpacing: letterSpacing)
                : GoogleFonts.spaceGrotesk(fontSize: 160, fontWeight: FontWeight.w400, color: color, height: 1.0, letterSpacing: letterSpacing);

            return Stack(
              children: [
                // Central Animated Text
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 28.0 * alignAnim.value),
                    child: Transform.scale(
                      scale: currentScale,
                      alignment: Alignment(-alignAnim.value, 0),
                      child: Transform.translate(
                        offset: Offset(-180.0 * (1 - splitAnim.value), 0),
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          clipBehavior: Clip.none,
                          children: [
                            // Underline
                            Container(
                              width: 400.0 * underlineAnim.value,
                              height: 16.0,
                              color: const Color(0xFFFFD700),
                            ),
                            // MIND
                            Transform.translate(
                              offset: Offset(
                                0,
                                -90.0 * splitAnim.value,
                              ),
                              child: Text(t1, style: mainStyle),
                            ),
                            // MATE
                            Transform.translate(
                              offset: Offset(
                                360.0 * (1 - splitAnim.value),
                                90.0 * splitAnim.value,
                              ),
                              child: Text(t2, style: mainStyle),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // The UI elements that fade in (only if isLogin)
                if (isLogin)
                  Opacity(
                    opacity: fadeUIAnim.value,
                    child: IgnorePointer(
                      ignoring: fadeUIAnim.value < 0.9,
                      child: Stack(
                        children: [
                          // Top Left Text
                          Positioned(
                            top: 60,
                            left: 24,
                            child: Text(
                              "MINDMATE v1.0",
                              style: GoogleFonts.spaceGrotesk(color: const Color(0xFFBDBDBD), fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                            ),
                          ),
                          // Top Right Ribbon
                          Positioned(
                            top: 20,
                            right: -40,
                            child: Transform.rotate(
                              angle: 0.785398, // ~45 deg
                              child: Container(
                                color: const Color(0xFFFFD700),
                                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 6),
                                child: Text(
                                  "      STAY AWAKE",
                                  style: GoogleFonts.spaceGrotesk(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.2),
                                ),
                              ),
                            ),
                          ),
                          // Center Subtitle
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 28.0),
                              child: Transform.translate(
                                offset: const Offset(0, 150),
                                child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(left: BorderSide(color: Colors.white, width: 5)),
                                ),
                                padding: const EdgeInsets.only(left: 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("AN HONEST COMPANION.", style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.1)),
                                    Text("NO PRETENDING.", style: GoogleFonts.spaceGrotesk(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.1)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ),
                          // Buttons
                          Positioned(
                            bottom: 80,
                            left: 24,
                            right: 24,
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.pushReplacementNamed(context, '/login');
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          top: 6, left: 6, right: -6, bottom: -6,
                                          child: Container(color: const Color(0xFFFFD700)),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            border: Border.all(color: Colors.white, width: 2),
                                          ),
                                          child: Center(
                                            child: Text("GET STARTED", style: GoogleFonts.spaceGrotesk(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      context.read<AuthViewModel>().startRecoveryFlow();
                                      Navigator.pushReplacementNamed(context, '/login');
                                    },
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        Positioned(
                                          top: 6, left: 6, right: -6, bottom: -6,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.black,
                                              border: Border.all(color: const Color(0xFFFFD700), width: 1.5),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(vertical: 18),
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFFD700),
                                          ),
                                          child: Center(
                                            child: Text("RESTORE ACCESS", style: GoogleFonts.spaceGrotesk(color: Colors.black, fontWeight: FontWeight.w700, fontSize: 14, letterSpacing: 0.5)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Bottom Text
                          Positioned(
                            bottom: 30,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Text(
                                "NO EMAIL STORED. NO NAME COLLECTED. EVER.",
                                style: GoogleFonts.spaceGrotesk(color: const Color(0xFF555555), fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
