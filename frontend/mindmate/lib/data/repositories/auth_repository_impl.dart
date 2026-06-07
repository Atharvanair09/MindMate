import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:bip39/bip39.dart' as bip39;
import '../../domain/repositories/auth_repository.dart';
import '../services/auth_service.dart';
import '../services/secure_storage_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final SecureStorageService _secureStorage;

  AuthRepositoryImpl(this._authService, this._secureStorage);

  @override
  Future<void> sendOtp(String email) async {
    await _authService.sendOtp(email);
  }

  @override
  Future<String> verifyOtp(String email, String otp, String deviceId) async {
    return await _authService.verifyOtp(email, otp, deviceId);
  }

  @override
  String generateRecoveryPhrase() {
    return bip39.generateMnemonic();
  }

  @override
  Future<void> saveSession(String token, String recoveryPhrase) async {
    await _secureStorage.saveToken(token);
    final bytes = utf8.encode(recoveryPhrase);
    final hash = sha256.convert(bytes).toString();
    await _secureStorage.saveRecoveryHash(hash);
  }

  @override
  Future<bool> isLoggedIn() async {
    final token = await _secureStorage.getToken();
    return token != null;
  }
}
