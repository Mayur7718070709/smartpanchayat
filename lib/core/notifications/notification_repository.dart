import '../network/api_client.dart';

class NotificationRepository {
  const NotificationRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkAvailability() =>
      _apiClient.get<void>('/api/v1/notifications', decode: (_) {});
}
