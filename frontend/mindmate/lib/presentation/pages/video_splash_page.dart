import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'home_page.dart';
import 'login_page.dart';

class VideoSplashPage extends StatefulWidget {
  final String nextRoute;

  const VideoSplashPage({super.key, required this.nextRoute});

  @override
  State<VideoSplashPage> createState() => _VideoSplashPageState();
}

class _VideoSplashPageState extends State<VideoSplashPage> {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _isNavigating = false;

  @override
  void initState() {
    super.initState();
    // Hide system UI for a true full-screen experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initializeVideo();
  }

  Future<void> _initializeVideo() async {
    _controller = VideoPlayerController.asset('assets/videos/start_video.mp4');
    try {
      await _controller.initialize();
      if (mounted) {
        // Mute audio
        await _controller.setVolume(0.0);
        await _controller.setLooping(false);
        setState(() {
          _initialized = true;
        });
        await _controller.play();
        _controller.addListener(_videoListener);
      }
    } catch (e) {
      debugPrint("Video splash error: $e");
      _navigateToNext();
    }
  }

  void _videoListener() {
    if (!mounted || _isNavigating) return;

    final value = _controller.value;
    if (!value.isInitialized) return;

    // Only check for end if it has actually reached the end of the duration
    if (value.position >= value.duration && value.duration != Duration.zero) {
      _navigateToNext();
    }
  }

  void _navigateToNext() {
    if (mounted && !_isNavigating) {
      _isNavigating = true;
      _controller.removeListener(_videoListener);
      
      // Restore system UI for the main app
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => 
              widget.nextRoute == '/home' ? const HomePage() : const LoginPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox.expand(
        child: Container(
          color: Colors.black,
          child: _initialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
