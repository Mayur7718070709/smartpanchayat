class NoticeModel {
  final String id;
  final String title;
  final String titleEn;
  final String description;
  final String descriptionEn;
  final String fullContent;
  final String fullContentEn;
  final String date;
  final String category;
  final bool isUnread;
  final String? attachmentUrl;
  final String? attachmentName;
  final String panchayatName;
  final String panchayatNameEn;
  final String district;
  final String taluka;
  final String issuedBy;

  const NoticeModel({
    required this.id,
    required this.title,
    required this.titleEn,
    required this.description,
    required this.descriptionEn,
    required this.fullContent,
    required this.fullContentEn,
    required this.date,
    required this.category,
    required this.isUnread,
    this.attachmentUrl,
    this.attachmentName,
    required this.panchayatName,
    required this.panchayatNameEn,
    required this.district,
    required this.taluka,
    required this.issuedBy,
  });

  factory NoticeModel.fromMap(Map<String, dynamic> map) {
    return NoticeModel(
      id: map['id'] as String,
      title: map['title'] as String,
      titleEn: map['titleEn'] as String,
      description: map['description'] as String,
      descriptionEn: map['descriptionEn'] as String,
      fullContent:
          map['fullContent'] as String? ?? map['description'] as String,
      fullContentEn:
          map['fullContentEn'] as String? ?? map['descriptionEn'] as String,
      date: map['date'] as String,
      category: map['category'] as String,
      isUnread: map['isUnread'] as bool,
      attachmentUrl: map['attachmentUrl'] as String?,
      attachmentName: map['attachmentName'] as String?,
      panchayatName: map['panchayatName'] as String? ?? 'नेर्ले ग्रामपंचायत',
      panchayatNameEn:
          map['panchayatNameEn'] as String? ?? 'Nerle Gram Panchayat',
      district: map['district'] as String? ?? 'सांगली',
      taluka: map['taluka'] as String? ?? 'वेल्हे',
      issuedBy: map['issuedBy'] as String? ?? 'ग्रामसेवक',
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'titleEn': titleEn,
    'description': description,
    'descriptionEn': descriptionEn,
    'fullContent': fullContent,
    'fullContentEn': fullContentEn,
    'date': date,
    'category': category,
    'isUnread': isUnread,
    'attachmentUrl': attachmentUrl,
    'attachmentName': attachmentName,
    'panchayatName': panchayatName,
    'panchayatNameEn': panchayatNameEn,
    'district': district,
    'taluka': taluka,
    'issuedBy': issuedBy,
  };

  /// Returns the display label for the category
  String get categoryLabel {
    switch (category) {
      case 'emergency':
        return 'आपत्कालीन';
      case 'important':
        return 'महत्त्वाचे';
      case 'government':
        return 'शासकीय';
      case 'event':
        return 'कार्यक्रम';
      case 'general':
      default:
        return 'सामान्य';
    }
  }

  String get categoryLabelEn {
    switch (category) {
      case 'emergency':
        return 'Emergency';
      case 'important':
        return 'Important';
      case 'government':
        return 'Government';
      case 'event':
        return 'Event';
      case 'general':
      default:
        return 'General';
    }
  }
}
