import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/models/faq_model.dart';

void main() {
  test('decodes a cited controlled assistant answer', () {
    final answer = AssistantAnswer.fromJson({
      'id': '11111111-1111-4111-8111-111111111111',
      'conversation_id': '22222222-2222-4222-8222-222222222222',
      'answer_en': 'Open My Applications.',
      'answer_mr': 'माझे अर्ज उघडा.',
      'outcome': 'ANSWERED',
      'citation': {'source_code': 'APP_REQUESTS', 'title_en': 'My Applications'},
      'created_at': '2026-08-24T10:00:00Z',
    });
    expect(answer.outcome, 'ANSWERED');
    expect(answer.citation?['source_code'], 'APP_REQUESTS');
  });
}
