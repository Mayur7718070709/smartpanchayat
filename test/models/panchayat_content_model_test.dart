import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/models/panchayat_content_model.dart';

void main() {
  test('decodes live Panchayat metadata', () {
    final item = PanchayatProfile.fromJson({
      'id': '11d4a215-9dcc-475b-9fc7-9c6ba1c72dbd',
      'name': 'Nerle Gram Panchayat',
      'code': 'NERLE',
      'village': 'Nerle',
    });
    expect(item.code, 'NERLE');
    expect(item.village, 'Nerle');
  });
  test('decodes an official contact', () {
    final item = OfficialContact.fromJson({
      'id': '11111111-1111-4111-8111-111111111111',
      'contact_type': 'PANCHAYAT_OFFICE',
      'name_en': 'Nerle Gram Panchayat',
      'name_mr': 'ग्रामपंचायत कार्यालय',
      'phone': '7718070709',
    });
    expect(item.type, 'PANCHAYAT_OFFICE');
  });
}
