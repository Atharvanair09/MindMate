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
      print("RealtimeConnectionManager: onTrack event received");
      if (event.streams.isNotEmpty && onRemoteStream != null) {
        print("RealtimeConnectionManager: Received remote stream with \${event.streams[0].getAudioTracks().length} audio tracks and \${event.streams[0].getVideoTracks().length} video tracks");
        onRemoteStream!(event.streams[0]);
      } else {
        print("RealtimeConnectionManager: Stream is empty or onRemoteStream is null");
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
      print("RealtimeConnectionManager: Data channel message received: \${message.text}");
      if (onMessageReceived != null) {
        onMessageReceived!(message.text);
      }
    };
    
    _dataChannel!.onDataChannelState = (RTCDataChannelState state) {
      print("RealtimeConnectionManager: Data channel state changed to \$state");
    };

    // Create offer
    RTCSessionDescription offer = await _peerConnection!.createOffer();
    await _peerConnection!.setLocalDescription(offer);

    // Send offer to OpenAI
    final baseUrl = "https://api.openai.com/v1/realtime";
    final model = "gpt-4o-realtime-preview-2024-12-17";
    final url = Uri.parse("\$baseUrl?model=\$model");

    print("RealtimeConnectionManager: Sending SDP offer to OpenAI...");
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer \$ephemeralToken',
        'Content-Type': 'application/sdp',
      },
      body: offer.sdp,
    );

    print("RealtimeConnectionManager: Received response from OpenAI with status code: \${response.statusCode}");

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
      print("RealtimeConnectionManager: Sending event to data channel: \$event");
      _dataChannel!.send(RTCDataChannelMessage(jsonEncode(event)));
    } else {
      print("RealtimeConnectionManager: Cannot send event, data channel is null or not open. State: \${_dataChannel?.state}");
    }
  }

  Future<void> disconnect() async {
    await _dataChannel?.close();
    await _peerConnection?.close();
    _dataChannel = null;
    _peerConnection = null;
  }
}
