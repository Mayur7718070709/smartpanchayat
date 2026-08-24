import '../network/api_client.dart';
import 'citizen_profile.dart';

class CitizenProfileRepository {
  const CitizenProfileRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<CitizenProfile> fetch() => _apiClient.get<CitizenProfile>(
    '/api/v1/citizen/profile',
    decode: (data) => CitizenProfile.fromJson(data as Map<String, dynamic>),
  );

  Future<CitizenProfile> update({
    required String fullName,
    String? address,
    String? wardId,
    String? gender,
    DateTime? dateOfBirth,
    String preferredLanguage = 'mr',
  }) => _apiClient.put(
    '/api/v1/citizen/profile',
    data: {
      'full_name': fullName,
      'address': address,
      'ward_id': wardId,
      'gender': gender,
      'date_of_birth': dateOfBirth?.toIso8601String().split('T').first,
      'preferred_language': preferredLanguage,
    },
    decode: (data) => CitizenProfile.fromJson(data as Map<String, dynamic>),
  );

  Future<CitizenProfile> onboard({
    required String inviteCode,
    required String fullName,
    String? address,
  }) => _apiClient.post(
    '/api/v1/citizen/onboarding',
    data: {
      'invite_code': inviteCode,
      'full_name': fullName,
      'address': address,
      'preferred_language': 'mr',
    },
    decode: (data) => CitizenProfile.fromJson(data as Map<String, dynamic>),
  );

  Future<CitizenProfile> uploadPhoto(List<int> bytes, String mime) =>
      _apiClient.postBytes(
        '/api/v1/citizen/profile/photo',
        bytes,
        contentType: mime,
        decode: (data) => CitizenProfile.fromJson(data as Map<String, dynamic>),
      );
}
