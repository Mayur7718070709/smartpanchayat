import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/models/complaint_model.dart';

void main() {
  test('decodes the FastAPI complaint contract', () {
    final complaint = ComplaintModel.fromJson({
      'id': '11111111-1111-4111-8111-111111111111',
      'complaint_number': 'CMP-NERLE-2026-000001',
      'category': 'STREET_LIGHTS',
      'description': 'Street light is not working',
      'location': 'Ward 1',
      'status': 'IN_PROGRESS',
      'submitted_at': '2026-08-24T10:00:00Z',
      'rating': null,
      'can_reopen': false,
    });

    expect(complaint.category, ComplaintCategory.streetLights);
    expect(complaint.currentStatus, ComplaintStatus.inProgress);
    expect(complaint.complaintId, 'CMP-NERLE-2026-000001');
  });

  test('encodes every complaint category using the API vocabulary', () {
    expect(ComplaintCategory.values.map((item) => item.apiValue).toSet(), {
      'WATER',
      'ROADS',
      'STREET_LIGHTS',
      'GARBAGE',
      'DRAINAGE',
      'PUBLIC_FACILITIES',
      'DOCUMENTS',
      'OTHER',
    });
  });
}
