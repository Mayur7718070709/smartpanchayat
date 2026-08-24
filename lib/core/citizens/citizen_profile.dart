class CitizenProfile {
  const CitizenProfile({
    required this.id,
    required this.fullName,
    required this.preferredLanguage,
    required this.createdAt,
    required this.updatedAt,
    this.address,
    this.ward,
    this.gender,
    this.dateOfBirth,
    this.profilePhotoPath,
    this.wardId,
    this.wardNameEn,
    this.wardNameMr,
  });

  factory CitizenProfile.fromJson(Map<String, dynamic> json) => CitizenProfile(
    id: json['id'] as String,
    fullName: json['full_name'] as String,
    address: json['address'] as String?,
    ward: json['ward'] as String?,
    gender: json['gender'] as String?,
    dateOfBirth: json['date_of_birth'] == null
        ? null
        : DateTime.parse(json['date_of_birth'] as String),
    profilePhotoPath: json['profile_photo_path'] as String?,
    wardId: json['ward_id'] as String?,
    wardNameEn: json['ward_name_en'] as String?,
    wardNameMr: json['ward_name_mr'] as String?,
    preferredLanguage: json['preferred_language'] as String,
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  final String id;
  final String fullName;
  final String? address;
  final String? ward;
  final String? gender;
  final DateTime? dateOfBirth;
  final String? profilePhotoPath;
  final String? wardId;
  final String? wardNameEn;
  final String? wardNameMr;
  final String preferredLanguage;
  final DateTime createdAt;
  final DateTime updatedAt;
}
