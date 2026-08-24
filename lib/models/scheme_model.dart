class SchemeModel {
  final String id;
  final String nameMr;
  final String nameEn;
  final String department;
  final String departmentEn;
  final String shortDescMr;
  final String shortDescEn;
  final String eligibilitySummaryMr;
  final String eligibilitySummaryEn;
  final String category;
  final String aboutMr;
  final String aboutEn;
  final String whoCanApplyMr;
  final String whoCanApplyEn;
  final String benefitsMr;
  final String benefitsEn;
  final String eligibilityMr;
  final String eligibilityEn;
  final List<String> requiredDocuments;
  final List<String> requiredDocumentsEn;
  final String howToApplyMr;
  final String howToApplyEn;
  final String officialSourceUrl;
  final String officialSourceLabel;
  final String officialSourceLabelEn;
  final String lastUpdated;
  final String informationSource;
  final String informationSourceEn;
  final String applyUrl;

  const SchemeModel({
    required this.id,
    required this.nameMr,
    required this.nameEn,
    required this.department,
    required this.departmentEn,
    required this.shortDescMr,
    required this.shortDescEn,
    required this.eligibilitySummaryMr,
    required this.eligibilitySummaryEn,
    required this.category,
    required this.aboutMr,
    required this.aboutEn,
    required this.whoCanApplyMr,
    required this.whoCanApplyEn,
    required this.benefitsMr,
    required this.benefitsEn,
    required this.eligibilityMr,
    required this.eligibilityEn,
    required this.requiredDocuments,
    this.requiredDocumentsEn = const [],
    required this.howToApplyMr,
    required this.howToApplyEn,
    required this.officialSourceUrl,
    required this.officialSourceLabel,
    this.officialSourceLabelEn = '',
    required this.lastUpdated,
    required this.informationSource,
    this.informationSourceEn = '',
    required this.applyUrl,
  });

  factory SchemeModel.fromApi(Map<String, dynamic> json) {
    List<String> strings(String key) =>
        (json[key] as List<dynamic>? ?? const []).cast<String>();

    return SchemeModel(
      id: json['id'] as String,
      nameMr: json['name_mr'] as String,
      nameEn: json['name_en'] as String,
      department: json['department_mr'] as String,
      departmentEn: json['department_en'] as String,
      shortDescMr: json['short_description_mr'] as String,
      shortDescEn: json['short_description_en'] as String,
      eligibilitySummaryMr: json['eligibility_summary_mr'] as String,
      eligibilitySummaryEn: json['eligibility_summary_en'] as String,
      category: (json['category'] as String).toLowerCase(),
      aboutMr: json['about_mr'] as String,
      aboutEn: json['about_en'] as String,
      whoCanApplyMr: json['who_can_apply_mr'] as String,
      whoCanApplyEn: json['who_can_apply_en'] as String,
      benefitsMr: json['benefits_mr'] as String,
      benefitsEn: json['benefits_en'] as String,
      eligibilityMr: json['eligibility_mr'] as String,
      eligibilityEn: json['eligibility_en'] as String,
      requiredDocuments: strings('required_documents_mr'),
      requiredDocumentsEn: strings('required_documents_en'),
      howToApplyMr: json['how_to_apply_mr'] as String,
      howToApplyEn: json['how_to_apply_en'] as String,
      officialSourceUrl: json['official_source_url'] as String,
      officialSourceLabel: json['official_source_label_mr'] as String,
      officialSourceLabelEn: json['official_source_label_en'] as String,
      lastUpdated: json['last_verified_at'] as String,
      informationSource: json['information_source_mr'] as String,
      informationSourceEn: json['information_source_en'] as String,
      applyUrl: json['apply_url'] as String,
    );
  }

  String get categoryLabel {
    switch (category) {
      case 'housing':
        return 'गृहनिर्माण';
      case 'employment':
        return 'रोजगार';
      case 'agriculture':
        return 'शेती';
      case 'health':
        return 'आरोग्य';
      case 'education':
        return 'शिक्षण';
      case 'women':
        return 'महिला';
      case 'sanitation':
        return 'स्वच्छता';
      default:
        return 'इतर';
    }
  }

  String get categoryLabelEn {
    switch (category) {
      case 'housing':
        return 'Housing';
      case 'employment':
        return 'Employment';
      case 'agriculture':
        return 'Agriculture';
      case 'health':
        return 'Health';
      case 'education':
        return 'Education';
      case 'women':
        return 'Women';
      case 'sanitation':
        return 'Sanitation';
      default:
        return 'Other';
    }
  }
}
