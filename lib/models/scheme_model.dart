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
  final String howToApplyMr;
  final String howToApplyEn;
  final String officialSourceUrl;
  final String officialSourceLabel;
  final String lastUpdated;
  final String informationSource;
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
    required this.howToApplyMr,
    required this.howToApplyEn,
    required this.officialSourceUrl,
    required this.officialSourceLabel,
    required this.lastUpdated,
    required this.informationSource,
    required this.applyUrl,
  });

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
