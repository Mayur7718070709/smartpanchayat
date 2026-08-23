import '../network/api_client.dart';

class ComplaintRepository {
  const ComplaintRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkAvailability() =>
      _apiClient.get<void>('/api/v1/complaints', decode: (_) {});
}
