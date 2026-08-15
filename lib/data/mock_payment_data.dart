import '../models/payment_model.dart';

class MockPaymentData {
  static final List<PaymentTransaction> transactions = [
    PaymentTransaction(
      id: 'txn_001',
      transactionId: 'TXN2025081500001',
      receiptNumber: 'RCP/NRL/2025/0001',
      service: PaymentService.houseTax,
      requestId: 'REQ-HT-2025-001',
      citizenName: 'Mayur Patil',
      amount: 1250.0,
      date: DateTime(2025, 8, 15, 10, 30),
      status: PaymentStatus.success,
    ),
    PaymentTransaction(
      id: 'txn_002',
      transactionId: 'TXN2025081400002',
      receiptNumber: 'RCP/NRL/2025/0002',
      service: PaymentService.waterTax,
      requestId: 'REQ-WT-2025-002',
      citizenName: 'Mayur Patil',
      amount: 480.0,
      date: DateTime(2025, 8, 14, 14, 15),
      status: PaymentStatus.success,
    ),
    PaymentTransaction(
      id: 'txn_003',
      transactionId: 'TXN2025081300003',
      receiptNumber: '',
      service: PaymentService.bonafide,
      requestId: 'REQ-BF-2025-003',
      citizenName: 'Mayur Patil',
      amount: 50.0,
      date: DateTime(2025, 8, 13, 9, 0),
      status: PaymentStatus.failed,
    ),
    PaymentTransaction(
      id: 'txn_004',
      transactionId: 'TXN2025081000004',
      receiptNumber: 'RCP/NRL/2025/0004',
      service: PaymentService.certificateService,
      requestId: 'REQ-CS-2025-004',
      citizenName: 'Mayur Patil',
      amount: 100.0,
      date: DateTime(2025, 8, 10, 11, 45),
      status: PaymentStatus.success,
    ),
    PaymentTransaction(
      id: 'txn_005',
      transactionId: 'TXN2025080500005',
      receiptNumber: 'RCP/NRL/2025/0005',
      service: PaymentService.houseTax,
      requestId: 'REQ-HT-2025-005',
      citizenName: 'Mayur Patil',
      amount: 1250.0,
      date: DateTime(2025, 8, 5, 16, 20),
      status: PaymentStatus.refunded,
    ),
  ];

  static PaymentSummaryData get sampleSummary => const PaymentSummaryData(
    requestId: 'REQ-HT-2025-001',
    citizenName: 'Mayur Patil',
    citizenNameMr: 'मयूर पाटील',
    service: PaymentService.houseTax,
    baseAmount: 1200.0,
    charges: [
      PaymentChargeItem(
        label: 'Service Charge',
        labelMr: 'सेवा शुल्क',
        amount: 30.0,
      ),
      PaymentChargeItem(
        label: 'Processing Fee',
        labelMr: 'प्रक्रिया शुल्क',
        amount: 20.0,
      ),
    ],
  );
}
