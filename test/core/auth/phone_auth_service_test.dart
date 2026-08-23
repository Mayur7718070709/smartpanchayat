import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/auth/phone_auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  final service = PhoneAuthService(
    SupabaseClient('https://project.supabase.co', 'public-test-key'),
  );

  test('normalizes an Indian mobile number to E.164', () {
    expect(service.normalizeIndianPhone('9876543210'), '+919876543210');
    expect(service.normalizeIndianPhone('98765 43210'), '+919876543210');
  });

  test('rejects an invalid local mobile number', () {
    expect(
      () => service.normalizeIndianPhone('12345'),
      throwsA(isA<PhoneAuthFailure>()),
    );
  });
}
