import '../network/api_client.dart';

class NoticeRepository {
  const NoticeRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkAvailability() =>
      _apiClient.get<void>('/api/v1/notices', decode: (_) {});
}
