import '../network/api_client.dart';
import '../../models/payment_model.dart';

class PaymentRepository {
  const PaymentRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<List<CitizenDue>> listDues() => _apiClient.get<List<CitizenDue>>(
    '/api/v1/dues',
    decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
        .map((item) => CitizenDue.fromApi(item as Map<String, dynamic>))
        .toList(),
  );

  Future<List<PaymentTransaction>> listTransactions() =>
      _apiClient.get<List<PaymentTransaction>>(
        '/api/v1/payments',
        decode: (data) => ((data as Map<String, dynamic>)['items'] as List)
            .map(
              (item) =>
                  PaymentTransaction.fromApi(item as Map<String, dynamic>),
            )
            .toList(),
      );

  Future<void> checkAvailability() async {
    await listTransactions();
  }

  Future<PaymentOrder> createOrder({
    required String dueId,
    required String idempotencyKey,
  }) => _apiClient.post<PaymentOrder>(
    '/api/v1/payment-orders',
    headers: {'Idempotency-Key': idempotencyKey},
    data: {
      'due_ids': [dueId],
    },
    decode: (data) => PaymentOrder.fromApi(data as Map<String, dynamic>),
  );

  Future<PaymentOrder> confirmOrder({
    required String localOrderId,
    required String providerOrderId,
    required String providerPaymentId,
    required String providerSignature,
  }) => _apiClient.post<PaymentOrder>(
    '/api/v1/payment-orders/$localOrderId/confirm',
    data: {
      'provider_order_id': providerOrderId,
      'provider_payment_id': providerPaymentId,
      'provider_signature': providerSignature,
    },
    decode: (data) => PaymentOrder.fromApi(data as Map<String, dynamic>),
  );
}
