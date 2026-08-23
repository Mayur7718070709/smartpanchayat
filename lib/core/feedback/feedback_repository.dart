import '../network/api_client.dart';

class FeedbackRepository {
  const FeedbackRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkAvailability() =>
      _apiClient.get<void>('/api/v1/feedback', decode: (_) {});
}
