import '../network/api_client.dart';

class PaymentRepository {
  const PaymentRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<void> checkAvailability() =>
      _apiClient.get<void>('/api/v1/payments', decode: (_) {});
}
