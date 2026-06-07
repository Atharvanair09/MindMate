import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  final _storage = const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  Future<void> saveRecoveryHash(String hash) async {
    await _storage.write(key: 'recovery_hash', value: hash);
  }

  Future<String?> getRecoveryHash() async {
    return await _storage.read(key: 'recovery_hash');
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
