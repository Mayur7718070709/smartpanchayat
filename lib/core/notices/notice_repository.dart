import '../network/api_client.dart';
import '../../models/notice_model.dart';

class NoticeRepository {
  const NoticeRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<NoticeModel>> list({int limit = 100}) => _apiClient.get(
    '/api/v1/notices',
    queryParameters: {'limit': limit},
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
        .map((item) => NoticeModel.fromApi(item as Map<String, dynamic>))
        .toList(),
  );

  Future<void> markRead(String id) =>
      _apiClient.post<void>('/api/v1/notices/$id/read', decode: (_) {});
}
