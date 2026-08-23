import 'package:supabase_flutter/supabase_flutter.dart';

class PhoneAuthService {
  PhoneAuthService(this._client);

  final SupabaseClient _client;

  String normalizeIndianPhone(String localPhone) {
    final digits = localPhone.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 10) {
      throw const PhoneAuthFailure('Enter a valid 10 digit mobile number.');
    }
    return '+91$digits';
  }

  Future<void> sendOtp(String localPhone) async {
    try {
      await _client.auth.signInWithOtp(
        phone: normalizeIndianPhone(localPhone),
        shouldCreateUser: false,
      );
    } on AuthException catch (error) {
      throw PhoneAuthFailure(error.message);
    }
  }

  Future<String> verifyOtp(String localPhone, String otp) async {
    try {
      final response = await _client.auth.verifyOTP(
        phone: normalizeIndianPhone(localPhone),
        token: otp,
        type: OtpType.sms,
      );
      final token = response.session?.accessToken;
      if (token == null || token.isEmpty) {
        throw const PhoneAuthFailure(
          'OTP was accepted but no authenticated session was created.',
        );
      }
      return token;
    } on AuthException catch (error) {
      throw PhoneAuthFailure(error.message);
    }
  }

  Future<void> resendOtp(String localPhone) => sendOtp(localPhone);

  String? get accessToken => _client.auth.currentSession?.accessToken;

  bool get hasSession => _client.auth.currentSession != null;

  Future<void> signOut() => _client.auth.signOut(scope: SignOutScope.local);
}

class PhoneAuthFailure implements Exception {
  const PhoneAuthFailure(this.message);

  final String message;

  @override
  String toString() => message;
}
