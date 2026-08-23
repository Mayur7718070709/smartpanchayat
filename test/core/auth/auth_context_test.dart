import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/auth/auth_context.dart';

void main() {
  test('accepts only a tenant-scoped citizen profile', () {
    final context = AuthContext.fromJson({
      'user_id': 'user-id',
      'app_user_id': 'app-user-id',
      'role': 'CITIZEN',
      'tenant_id': 'tenant-id',
      'citizen_id': 'citizen-id',
    });

    expect(context.isReadyCitizen, isTrue);
  });

  test('rejects admin and incomplete citizen contexts', () {
    const admin = AuthContext(
      userId: 'user-id',
      appUserId: 'app-user-id',
      role: 'PANCHAYAT_ADMIN',
      tenantId: 'tenant-id',
      citizenId: null,
    );
    const incompleteCitizen = AuthContext(
      userId: 'user-id',
      appUserId: 'app-user-id',
      role: 'CITIZEN',
      tenantId: 'tenant-id',
      citizenId: null,
    );

    expect(admin.isReadyCitizen, isFalse);
    expect(incompleteCitizen.isReadyCitizen, isFalse);
  });
}
