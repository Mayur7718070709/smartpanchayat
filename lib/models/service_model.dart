import 'package:flutter/material.dart';

class ServiceFormField {
  final String id;
  final String labelMr;
  final String labelEn;
  final String
  type; // text, number, date, dropdown, radio, checkbox, document, photo
  final bool required;
  final List<String> options; // for dropdown/radio/checkbox
  final String? hint;

  const ServiceFormField({
    required this.id,
    required this.labelMr,
    required this.labelEn,
    required this.type,
    this.required = true,
    this.options = const [],
    this.hint,
  });

  factory ServiceFormField.fromMap(Map<String, dynamic> map) {
    return ServiceFormField(
      id: map['id'] as String,
      labelMr: map['labelMr'] as String,
      labelEn: map['labelEn'] as String,
      type: map['type'] as String,
      required: (map['required'] as bool?) ?? true,
      options: List<String>.from(map['options'] ?? []),
      hint: map['hint'] as String?,
    );
  }
}

class ServiceModel {
  final String id;
  final String nameMr;
  final String nameEn;
  final String description;
  final String descriptionEn;
  final String iconName;
  final String colorHex;
  final String category;
  final int processingDays;
  final double fee;
  final String eligibilityMr;
  final String eligibilityEn;
  final List<String> requiredDocuments;
  final List<ServiceFormField> formFields;

  const ServiceModel({
    required this.id,
    required this.nameMr,
    required this.nameEn,
    required this.description,
    required this.descriptionEn,
    required this.iconName,
    required this.colorHex,
    required this.category,
    required this.processingDays,
    required this.fee,
    this.eligibilityMr = 'ग्रामपंचायत क्षेत्रातील कोणताही नागरिक',
    this.eligibilityEn = 'Any citizen within the Gram Panchayat area',
    this.requiredDocuments = const [],
    this.formFields = const [],
  });

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as String,
      nameMr: map['nameMr'] as String,
      nameEn: map['nameEn'] as String,
      description: map['description'] as String,
      descriptionEn: map['descriptionEn'] as String,
      iconName: map['iconName'] as String,
      colorHex: map['colorHex'] as String,
      category: map['category'] as String,
      processingDays: map['processingDays'] as int,
      fee: (map['fee'] as num).toDouble(),
      eligibilityMr:
          (map['eligibilityMr'] as String?) ??
          'ग्रामपंचायत क्षेत्रातील कोणताही नागरिक',
      eligibilityEn:
          (map['eligibilityEn'] as String?) ??
          'Any citizen within the Gram Panchayat area',
      requiredDocuments: List<String>.from(map['requiredDocuments'] ?? []),
      formFields: (map['formFields'] as List<dynamic>? ?? [])
          .map((f) => ServiceFormField.fromMap(f as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nameMr': nameMr,
    'nameEn': nameEn,
    'description': description,
    'descriptionEn': descriptionEn,
    'iconName': iconName,
    'colorHex': colorHex,
    'category': category,
    'processingDays': processingDays,
    'fee': fee,
    'eligibilityMr': eligibilityMr,
    'eligibilityEn': eligibilityEn,
    'requiredDocuments': requiredDocuments,
  };

  Color get color {
    final hex = colorHex.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  IconData get icon {
    const iconMap = <String, IconData>{
      'child_care': Icons.child_care_rounded,
      'assignment': Icons.assignment_rounded,
      'home_work': Icons.home_work_rounded,
      'account_balance_wallet': Icons.account_balance_wallet_rounded,
      'villa': Icons.villa_rounded,
      'water_drop': Icons.water_drop_rounded,
      'construction': Icons.construction_rounded,
      'more_horiz': Icons.more_horiz_rounded,
      'water': Icons.water_rounded,
      'plumbing': Icons.plumbing_rounded,
      'description': Icons.description_rounded,
      'folder_open': Icons.folder_open_rounded,
      'app_registration': Icons.app_registration_rounded,
      'how_to_reg': Icons.how_to_reg_rounded,
      'receipt_long': Icons.receipt_long_rounded,
    };
    return iconMap[iconName] ?? Icons.miscellaneous_services_rounded;
  }

  String get categoryLabel {
    switch (category) {
      case 'certificate':
        return 'दाखला';
      case 'tax':
        return 'कर';
      case 'permit':
        return 'परवाना';
      case 'water':
        return 'पाणी';
      case 'applications':
        return 'अर्ज';
      case 'documents':
        return 'कागदपत्रे';
      case 'other':
      default:
        return 'इतर';
    }
  }
}
