import '../network/api_client.dart';

class SchemeRepository {
  const SchemeRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkAvailability() =>
      _apiClient.get<void>('/api/v1/schemes', decode: (_) {});
}
