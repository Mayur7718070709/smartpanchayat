import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/models/payment_model.dart';

void main() {
  test('decodes an authoritative citizen due', () {
    final due = CitizenDue.fromApi({
      'id': '11111111-1111-4111-8111-111111111111',
      'due_type': 'PROPERTY_TAX',
      'reference_number': 'PT-2026-001',
      'title_mr': 'मालमत्ता कर',
      'title_en': 'Property tax',
      'due_date': '2026-09-30',
      'assessed_amount_paise': 125000,
      'balance_paise': 125000,
      'status': 'OPEN',
    });

    expect(due.balance, 1250);
    expect(due.isPayable, isTrue);
    expect(due.referenceNumber, 'PT-2026-001');
  });

  test('decodes an authoritative captured payment', () {
    final payment = PaymentTransaction.fromApi({
      'id': '22222222-2222-4222-8222-222222222222',
      'provider_payment_id': 'pay_Test123',
      'captured_amount_paise': 125000,
      'captured_at': '2026-08-24T10:00:00Z',
      'receipt_id': '33333333-3333-4333-8333-333333333333',
      'receipt_number': 'NERLE-RCP-2026-000001',
    });

    expect(payment.amount, 1250);
    expect(payment.status, PaymentStatus.success);
    expect(payment.receiptNumber, 'NERLE-RCP-2026-000001');
    expect(payment.receiptId, isNotNull);
  });

  test('decodes a server-priced Razorpay order', () {
    final order = PaymentOrder.fromApi({
      'id': '44444444-4444-4444-8444-444444444444',
      'provider_order_id': 'order_Test123',
      'currency': 'INR',
      'amount_paise': 125000,
      'status': 'CREATED',
      'due_ids': ['11111111-1111-4111-8111-111111111111'],
      'checkout_key_id': 'rzp_test_public',
      'payment_verification_status': null,
    });

    expect(order.amountPaise, 125000);
    expect(order.providerOrderId, 'order_Test123');
    expect(order.checkoutKeyId, 'rzp_test_public');
  });
}
