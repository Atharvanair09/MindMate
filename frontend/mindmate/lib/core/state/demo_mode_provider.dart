import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DemoModeProvider extends ChangeNotifier {
  // Global singleton state so repositories can access the current mode without context
  static bool _isDemoModeActive = false;
  static const String _demoModeKey = 'demo_mode_active';
  
  static Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _isDemoModeActive = prefs.getBool(_demoModeKey) ?? false;
  }

  static bool get isDemoModeActive => _isDemoModeActive;

  bool _isSeeding = false;
  bool get isSeeding => _isSeeding;

  bool get isDemoMode => _isDemoModeActive;

  void toggleDemoMode(bool value) {
    if (_isDemoModeActive == value) return;
    _isDemoModeActive = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool(_demoModeKey, value);
    });
    notifyListeners();
  }

  void setSeeding(bool value) {
    if (_isSeeding == value) return;
    _isSeeding = value;
    notifyListeners();
  }
}
