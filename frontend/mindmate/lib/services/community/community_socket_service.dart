import 'dart:io';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'community_membership_service.dart';
import '../../domain/models/anonymous_post.dart';
import '../privacy/pseudonymization_service.dart';

class CommunitySocketService {
  CommunitySocketService._();
  static final CommunitySocketService instance = CommunitySocketService._();

  IO.Socket? _socket;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  // Stream controllers to broadcast messages
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  bool _initialized = false;
  String? _currentActiveCommunity;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // Initialize local notifications
    const initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    const initializationSettingsIOS = DarwinInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
    );

    // Connect to the Render backend
    String url = 'https://mindmate-9jyw.onrender.com';

    _socket = IO.io(url, IO.OptionBuilder()
      .setTransports(['websocket']) // for Flutter or Web
      .disableAutoConnect()  // disable auto-connection
      .build()
    );

    _socket!.connect();

    _socket!.onConnect((_) async {
      print('[CommunitySocket] Connected to Socket.IO Server');
      // Join all communities the user is part of
      final joined = await CommunityMembershipService.instance.getJoinedCommunities();
      for (var community in joined) {
        joinCommunity(community.communityName);
      }
    });

    _socket!.on('new_message', (data) {
      final Map<String, dynamic> mappedData = data is Map ? Map<String, dynamic>.from(data) : data;
      _messageController.add(mappedData);
      
      String communityId = mappedData['communityId'];
      String alias = data['anonymousAlias'];
      
      // If the user is not actively viewing this community, show a notification
      if (_currentActiveCommunity != communityId) {
        _showNotification(
          communityId, 
          'New activity in $communityId', 
          'Someone replied or sent a new message.'
        );
      }
    });

    _socket!.onDisconnect((_) => print('[CommunitySocket] Disconnected'));
  }

  void setActiveCommunity(String? communityName) {
    _currentActiveCommunity = communityName;
  }

  void joinCommunity(String communityId) {
    if (_socket?.connected == true) {
      _socket!.emit('join_community', {'communityId': communityId});
    }
  }

  void leaveCommunity(String communityId) {
    if (_socket?.connected == true) {
      _socket!.emit('leave_community', {'communityId': communityId});
    }
  }

  Future<void> _showNotification(String communityId, String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'community_channel_id',
      'Community Notifications',
      channelDescription: 'Notifications for community activity',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(),
    );
    
    // Use a unique ID based on community string hash
    await _localNotificationsPlugin.show(
      id: communityId.hashCode,
      title: title,
      body: body,
      notificationDetails: platformChannelSpecifics,
      payload: communityId,
    );
  }

  Future<Map<String, dynamic>> sendMessage({
    required String communityId,
    required String senderId, // user's uuid or local generic id
    required String originalText,
    String? replyTarget,
  }) async {
    if (_socket == null) return {'success': false, 'error': 'Socket is not initialized'};
    if (_socket!.connected != true) return {'success': false, 'error': 'Not connected to server'};

    // Phase 5 & 6: Run existing Privacy Pipeline
    String sanitized = PseudonymizationService.instance.sanitizeText(originalText, communityId);
    
    // We get a simple alias for the sender (this could be enhanced later)
    String alias = 'Member';
    
    Completer<Map<String, dynamic>> completer = Completer();

    _socket!.emitWithAck('send_message', {
      'communityId': communityId,
      'senderId': senderId,
      'anonymousAlias': alias,
      'sanitizedMessage': sanitized,
      'replyTarget': replyTarget,
    }, ack: (dynamic responseData) {
      dynamic data = (responseData is List && responseData.isNotEmpty) ? responseData.first : responseData;
      if (data != null && data is Map) {
        completer.complete(Map<String, dynamic>.from(data));
      } else {
        completer.complete({'success': false, 'error': 'Invalid ack response'});
      }
    });

    return completer.future.timeout(const Duration(seconds: 5), onTimeout: () => {'success': false, 'error': 'Request timed out'});
  }

  Future<List<Map<String, dynamic>>> getHistory(String communityId, {int limit = 50}) async {
    if (_socket?.connected != true) return [];
    
    Completer<List<Map<String, dynamic>>> completer = Completer();
    
    _socket!.emitWithAck('get_community_history', {
      'communityId': communityId,
      'limit': limit,
    }, ack: (dynamic responseData) {
      dynamic data = (responseData is List && responseData.isNotEmpty) ? responseData.first : responseData;
      if (data != null && data is Map && data['success'] == true) {
        List<dynamic> rawMessages = data['messages'] ?? [];
        // Map dynamic to String keys safely
        List<Map<String, dynamic>> messages = rawMessages.map((e) {
          if (e is Map) {
            return Map<String, dynamic>.from(e);
          }
          return <String, dynamic>{};
        }).toList();
        completer.complete(messages);
      } else {
        completer.complete([]);
      }
    });

    // Timeout
    return completer.future.timeout(const Duration(seconds: 5), onTimeout: () => []);
  }

  Future<Map<String, dynamic>> getMetrics(String communityId) async {
    if (_socket?.connected != true) return {};

    Completer<Map<String, dynamic>> completer = Completer();
    
    _socket!.emitWithAck('get_community_metrics', {
      'communityId': communityId,
    }, ack: (dynamic responseData) {
      dynamic data = (responseData is List && responseData.isNotEmpty) ? responseData.first : responseData;
      if (data != null && data is Map && data['success'] == true) {
        completer.complete(Map<String, dynamic>.from(data['metrics'] ?? {}));
      } else {
        completer.complete({});
      }
    });

    return completer.future.timeout(const Duration(seconds: 3), onTimeout: () => {});
  }
}
