import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_webrtc/flutter_webrtc.dart';

class RealtimeConnectionManager {
  RTCPeerConnection? _peerConnection;
  RTCDataChannel? _dataChannel;
  Function(MediaStream)? onRemoteStream;
  Function(String)? onMessageReceived;

  Future<void> connect(String ephemeralToken, MediaStream localStream) async {
    final configuration = {
      'iceServers': [
        {'urls': 'stun:stun.l.google.com:19302'},
      ]
    };

    _peerConnection = await createPeerConnection(configuration);

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty && onRemoteStream != null) {
        onRemoteStream!(event.streams[0]);
      }
    };

    // Add local tracks
    for (var track in localStream.getTracks()) {
      await _peerConnection!.addTrack(track, localStream);
    }

    // Create Data Channel for events
    RTCDataChannelInit dataChannelDict = RTCDataChannelInit()
      ..id = 1
      ..negotiated = false;
    _dataChannel = await _peerConnection!.createDataChannel('oai-events', dataChannelDict);
    
    _dataChannel!.onMessage = (RTCDataChannelMessage message) {
      if (onMessageReceived != null) {
        onMessageReceived!(message.text);
      }
    };

    // Create offer
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    // Send offer to OpenAI
    final baseUrl = "https://api.openai.com/v1/realtime";
    final model = "gpt-4o-realtime-preview-2024-12-17";
    final url = Uri.parse("\$baseUrl?model=\$model");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer \$ephemeralToken',
        'Content-Type': 'application/sdp',
      },
      body: offer.sdp,
    );

    if (response.statusCode == 201) {
      final answerSdp = response.body;
      final answer = RTCSessionDescription(answerSdp, 'answer');
      await _peerConnection!.setRemoteDescription(answer);
    } else {
      throw Exception("Failed to connect to OpenAI WebRTC: \${response.statusCode} \${response.body}");
    }
  }

  void sendEvent(Map<String, dynamic> event) {
    if (_dataChannel != null && _dataChannel!.state == RTCDataChannelState.RTCDataChannelOpen) {
      _dataChannel!.send(RTCDataChannelMessage(jsonEncode(event)));
    }
  }

  Future<void> disconnect() async {
    await _dataChannel?.close();
    await _peerConnection?.close();
    _dataChannel = null;
    _peerConnection = null;
  }
}
