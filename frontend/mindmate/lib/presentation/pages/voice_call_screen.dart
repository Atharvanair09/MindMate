import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:provider/provider.dart';
import '../../core/state/user_provider.dart';
import '../../core/state/voice_call_state_manager.dart';
import '../../data/services/voice_call_service.dart';

class VoiceCallScreen extends StatefulWidget {
  const VoiceCallScreen({super.key});

  @override
  State<VoiceCallScreen> createState() => _VoiceCallScreenState();
}

class _VoiceCallScreenState extends State<VoiceCallScreen> with SingleTickerProviderStateMixin {
  late VoiceCallStateManager _stateManager;
  late VoiceCallService _voiceCallService;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _timer;
  int _secondsElapsed = 0;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _stateManager = VoiceCallStateManager();
    _voiceCallService = VoiceCallService(_stateManager);

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.3).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _initCall();
  }

  Future<void> _initCall() async {
    await _voiceCallService.initialize();
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isDisposed) {
        setState(() {
          _secondsElapsed++;
        });
      }
    });

    // In a real scenario, use secure storage or auth service token. 
    // Using dummy token for now if backend doesn't enforce on voice route, 
    // or the backend is configured to accept open requests for dev.
    String token = "dummy_token"; 
    String backendUrl = "https://mindmate-9jyw.onrender.com";

    await _voiceCallService.startCall(backendUrl, token);
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _pulseController.dispose();
    _voiceCallService.endCall();
    _stateManager.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final minutes = (_secondsElapsed ~/ 60).toString().padLeft(2, '0');
    final seconds = (_secondsElapsed % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1936),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _stateManager,
          builder: (context, child) {
            return Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildPulsingAvatar(),
                      const SizedBox(height: 40),
                      Text(
                        'MindMate is here.',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getStatusText(),
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                      // Dummy renderer for audio
                      SizedBox(
                        width: 0,
                        height: 0,
                        child: RTCVideoView(_voiceCallService.renderer),
                      ),
                    ],
                  ),
                ),
                _buildBottomControls(),
                const SizedBox(height: 20),
                Text(
                  "Take your time. This is a safe space for you.",
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getStatusText() {
    switch (_stateManager.state) {
      case VoiceCallState.connecting:
        return "... Connecting ...";
      case VoiceCallState.listening:
        return "... Listening ...";
      case VoiceCallState.thinking:
        return "... Thinking ...";
      case VoiceCallState.speaking:
        return "... Speaking ...";
      case VoiceCallState.error:
        return "Error: \${_stateManager.errorMessage}";
      case VoiceCallState.ended:
        return "Call Ended";
      default:
        return "";
    }
  }

  Widget _buildTopBar() {
    final userState = Provider.of<UserProvider>(context, listen: false);
    final name = userState.userName.isEmpty ? 'BlueTiger42' : userState.userName;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF2C2A4A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
            ),
          ),
          Column(
            children: [
              Text(
                name,
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                _formattedTime,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFF2C2A4A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.more_vert, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingAvatar() {
    return ScaleTransition(
      scale: (_stateManager.state == VoiceCallState.speaking || _stateManager.state == VoiceCallState.listening)
          ? _pulseAnimation
          : const AlwaysStoppedAnimation(1.0),
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              const Color(0xFFFF9A9E),
              const Color(0xFFFECFEF).withOpacity(0.5),
              const Color(0xFF1B1936),
            ],
            stops: const [0.2, 0.6, 1.0],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9A9E).withOpacity(0.3),
              blurRadius: 40,
              spreadRadius: 10,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF232142),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildControlButton(
            icon: _stateManager.isMuted ? Icons.mic_off : Icons.mic_off_outlined,
            label: 'Mute',
            color: const Color(0xFF38355C),
            iconColor: Colors.white,
            onTap: _voiceCallService.toggleMute,
          ),
          _buildControlButton(
            icon: Icons.call_end,
            label: '',
            color: const Color(0xFFD32F2F),
            iconColor: Colors.white,
            size: 64,
            onTap: () {
              _voiceCallService.endCall();
              Navigator.pop(context);
            },
          ),
          _buildControlButton(
            icon: _stateManager.isSpeakerOn ? Icons.volume_up : Icons.phone_in_talk,
            label: 'Speaker',
            color: const Color(0xFFA685FA),
            iconColor: Colors.white,
            onTap: _voiceCallService.toggleSpeaker,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required String label,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    double size = 56,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: size > 60
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                      )
                    ]
                  : null,
            ),
            child: Icon(icon, color: iconColor, size: size * 0.5),
          ),
        ),
        if (label.isNotEmpty) ...[
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ]
      ],
    );
  }
}
