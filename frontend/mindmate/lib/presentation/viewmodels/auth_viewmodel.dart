import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../data/repositories/auth_repository.dart';

enum AuthState { emailInput, otpInput, recoveryPhrase, recoverAccount }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _repository;

  AuthViewModel({AuthRepository? repository}) 
      : _repository = repository ?? AuthRepository();

  AuthState _currentState = AuthState.emailInput;
  AuthState get currentState => _currentState;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _currentEmail = '';
  String get currentEmail => _currentEmail;

  String? _recoveryPhrase;
  String? get recoveryPhrase => _recoveryPhrase;

  bool _canResendOtp = false;
  bool get canResendOtp => _canResendOtp;

  int _resendTimer = 60;
  int get resendTimer => _resendTimer;

  Timer? _timer;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
    // Clear error after UI renders it
    if (message != null) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _errorMessage = null;
      });
    }
  }

  void resetToEmail() {
    _timer?.cancel();
    _currentState = AuthState.emailInput;
    _currentEmail = '';
    notifyListeners();
  }

  void startRecoveryFlow() {
    _currentState = AuthState.recoverAccount;
    notifyListeners();
  }

  void startResendTimer() {
    _canResendOtp = false;
    _resendTimer = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        _resendTimer--;
        notifyListeners();
      } else {
        _canResendOtp = true;
        timer.cancel();
        notifyListeners();
      }
    });
  }

  Future<void> sendOtp(String email) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.sendOtp(email);
      _currentEmail = email;
      _currentState = AuthState.otpInput;
      startResendTimer();
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resendOtp() async {
    if (_currentEmail.isNotEmpty) {
      await sendOtp(_currentEmail);
    }
  }

  Future<void> verifyOtp(String otp) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.verifyOtp(_currentEmail, otp);
      _timer?.cancel();
      // Generate phrase and show it to user
      _recoveryPhrase = _repository.generateRecoveryPhrase();
      _currentState = AuthState.recoveryPhrase;
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> completeAuth() async {
    if (_recoveryPhrase == null) return;
    _setLoading(true);
    _setError(null);
    try {
      await _repository.registerWithPhrase(_recoveryPhrase!);
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> recoverAccount(String phrase) async {
    _setLoading(true);
    _setError(null);
    try {
      await _repository.recoverAccount(phrase);
      return true; // recovery successful
    } catch (e) {
      _setError(e.toString().replaceAll('Exception: ', ''));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
