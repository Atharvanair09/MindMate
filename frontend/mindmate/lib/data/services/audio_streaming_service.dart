import 'package:flutter_webrtc/flutter_webrtc.dart';

class AudioStreamingService {
  MediaStream? _localStream;

  Future<MediaStream> getLocalStream() async {
    final Map<String, dynamic> mediaConstraints = {
      'audio': true,
      'video': false,
    };

    _localStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    return _localStream!;
  }

  void setMicrophoneMuted(bool mute) {
    if (_localStream != null) {
      for (var track in _localStream!.getAudioTracks()) {
        track.enabled = !mute;
      }
    }
  }

  Future<void> dispose() async {
    if (_localStream != null) {
      for (var track in _localStream!.getTracks()) {
        await track.stop();
      }
      await _localStream!.dispose();
      _localStream = null;
    }
  }
}
