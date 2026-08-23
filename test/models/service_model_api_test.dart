import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/models/service_model.dart';

void main() {
  test('decodes the FastAPI service contract without invented content', () {
    final service = ServiceModel.fromApi({
      'id': '70d5b6a8-2a15-4eaa-93bb-e777d744d248',
      'name': 'Birth Certificate',
      'description': 'Apply for a birth certificate.',
      'fee': '25.00',
      'estimated_days': 7,
      'required_documents': [
        {'name': 'Identity proof'},
        'Address proof',
      ],
      'form_schema': <String, dynamic>{},
      'display_order': 1,
      'is_online': true,
      'is_active': true,
      'category_id': null,
      'category_name': 'Certificates',
      'content_status': 'PENDING_AUTHORITATIVE_CONTENT',
      'data_source': 'LIVE_DATABASE',
      'created_at': '2026-08-22T10:00:00Z',
      'updated_at': '2026-08-23T10:00:00Z',
    });

    expect(service.nameMr, 'Birth Certificate');
    expect(service.nameEn, isEmpty);
    expect(service.fee, 25);
    expect(service.processingDays, 7);
    expect(service.requiredDocuments, ['Identity proof', 'Address proof']);
    expect(service.eligibilityEn, isEmpty);
    expect(service.contentStatus, 'PENDING_AUTHORITATIVE_CONTENT');
    expect(service.categoryLabel, 'Certificates');
  });
}
