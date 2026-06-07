abstract class AuthRepository {
  Future<void> sendOtp(String email);
  Future<String> verifyOtp(String email, String otp, String deviceId);
  String generateRecoveryPhrase();
  Future<void> saveSession(String token, String recoveryPhrase);
  Future<bool> isLoggedIn();
}
