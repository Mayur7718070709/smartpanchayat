import '../network/api_client.dart';
import '../../models/scheme_model.dart';

class SchemeRepository {
  const SchemeRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SchemeModel>> list({int limit = 100}) => _apiClient.get(
    '/api/v1/schemes',
    queryParameters: {'limit': limit},
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
        .map((item) => SchemeModel.fromApi(item as Map<String, dynamic>))
        .toList(),
  );
}
