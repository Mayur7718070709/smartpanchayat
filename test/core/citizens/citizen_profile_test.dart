import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/citizens/citizen_profile.dart';

void main() {
  test('decodes the FastAPI citizen profile contract', () {
    final profile = CitizenProfile.fromJson({
      'id': '6f6311a9-83ed-4c43-8cea-1f9f0ebfbd08',
      'full_name': 'Nerle Test Citizen',
      'address': 'Nerle',
      'ward': '3',
      'gender': 'MALE',
      'date_of_birth': '1990-08-15',
      'profile_photo_path': null,
      'preferred_language': 'mr',
      'created_at': '2026-08-22T10:00:00Z',
      'updated_at': '2026-08-23T10:00:00Z',
    });

    expect(profile.fullName, 'Nerle Test Citizen');
    expect(profile.ward, '3');
    expect(profile.dateOfBirth, DateTime(1990, 8, 15));
    expect(profile.preferredLanguage, 'mr');
  });
}
