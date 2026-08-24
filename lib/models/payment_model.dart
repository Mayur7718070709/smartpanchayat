import 'package:flutter/material.dart';

enum PaymentStatus { pending, processing, success, failed, refunded }

enum PaymentService { houseTax, waterTax, certificateService, bonafide, other }

extension PaymentStatusExt on PaymentStatus {
  String get labelMr {
    switch (this) {
      case PaymentStatus.pending:
        return 'प्रलंबित';
      case PaymentStatus.processing:
        return 'प्रक्रियेत';
      case PaymentStatus.success:
        return 'यशस्वी';
      case PaymentStatus.failed:
        return 'अयशस्वी';
      case PaymentStatus.refunded:
        return 'परत केले';
    }
  }

  String get labelEn {
    switch (this) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.processing:
        return 'Processing';
      case PaymentStatus.success:
        return 'Success';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  Color get color {
    switch (this) {
      case PaymentStatus.pending:
        return const Color(0xFFD97706);
      case PaymentStatus.processing:
        return const Color(0xFF1A56DB);
      case PaymentStatus.success:
        return const Color(0xFF15803D);
      case PaymentStatus.failed:
        return const Color(0xFFB91C1C);
      case PaymentStatus.refunded:
        return const Color(0xFF7C3AED);
    }
  }

  Color get containerColor {
    switch (this) {
      case PaymentStatus.pending:
        return const Color(0xFFFEF3C7);
      case PaymentStatus.processing:
        return const Color(0xFFDCE8FF);
      case PaymentStatus.success:
        return const Color(0xFFDCFCE7);
      case PaymentStatus.failed:
        return const Color(0xFFFFE4E4);
      case PaymentStatus.refunded:
        return const Color(0xFFF3E8FF);
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentStatus.pending:
        return Icons.schedule_rounded;
      case PaymentStatus.processing:
        return Icons.sync_rounded;
      case PaymentStatus.success:
        return Icons.check_circle_rounded;
      case PaymentStatus.failed:
        return Icons.cancel_rounded;
      case PaymentStatus.refunded:
        return Icons.replay_rounded;
    }
  }
}

extension PaymentServiceExt on PaymentService {
  String get labelMr {
    switch (this) {
      case PaymentService.houseTax:
        return 'घरपट्टी';
      case PaymentService.waterTax:
        return 'पाणीपट्टी';
      case PaymentService.certificateService:
        return 'प्रमाणपत्र सेवा';
      case PaymentService.bonafide:
        return 'बोनाफाईड प्रमाणपत्र';
      case PaymentService.other:
        return 'इतर सेवा';
    }
  }

  String get labelEn {
    switch (this) {
      case PaymentService.houseTax:
        return 'House Tax';
      case PaymentService.waterTax:
        return 'Water Tax';
      case PaymentService.certificateService:
        return 'Certificate Service';
      case PaymentService.bonafide:
        return 'Bonafide Certificate';
      case PaymentService.other:
        return 'Other Service';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentService.houseTax:
        return Icons.home_work_rounded;
      case PaymentService.waterTax:
        return Icons.water_drop_rounded;
      case PaymentService.certificateService:
        return Icons.description_rounded;
      case PaymentService.bonafide:
        return Icons.verified_rounded;
      case PaymentService.other:
        return Icons.receipt_long_rounded;
    }
  }

  Color get color {
    switch (this) {
      case PaymentService.houseTax:
        return const Color(0xFF1A56DB);
      case PaymentService.waterTax:
        return const Color(0xFF0369A1);
      case PaymentService.certificateService:
        return const Color(0xFF0F766E);
      case PaymentService.bonafide:
        return const Color(0xFF7C3AED);
      case PaymentService.other:
        return const Color(0xFF475569);
    }
  }
}

class PaymentChargeItem {
  final String label;
  final String labelMr;
  final double amount;

  const PaymentChargeItem({
    required this.label,
    required this.labelMr,
    required this.amount,
  });
}

class PaymentSummaryData {
  final String requestId;
  final String citizenName;
  final String citizenNameMr;
  final PaymentService service;
  final double baseAmount;
  final List<PaymentChargeItem> charges;

  const PaymentSummaryData({
    required this.requestId,
    required this.citizenName,
    required this.citizenNameMr,
    required this.service,
    required this.baseAmount,
    required this.charges,
  });

  double get totalAmount =>
      baseAmount + charges.fold(0.0, (sum, c) => sum + c.amount);
}

class PaymentTransaction {
  final String id;
  final String transactionId;
  final String receiptNumber;
  final PaymentService service;
  final String requestId;
  final String citizenName;
  final double amount;
  final DateTime date;
  final PaymentStatus status;
  final String? receiptId;

  const PaymentTransaction({
    required this.id,
    required this.transactionId,
    required this.receiptNumber,
    required this.service,
    required this.requestId,
    required this.citizenName,
    required this.amount,
    required this.date,
    required this.status,
    this.receiptId,
  });

  factory PaymentTransaction.fromApi(Map<String, dynamic> json) {
    return PaymentTransaction(
      id: json['id'] as String,
      transactionId: json['provider_payment_id'] as String,
      receiptNumber: json['receipt_number'] as String? ?? '',
      receiptId: json['receipt_id'] as String?,
      service: PaymentService.other,
      requestId: '',
      citizenName: '',
      amount: (json['captured_amount_paise'] as num).toDouble() / 100,
      date: DateTime.parse(json['captured_at'] as String),
      status: PaymentStatus.success,
    );
  }
}

class CitizenDue {
  const CitizenDue({
    required this.id,
    required this.dueType,
    required this.referenceNumber,
    required this.titleMr,
    required this.titleEn,
    required this.dueDate,
    required this.assessedAmountPaise,
    required this.balancePaise,
    required this.status,
  });

  final String id;
  final String dueType;
  final String referenceNumber;
  final String titleMr;
  final String titleEn;
  final DateTime dueDate;
  final int assessedAmountPaise;
  final int balancePaise;
  final String status;

  double get balance => balancePaise / 100;
  bool get isPayable => status == 'OPEN' || status == 'PARTIALLY_PAID';

  factory CitizenDue.fromApi(Map<String, dynamic> json) => CitizenDue(
    id: json['id'] as String,
    dueType: json['due_type'] as String,
    referenceNumber: json['reference_number'] as String,
    titleMr: json['title_mr'] as String,
    titleEn: json['title_en'] as String,
    dueDate: DateTime.parse(json['due_date'] as String),
    assessedAmountPaise: (json['assessed_amount_paise'] as num).toInt(),
    balancePaise: (json['balance_paise'] as num).toInt(),
    status: json['status'] as String,
  );
}

class PaymentOrder {
  const PaymentOrder({
    required this.id,
    required this.providerOrderId,
    required this.currency,
    required this.amountPaise,
    required this.status,
    required this.dueIds,
    required this.checkoutKeyId,
    this.paymentVerificationStatus,
  });

  final String id;
  final String? providerOrderId;
  final String currency;
  final int amountPaise;
  final String status;
  final List<String> dueIds;
  final String? checkoutKeyId;
  final String? paymentVerificationStatus;

  factory PaymentOrder.fromApi(Map<String, dynamic> json) => PaymentOrder(
    id: json['id'] as String,
    providerOrderId: json['provider_order_id'] as String?,
    currency: json['currency'] as String,
    amountPaise: (json['amount_paise'] as num).toInt(),
    status: json['status'] as String,
    dueIds: (json['due_ids'] as List).cast<String>(),
    checkoutKeyId: json['checkout_key_id'] as String?,
    paymentVerificationStatus: json['payment_verification_status'] as String?,
  );
}
