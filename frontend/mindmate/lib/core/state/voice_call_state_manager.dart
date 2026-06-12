import 'package:flutter/material.dart';

enum VoiceCallState {
  connecting,
  listening,
  thinking,
  speaking,
  reconnecting,
  ended,
  error,
}

class VoiceCallStateManager extends ChangeNotifier {
  VoiceCallState _state = VoiceCallState.connecting;
  VoiceCallState get state => _state;

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  bool _isSpeakerOn = true;
  bool get isSpeakerOn => _isSpeakerOn;
  
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void updateState(VoiceCallState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  void setError(String message) {
    _errorMessage = message;
    updateState(VoiceCallState.error);
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void toggleSpeaker() {
    _isSpeakerOn = !_isSpeakerOn;
    notifyListeners();
  }
}
