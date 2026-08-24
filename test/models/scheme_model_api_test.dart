import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/models/scheme_model.dart';

void main() {
  test('decodes the bilingual published scheme API contract', () {
    final scheme = SchemeModel.fromApi({
      'id': '11111111-1111-4111-8111-111111111111',
      'category': 'AGRICULTURE',
      'name_mr': 'शेती योजना',
      'name_en': 'Agriculture Scheme',
      'department_mr': 'कृषी विभाग',
      'department_en': 'Agriculture Department',
      'short_description_mr': 'मराठी वर्णन',
      'short_description_en': 'English description',
      'eligibility_summary_mr': 'मराठी पात्रता',
      'eligibility_summary_en': 'English eligibility',
      'about_mr': 'मराठी माहिती',
      'about_en': 'English information',
      'who_can_apply_mr': 'शेतकरी',
      'who_can_apply_en': 'Farmers',
      'benefits_mr': 'मराठी लाभ',
      'benefits_en': 'English benefits',
      'eligibility_mr': 'मराठी निकष',
      'eligibility_en': 'English criteria',
      'eligibility_rules': <String, dynamic>{},
      'required_documents_mr': ['आधार कार्ड'],
      'required_documents_en': ['Aadhaar card'],
      'how_to_apply_mr': 'ऑनलाइन अर्ज करा',
      'how_to_apply_en': 'Apply online',
      'official_source_url': 'https://example.gov.in/scheme',
      'official_source_label_mr': 'अधिकृत स्रोत',
      'official_source_label_en': 'Official source',
      'information_source_mr': 'शासकीय संकेतस्थळ',
      'information_source_en': 'Government website',
      'apply_url': 'https://example.gov.in/apply',
      'last_verified_at': '2026-08-24',
      'published_at': '2026-08-24T10:00:00Z',
      'expires_at': null,
    });

    expect(scheme.category, 'agriculture');
    expect(scheme.nameEn, 'Agriculture Scheme');
    expect(scheme.requiredDocuments, ['आधार कार्ड']);
    expect(scheme.requiredDocumentsEn, ['Aadhaar card']);
    expect(scheme.officialSourceLabelEn, 'Official source');
    expect(scheme.informationSourceEn, 'Government website');
  });
}
