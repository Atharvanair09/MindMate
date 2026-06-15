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

  String? _userSpokenText;
  String? get userSpokenText => _userSpokenText;

  void updateState(VoiceCallState newState) {
    if (_state != newState) {
      _state = newState;
      notifyListeners();
    }
  }

  void updateUserSpokenText(String text) {
    _userSpokenText = text;
    notifyListeners();
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
