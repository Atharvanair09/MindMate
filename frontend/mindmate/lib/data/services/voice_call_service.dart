import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import '../../core/state/voice_call_state_manager.dart';
import 'openrouter_service.dart';

class VoiceCallService {
  final VoiceCallStateManager stateManager;
  final OpenRouterService _openRouter = OpenRouterService();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _tts = FlutterTts();

  VoiceCallService(this.stateManager);

  Future<void> initialize() async {
    await _tts.setLanguage("en-US");
    await _tts.setSpeechRate(0.5);
    await _tts.setVolume(1.0);
    await _tts.setPitch(1.0);
    
    // Setting iOS specific TTS audio session options for speaker routing
    await _tts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playAndRecord,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers,
        IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
      ],
    );

    bool available = await _speech.initialize(
      onStatus: (status) {
        if (status == 'listening') {
          stateManager.updateState(VoiceCallState.listening);
        } else if (status == 'notListening' && stateManager.state == VoiceCallState.listening) {
          // Restart listening if we are supposed to be listening and not thinking/speaking
          _startListeningInternal();
        }
      },
      onError: (errorNotification) {
        print("Speech error: \${errorNotification.errorMsg}");
        // We can restart listening on error if we are supposed to
        if (stateManager.state == VoiceCallState.listening || stateManager.state == VoiceCallState.connecting) {
            _startListeningInternal();
        }
      },
    );

    if (!available) {
      stateManager.setError("Speech recognition is not available on this device.");
    }
  }

  Future<void> startCall(String backendUrl, String authToken) async {
    try {
      _openRouter.setConfig(backendUrl, authToken);
      stateManager.updateState(VoiceCallState.connecting);
      await Future.delayed(const Duration(seconds: 1)); // UX delay
      _startListeningInternal();
    } catch (e) {
      stateManager.setError(e.toString());
    }
  }

  void _startListeningInternal() async {
    if (stateManager.isMuted) return;
    if (stateManager.state == VoiceCallState.thinking || stateManager.state == VoiceCallState.speaking || stateManager.state == VoiceCallState.ended) return;

    if (!_speech.isListening) {
      await _speech.listen(
        onResult: (result) async {
          if (result.finalResult && result.recognizedWords.isNotEmpty) {
            _handleUserSpeech(result.recognizedWords);
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: false,
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
      );
      stateManager.updateState(VoiceCallState.listening);
    }
  }

  Future<void> _handleUserSpeech(String text) async {
    // Interrupt any ongoing speech
    await _tts.stop();

    stateManager.updateState(VoiceCallState.thinking);
    
    // Stop listening temporarily while thinking/speaking
    if (_speech.isListening) {
      await _speech.stop();
    }

    final response = await _openRouter.sendMessage(text);

    if (response.isNotEmpty) {
      stateManager.updateState(VoiceCallState.speaking);
      
      _tts.setCompletionHandler(() {
        if (stateManager.state != VoiceCallState.ended) {
          _startListeningInternal();
        }
      });
      
      await _tts.speak(response);
    } else {
      _startListeningInternal();
    }
  }

  void toggleMute() {
    stateManager.toggleMute();
    if (stateManager.isMuted) {
      _speech.stop();
    } else {
      _startListeningInternal();
    }
  }

  void toggleSpeaker() {
    stateManager.toggleSpeaker();
    // FlutterTTS respects device settings. A true speaker toggle might require audio_session 
    // but since we removed it, we just toggle the UI state.
  }

  Future<void> endCall() async {
    stateManager.updateState(VoiceCallState.ended);
    await _speech.stop();
    await _tts.stop();
  }
}
