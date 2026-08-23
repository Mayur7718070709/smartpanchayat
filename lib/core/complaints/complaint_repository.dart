import '../network/api_client.dart';
import '../../models/complaint_model.dart';

class ComplaintRepository {
  const ComplaintRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<ComplaintModel>> list() => _apiClient.get<List<ComplaintModel>>(
    '/api/v1/complaints',
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
        .map((item) => ComplaintModel.fromJson(item as Map<String, dynamic>))
        .toList(),
  );

  Future<ComplaintModel> create({
    required ComplaintCategory category,
    required String description,
    String? location,
    required String idempotencyKey,
  }) => _apiClient.post<ComplaintModel>(
    '/api/v1/complaints',
    headers: {'Idempotency-Key': idempotencyKey},
    data: {
      'category': category.apiValue,
      'description': description,
      'location': location,
    },
    decode: (data) => ComplaintModel.fromJson(data as Map<String, dynamic>),
  );

  Future<List<ComplaintTimelineEvent>> history(String id) => _apiClient.get(
    '/api/v1/complaints/$id/history',
    decode: (data) => (data as List).map((item) {
      final json = item as Map<String, dynamic>;
      return ComplaintTimelineEvent(
        status: ComplaintStatusExt.fromApi(json['new_status'] as String),
        dateTime: DateTime.parse(json['changed_at'] as String),
        officerRemark: json['remark'] as String?,
      );
    }).toList(),
  );

  Future<void> addInformation(String id, String body) => _apiClient.post<void>(
    '/api/v1/complaints/$id/additional-information',
    data: {'body': body},
    decode: (_) {},
  );

  Future<void> rate(String id, int rating) => _apiClient.post<void>(
    '/api/v1/complaints/$id/rating',
    data: {'rating': rating},
    decode: (_) {},
  );

  Future<ComplaintModel> reopen(String id, String reason) => _apiClient.post(
    '/api/v1/complaints/$id/reopen',
    data: {'reason': reason},
    decode: (data) => ComplaintModel.fromJson(data as Map<String, dynamic>),
  );

  Future<void> uploadAttachment(String id, List<int> bytes, String mimeType) =>
      _apiClient.postBytes<void>(
        '/api/v1/complaints/$id/attachments',
        bytes,
        contentType: mimeType,
        decode: (_) {},
      );
}
