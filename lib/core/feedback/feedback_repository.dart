import '../network/api_client.dart';
import '../../models/feedback_model.dart';

class FeedbackRepository {
  const FeedbackRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<FeedbackEligibleRequest>> eligibleRequests() => _apiClient.get(
    '/api/v1/feedback/eligible-requests',
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
        .map(
          (item) =>
              FeedbackEligibleRequest.fromJson(item as Map<String, dynamic>),
        )
        .toList(),
  );

  Future<List<ServiceFeedback>> list() => _apiClient.get(
    '/api/v1/feedback',
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
        .map((item) => ServiceFeedback.fromJson(item as Map<String, dynamic>))
        .toList(),
  );

  Future<ServiceFeedback> create({
    required String serviceRequestId,
    required int overallRating,
    required Map<String, int> categoryRatings,
    String? comment,
    required String idempotencyKey,
  }) => _apiClient.post(
    '/api/v1/feedback',
    headers: {'Idempotency-Key': idempotencyKey},
    data: {
      'service_request_id': serviceRequestId,
      'overall_rating': overallRating,
      'category_ratings': categoryRatings,
      'comment': comment,
    },
    decode: (data) => ServiceFeedback.fromJson(data as Map<String, dynamic>),
  );
}
