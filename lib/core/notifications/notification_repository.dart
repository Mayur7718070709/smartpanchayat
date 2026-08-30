import '../network/api_client.dart';
import '../../models/notification_model.dart';

class NotificationRepository {
  const NotificationRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<NotificationModel>> list() => _apiClient.get(
    '/api/v1/notifications',
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List<dynamic>)
        .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
        .toList(),
  );

  Future<void> markRead(String id) =>
      _apiClient.post<void>('/api/v1/notifications/$id/read', decode: (_) {});

  Future<void> markAllRead() =>
      _apiClient.post<void>('/api/v1/notifications/read-all', decode: (_) {});

  Future<void> registerDeviceToken({
    required String token,
    required String platform,
    String? deviceId,
  }) => _apiClient.put<void>(
    '/api/v1/notifications/device-token',
    data: {'token': token, 'platform': platform, 'device_id': deviceId},
    decode: (_) {},
  );
}
