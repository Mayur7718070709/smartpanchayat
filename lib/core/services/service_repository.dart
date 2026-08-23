import '../../models/service_model.dart';
import '../network/api_client.dart';

class ServiceRepository {
  const ServiceRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ServiceModel>> fetchAll() => _apiClient.get<List<ServiceModel>>(
    '/api/v1/services',
    queryParameters: const {'limit': 100, 'offset': 0},
    decode: (data) {
      final page = data as Map<String, dynamic>;
      final items = page['items'] as List<dynamic>;
      return items
          .map((item) => ServiceModel.fromApi(item as Map<String, dynamic>))
          .toList(growable: false);
    },
  );

  Future<ServiceModel> fetchById(String serviceId) =>
      _apiClient.get<ServiceModel>(
        '/api/v1/services/$serviceId',
        decode: (data) => ServiceModel.fromApi(data as Map<String, dynamic>),
      );
}
