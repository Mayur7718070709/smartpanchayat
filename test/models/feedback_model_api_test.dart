import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/models/feedback_model.dart';

void main() {
  test('decodes an eligible completed service request', () {
    final item = FeedbackEligibleRequest.fromJson({
      'service_request_id': '11111111-1111-4111-8111-111111111111',
      'request_number': 'NERLE-2026-000005',
      'service_id': '22222222-2222-4222-8222-222222222222',
      'service_name_mr': 'जन्म दाखला',
      'service_name_en': 'Birth Certificate',
      'completed_at': '2026-08-24T10:00:00Z',
    });
    expect(item.requestNumber, 'NERLE-2026-000005');
    expect(item.completedAt, isNotNull);
  });

  test('decodes submitted feedback and category ratings', () {
    final item = ServiceFeedback.fromJson({
      'id': '33333333-3333-4333-8333-333333333333',
      'service_request_id': '11111111-1111-4111-8111-111111111111',
      'service_id': '22222222-2222-4222-8222-222222222222',
      'request_number': 'NERLE-2026-000005',
      'service_name_mr': 'जन्म दाखला',
      'service_name_en': 'Birth Certificate',
      'overall_rating': 5,
      'category_ratings': {
        'service_quality': 5,
        'response_time': 4,
        'staff_support': 5,
        'overall_experience': 5,
      },
      'comment': 'Good service',
      'created_at': '2026-08-24T10:00:00Z',
    });
    expect(item.overallRating, 5);
    expect(item.categoryRatings['response_time'], 4);
  });
}
