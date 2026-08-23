import '../network/api_client.dart';

/// Dynamic FAQ is an authenticated, gated capability.
/// Static FAQ content remains a demo/offline fixture and is not decoded as if
/// it came from this endpoint.
class FaqRepository {
  const FaqRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkAvailability() =>
      _apiClient.get<void>('/api/v1/faq', decode: (_) {});
}
