import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/models/notice_model.dart';

void main() {
  test('decodes tenant notice and attachment contract', () {
    final notice = NoticeModel.fromApi({
      'id': '11111111-1111-4111-8111-111111111111',
      'category': 'IMPORTANT',
      'title_mr': 'महत्त्वाची सूचना',
      'title_en': 'Important notice',
      'summary_mr': 'सारांश',
      'summary_en': 'Summary',
      'body_mr': 'मजकूर',
      'body_en': 'Body',
      'published_at': '2026-08-24T10:00:00Z',
      'is_unread': true,
      'attachment_url': 'https://example.test/signed',
      'attachment_name': 'notice.pdf',
      'panchayat_name': 'Nerle Gram Panchayat',
      'district': 'Sangli',
      'taluka': 'Walwa',
      'issued_by': 'Administrator',
    });

    expect(notice.category, 'important');
    expect(notice.isUnread, isTrue);
    expect(notice.attachmentName, 'notice.pdf');
    expect(notice.panchayatName, 'Nerle Gram Panchayat');
  });
}
