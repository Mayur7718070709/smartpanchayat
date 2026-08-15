import 'package:flutter/material.dart';

enum NotificationCategory {
  complaintUpdate,
  serviceUpdate,
  panchayatNotice,
  payment,
  scheme,
  emergency,
}

extension NotificationCategoryExt on NotificationCategory {
  String get labelMr {
    switch (this) {
      case NotificationCategory.complaintUpdate:
        return 'तक्रार अपडेट';
      case NotificationCategory.serviceUpdate:
        return 'सेवा अपडेट';
      case NotificationCategory.panchayatNotice:
        return 'पंचायत सूचना';
      case NotificationCategory.payment:
        return 'पेमेंट';
      case NotificationCategory.scheme:
        return 'योजना';
      case NotificationCategory.emergency:
        return 'आपत्कालीन';
    }
  }

  String get labelEn {
    switch (this) {
      case NotificationCategory.complaintUpdate:
        return 'Complaint Update';
      case NotificationCategory.serviceUpdate:
        return 'Service Update';
      case NotificationCategory.panchayatNotice:
        return 'Panchayat Notice';
      case NotificationCategory.payment:
        return 'Payment';
      case NotificationCategory.scheme:
        return 'Scheme';
      case NotificationCategory.emergency:
        return 'Emergency';
    }
  }

  IconData get icon {
    switch (this) {
      case NotificationCategory.complaintUpdate:
        return Icons.report_problem_rounded;
      case NotificationCategory.serviceUpdate:
        return Icons.miscellaneous_services_rounded;
      case NotificationCategory.panchayatNotice:
        return Icons.campaign_rounded;
      case NotificationCategory.payment:
        return Icons.payment_rounded;
      case NotificationCategory.scheme:
        return Icons.account_balance_rounded;
      case NotificationCategory.emergency:
        return Icons.warning_amber_rounded;
    }
  }

  Color get color {
    switch (this) {
      case NotificationCategory.complaintUpdate:
        return const Color(0xFF1A56DB);
      case NotificationCategory.serviceUpdate:
        return const Color(0xFF1B7A3E);
      case NotificationCategory.panchayatNotice:
        return const Color(0xFF7C3AED);
      case NotificationCategory.payment:
        return const Color(0xFFD97706);
      case NotificationCategory.scheme:
        return const Color(0xFF0369A1);
      case NotificationCategory.emergency:
        return const Color(0xFFB91C1C);
    }
  }

  Color get containerColor {
    switch (this) {
      case NotificationCategory.complaintUpdate:
        return const Color(0xFFDCE8FF);
      case NotificationCategory.serviceUpdate:
        return const Color(0xFFCCF0D8);
      case NotificationCategory.panchayatNotice:
        return const Color(0xFFEDE9FE);
      case NotificationCategory.payment:
        return const Color(0xFFFEF3C7);
      case NotificationCategory.scheme:
        return const Color(0xFFE0F2FE);
      case NotificationCategory.emergency:
        return const Color(0xFFFFE4E4);
    }
  }

  String get targetRoute {
    switch (this) {
      case NotificationCategory.complaintUpdate:
        return '/complaints-screen';
      case NotificationCategory.serviceUpdate:
        return '/services-screen';
      case NotificationCategory.panchayatNotice:
        return '/notices-screen';
      case NotificationCategory.payment:
        return '/home-screen';
      case NotificationCategory.scheme:
        return '/schemes-screen';
      case NotificationCategory.emergency:
        return '/notices-screen';
    }
  }
}

class NotificationModel {
  final String id;
  final String title;
  final String titleEn;
  final String message;
  final String messageEn;
  final DateTime dateTime;
  final NotificationCategory category;
  bool isRead;
  final String? referenceId;

  NotificationModel({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.message,
    required this.messageEn,
    required this.dateTime,
    required this.category,
    this.isRead = false,
    this.referenceId,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      id: id,
      title: title,
      titleEn: titleEn,
      message: message,
      messageEn: messageEn,
      dateTime: dateTime,
      category: category,
      isRead: isRead ?? this.isRead,
      referenceId: referenceId,
    );
  }
}
