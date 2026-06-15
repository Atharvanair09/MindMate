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
      debugLogging: true,
      onStatus: (status) {
        print("Speech status changed to: $status. Current state: ${stateManager.state}");
        if (status == 'listening') {
          stateManager.updateState(VoiceCallState.listening);
        } else if (status == 'notListening' && stateManager.state == VoiceCallState.listening) {
          // Restart listening if we are supposed to be listening and not thinking/speaking
          print("Status is notListening, but we should be listening. Restarting listener...");
          _startListeningInternal();
        }
      },
      onError: (errorNotification) async {
        print("====== SPEECH ERROR ======");
        print("Error Msg: ${errorNotification.errorMsg}");
        print("Permanent: ${errorNotification.permanent}");
        print("Current App State: ${stateManager.state}");
        print("==========================");
        
        // We can restart listening on error if we are supposed to
        if (stateManager.state == VoiceCallState.listening || stateManager.state == VoiceCallState.connecting) {
            // Add a small delay to avoid rapid looping (which causes error_client and error_busy)
            print("Delaying for 500ms before restarting listener to avoid error_busy loops...");
            await Future.delayed(const Duration(milliseconds: 500));
            print("Restarting listener after error...");
            _startListeningInternal();
        }
      },
    );

    if (!available) {
      print("Speech recognition initialization failed or is not available.");
      stateManager.setError("Speech recognition is not available on this device.");
    } else {
      print("Speech recognition initialized successfully.");
    }
  }

  Future<void> startCall(String backendUrl, String authToken) async {
    try {
      print("Starting call with backendUrl: $backendUrl");
      _openRouter.setConfig(backendUrl, authToken);
      stateManager.updateState(VoiceCallState.connecting);
      await Future.delayed(const Duration(seconds: 1)); // UX delay
      _startListeningInternal();
    } catch (e) {
      print("Error in startCall: $e");
      stateManager.setError(e.toString());
    }
  }

  void _startListeningInternal() async {
    print("Attempting to start listening. Current state: ${stateManager.state}, isMuted: ${stateManager.isMuted}, isListening: ${_speech.isListening}");
    if (stateManager.isMuted) {
      print("Cannot listen: user is muted.");
      return;
    }
    if (stateManager.state == VoiceCallState.thinking || stateManager.state == VoiceCallState.speaking || stateManager.state == VoiceCallState.ended) {
      print("Cannot listen: app is in state ${stateManager.state}");
      return;
    }

    if (!_speech.isListening) {
      print("Calling _speech.listen()...");
      stateManager.updateUserSpokenText('');
      await _speech.listen(
        onResult: (result) async {
          print("Speech result: ${result.recognizedWords}, isFinal: ${result.finalResult}");
          stateManager.updateUserSpokenText(result.recognizedWords);
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
    } else {
      print("Skipped _speech.listen() because _speech.isListening is already true.");
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
