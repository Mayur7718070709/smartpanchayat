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
    String textValue(List<String> keys, {String fallback = ''}) {
      for (final key in keys) {
        final value = map[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
      return fallback;
    }

    return ServiceFormField(
      id: textValue(['id', 'key', 'name']),
      labelMr: textValue(['labelMr', 'label_mr', 'name_mr']),
      labelEn: textValue([
        'labelEn',
        'label_en',
        'name_en',
        'label',
      ], fallback: textValue(['id', 'key', 'name'])),
      type: textValue(['type', 'field_type'], fallback: 'text'),
      required: (map['required'] as bool?) ?? true,
      options: (map['options'] as List<dynamic>? ?? const [])
          .map(
            (value) => value is Map
                ? (value['label'] ?? value['value']).toString()
                : value.toString(),
          )
          .toList(growable: false),
      hint: (map['hint'] ?? map['placeholder'])?.toString(),
    );
  }
}

class PublishedServiceForm {
  const PublishedServiceForm({
    required this.schemaVersionId,
    required this.version,
    required this.fields,
    required this.requiredDocuments,
    required this.schemaChecksum,
  });

  final String schemaVersionId;
  final int version;
  final List<ServiceFormField> fields;
  final List<String> requiredDocuments;
  final String schemaChecksum;

  factory PublishedServiceForm.fromApi(Map<String, dynamic> map) {
    final definition = map['schema_definition'];
    if (definition is! Map<String, dynamic>) {
      throw const FormatException('Published form schema is invalid.');
    }
    final rawFields = definition['fields'];
    if (rawFields is! List || rawFields.isEmpty) {
      throw const FormatException('Published form contains no fields.');
    }
    final fields = rawFields
        .whereType<Map>()
        .map(
          (field) => ServiceFormField.fromMap(
            field.map((key, value) => MapEntry(key.toString(), value)),
          ),
        )
        .where((field) => field.id.isNotEmpty && field.labelEn.isNotEmpty)
        .toList(growable: false);
    if (fields.length != rawFields.length) {
      throw const FormatException('Published form contains invalid fields.');
    }
    return PublishedServiceForm(
      schemaVersionId: map['schema_version_id'] as String,
      version: map['version'] as int,
      fields: fields,
      requiredDocuments: ServiceModel.documentLabels(
        map['document_requirements'],
      ),
      schemaChecksum: map['schema_checksum'] as String,
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
  final bool isOnline;
  final String? contentStatus;

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
    this.isOnline = true,
    this.contentStatus,
  });

  factory ServiceModel.fromApi(Map<String, dynamic> map) {
    final feeValue = map['fee'];
    final apiDocumentLabels = documentLabels(map['required_documents']);
    final schema = map['form_schema'];
    final rawFields = schema is Map ? schema['fields'] : null;
    final fields = rawFields is List
        ? rawFields
              .whereType<Map>()
              .map(
                (field) => ServiceFormField.fromMap(
                  field.map((key, value) => MapEntry(key.toString(), value)),
                ),
              )
              .where((field) => field.id.isNotEmpty && field.labelEn.isNotEmpty)
              .toList(growable: false)
        : const <ServiceFormField>[];
    final fallbackName = map['name'] as String;
    final fallbackDescription = map['description'] as String? ?? '';

    return ServiceModel(
      id: map['id'] as String,
      nameMr: map['name_mr'] as String? ?? fallbackName,
      nameEn: map['name_en'] as String? ?? fallbackName,
      description: map['description_mr'] as String? ?? fallbackDescription,
      descriptionEn: map['description_en'] as String? ?? fallbackDescription,
      iconName: map['icon_name'] as String? ?? 'miscellaneous_services',
      colorHex: map['color_hex'] as String? ?? '#1565C0',
      category: map['category_name'] as String? ?? 'other',
      processingDays: map['estimated_days'] as int? ?? 0,
      fee: feeValue is num
          ? feeValue.toDouble()
          : double.parse(feeValue.toString()),
      eligibilityMr: map['eligibility_mr'] as String? ?? '',
      eligibilityEn: map['eligibility_en'] as String? ?? '',
      requiredDocuments: apiDocumentLabels,
      formFields: fields,
      isOnline: map['is_online'] as bool? ?? false,
      contentStatus: map['content_status'] as String?,
    );
  }

  static List<String> documentLabels(dynamic documents) {
    final labels = <String>[];
    if (documents is List) {
      for (final item in documents) {
        if (item is String) {
          labels.add(item);
        } else if (item is Map) {
          final label = item['name'] ?? item['label'] ?? item['title'];
          if (label != null) labels.add(label.toString());
        }
      }
    } else if (documents is Map) {
      for (final entry in documents.entries) {
        labels.add(entry.value?.toString() ?? entry.key.toString());
      }
    }
    return labels;
  }

  ServiceModel withPublishedForm(PublishedServiceForm form) => ServiceModel(
    id: id,
    nameMr: nameMr,
    nameEn: nameEn,
    description: description,
    descriptionEn: descriptionEn,
    iconName: iconName,
    colorHex: colorHex,
    category: category,
    processingDays: processingDays,
    fee: fee,
    eligibilityMr: eligibilityMr,
    eligibilityEn: eligibilityEn,
    requiredDocuments: form.requiredDocuments,
    formFields: form.fields,
    isOnline: isOnline,
    contentStatus: contentStatus,
  );

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
        return 'इतर';
      default:
        return category;
    }
  }
}
