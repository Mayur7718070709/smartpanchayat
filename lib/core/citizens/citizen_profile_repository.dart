import '../network/api_client.dart';
import 'citizen_profile.dart';

class CitizenProfileRepository {
  const CitizenProfileRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<CitizenProfile> fetch() => _apiClient.get<CitizenProfile>(
    '/api/v1/citizen/profile',
    decode: (data) => CitizenProfile.fromJson(data as Map<String, dynamic>),
  );
}
