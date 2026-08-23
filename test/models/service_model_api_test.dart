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

  test('decodes an approved published dynamic form', () {
    final form = PublishedServiceForm.fromApi({
      'schema_version_id': '814a16d8-c425-4f2c-8138-6f7679208f93',
      'version': 2,
      'schema_definition': {
        'fields': [
          {
            'id': 'applicant_name',
            'label_mr': 'अर्जदाराचे नाव',
            'label_en': 'Applicant name',
            'type': 'text',
            'required': true,
          },
        ],
      },
      'document_requirements': [
        {'label': 'Identity proof'},
      ],
      'schema_checksum':
          'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
    });

    expect(form.version, 2);
    expect(form.fields.single.id, 'applicant_name');
    expect(form.fields.single.labelEn, 'Applicant name');
    expect(form.requiredDocuments, ['Identity proof']);
  });

  test('rejects a published form with no fields', () {
    expect(
      () => PublishedServiceForm.fromApi({
        'schema_version_id': '814a16d8-c425-4f2c-8138-6f7679208f93',
        'version': 1,
        'schema_definition': {'fields': <dynamic>[]},
        'document_requirements': <dynamic>[],
        'schema_checksum':
            'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
      }),
      throwsFormatException,
    );
  });
}
