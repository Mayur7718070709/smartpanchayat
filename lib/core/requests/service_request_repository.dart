import '../network/api_client.dart';
import 'service_request.dart';

class ServiceRequestRepository {
  const ServiceRequestRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<ServiceRequest> create({
    required String serviceId,
    required Map<String, dynamic> formData,
    required String idempotencyKey,
    String? applicantNote,
  }) => _apiClient.post<ServiceRequest>(
    '/api/v1/service-requests',
    data: {
      'service_id': serviceId,
      'form_data': formData,
      'applicant_note': applicantNote,
    },
    headers: {'Idempotency-Key': idempotencyKey},
    decode: (data) => ServiceRequest.fromJson(data as Map<String, dynamic>),
  );

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

  Future<List<ServiceRequestDocument>> fetchDocuments(String requestId) =>
      _apiClient.get(
        '/api/v1/service-requests/$requestId/documents',
        decode: (data) => (data as List)
            .map(
              (e) => ServiceRequestDocument.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );

  Future<List<ServiceRequestCorrection>> fetchCorrections(String requestId) =>
      _apiClient.get(
        '/api/v1/service-requests/$requestId/corrections',
        decode: (data) => (data as List)
            .map(
              (e) =>
                  ServiceRequestCorrection.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
      );

  Future<ServiceRequestDocument> uploadDocument(
    String requestId,
    String code,
    String filename,
    String mimeType,
    List<int> bytes,
  ) => _apiClient.postBytes(
    '/api/v1/service-requests/$requestId/documents',
    bytes,
    contentType: mimeType,
    headers: {'X-Document-Code': code, 'X-Filename': filename},
    decode: (data) =>
        ServiceRequestDocument.fromJson(data as Map<String, dynamic>),
  );

  Future<String> certificateUrl(String requestId) => _apiClient.get(
    '/api/v1/service-requests/$requestId/certificate-url',
    decode: (data) => (data as Map<String, dynamic>)['url'] as String,
  );
}
