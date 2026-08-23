import '../network/api_client.dart';
import 'service_request.dart';

class ServiceRequestRepository {
  const ServiceRequestRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ServiceRequest>> fetchAll() =>
      _apiClient.get<List<ServiceRequest>>(
        '/api/v1/service-requests',
        queryParameters: const {'limit': 100, 'offset': 0},
        decode: (data) {
          final items =
              (data as Map<String, dynamic>)['items'] as List<dynamic>;
          return items
              .map(
                (item) => ServiceRequest.fromJson(item as Map<String, dynamic>),
              )
              .toList(growable: false);
        },
      );

  Future<ServiceRequest> fetchById(String requestId) =>
      _apiClient.get<ServiceRequest>(
        '/api/v1/service-requests/$requestId',
        decode: (data) => ServiceRequest.fromJson(data as Map<String, dynamic>),
      );

  Future<List<ServiceRequestStatusHistory>> fetchHistory(String requestId) =>
      _apiClient.get<List<ServiceRequestStatusHistory>>(
        '/api/v1/service-requests/$requestId/history',
        decode: (data) => (data as List<dynamic>)
            .map(
              (item) => ServiceRequestStatusHistory.fromJson(
                item as Map<String, dynamic>,
              ),
            )
            .toList(growable: false),
      );
}
