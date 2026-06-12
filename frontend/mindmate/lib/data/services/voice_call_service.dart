import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../core/state/voice_call_state_manager.dart';
import 'audio_streaming_service.dart';
import 'realtime_connection_manager.dart';
import 'audio_route_manager.dart';

class VoiceCallService {
  final VoiceCallStateManager stateManager;
  final AudioStreamingService _audioStreaming = AudioStreamingService();
  final RealtimeConnectionManager _connectionManager = RealtimeConnectionManager();
  final AudioRouteManager _routeManager = AudioRouteManager();

  // For playback of remote audio
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  RTCVideoRenderer get renderer => _remoteRenderer;

  VoiceCallService(this.stateManager);

  Future<void> initialize() async {
    await _remoteRenderer.initialize();
    await _routeManager.initialize();

    _connectionManager.onRemoteStream = (stream) {
      _remoteRenderer.srcObject = stream;
    };

    _connectionManager.onMessageReceived = (message) {
      // Handle server events
      try {
        final data = jsonDecode(message);
        final type = data['type'];
        if (type == 'response.audio.delta' || type == 'response.audio_transcript.delta') {
          stateManager.updateState(VoiceCallState.speaking);
        } else if (type == 'input_audio_buffer.speech_started') {
          stateManager.updateState(VoiceCallState.listening);
        } else if (type == 'response.done') {
          stateManager.updateState(VoiceCallState.listening);
        }
      } catch (_) {}
    };
  }

  Future<void> startCall(String backendUrl, String authToken) async {
    try {
      stateManager.updateState(VoiceCallState.connecting);

      // 1. Get ephemeral token
      final response = await http.post(
        Uri.parse('\$backendUrl/api/v1/voice/session'),
        headers: {
          'Authorization': 'Bearer \$authToken',
        },
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to get session token");
      }

      final data = jsonDecode(response.body);
      final clientSecret = data['client_secret']['value'];

      // 2. Get local stream
      final localStream = await _audioStreaming.getLocalStream();

      // 3. Connect WebRTC
      await _connectionManager.connect(clientSecret, localStream);

      stateManager.updateState(VoiceCallState.listening);
    } catch (e) {
      stateManager.setError(e.toString());
    }
  }

  void toggleMute() {
    stateManager.toggleMute();
    _audioStreaming.setMicrophoneMuted(stateManager.isMuted);
  }

  void toggleSpeaker() {
    stateManager.toggleSpeaker();
    _routeManager.setSpeakerphoneOn(stateManager.isSpeakerOn);
  }

  Future<void> endCall() async {
    stateManager.updateState(VoiceCallState.ended);
    await _connectionManager.disconnect();
    await _audioStreaming.dispose();
    await _routeManager.dispose();
    _remoteRenderer.srcObject = null;
    await _remoteRenderer.dispose();
  }
}
