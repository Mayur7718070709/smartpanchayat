import '../network/api_client.dart';
import '../../models/panchayat_content_model.dart';

class PanchayatContentRepository {
  const PanchayatContentRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<PanchayatProfile> profile() => _apiClient.get(
    '/api/v1/panchayat',
    decode: (data) => PanchayatProfile.fromJson(data as Map<String, dynamic>),
  );

  Future<List<OfficialContact>> contacts() => _apiClient.get(
    '/api/v1/contacts',
    decode: (data) => (data as List)
        .map((x) => OfficialContact.fromJson(x as Map<String, dynamic>))
        .toList(),
  );

  Future<List<PanchayatEvent>> events() => _apiClient.get(
    '/api/v1/events',
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
        .map((x) => PanchayatEvent.fromJson(x as Map<String, dynamic>))
        .toList(),
  );
}
