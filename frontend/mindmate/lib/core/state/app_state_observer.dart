import 'package:flutter/material.dart';
import '../../services/notifications/notification_service.dart';

class AppStateObserver with WidgetsBindingObserver {
  static final AppStateObserver instance = AppStateObserver._internal();
  AppStateObserver._internal();

  AppLifecycleState state = AppLifecycleState.resumed;

  int foregroundCount = 0;
  int backgroundCount = 0;
  int suppressedCount = 0;

  void initialize() {
    WidgetsBinding.instance.addObserver(this);
    state = WidgetsBinding.instance.lifecycleState ?? AppLifecycleState.resumed;
    
    // Initial state trigger
    if (state == AppLifecycleState.resumed) {
      NotificationService.instance.handleAppForeground();
    } else {
      NotificationService.instance.handleAppBackground();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState newState) {
    state = newState;
    if (newState == AppLifecycleState.resumed) {
      NotificationService.instance.handleAppForeground();
    } else if (newState == AppLifecycleState.paused || newState == AppLifecycleState.detached) {
      NotificationService.instance.handleAppBackground();
    }
  }

  bool get isForeground => state == AppLifecycleState.resumed;
}
