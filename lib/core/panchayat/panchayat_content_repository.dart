import '../network/api_client.dart';

class PanchayatContentRepository {
  const PanchayatContentRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkContactsAvailability() =>
      _apiClient.get<void>('/api/v1/contacts', decode: (_) {});

  Future<void> checkEventsAvailability() =>
      _apiClient.get<void>('/api/v1/events', decode: (_) {});
}
