class PanchayatProfile {
  const PanchayatProfile({
    required this.id,
    required this.name,
    required this.code,
    this.address,
    this.village,
    this.taluka,
    this.district,
    this.state,
    this.pincode,
    this.phone,
    this.email,
  });
  factory PanchayatProfile.fromJson(Map<String, dynamic> j) => PanchayatProfile(
    id: j['id'] as String,
    name: j['name'] as String,
    code: j['code'] as String,
    address: j['address'] as String?,
    village: j['village'] as String?,
    taluka: j['taluka'] as String?,
    district: j['district'] as String?,
    state: j['state'] as String?,
    pincode: j['pincode'] as String?,
    phone: j['phone'] as String?,
    email: j['email'] as String?,
  );
  final String id, name, code;
  final String? address,
      village,
      taluka,
      district,
      state,
      pincode,
      phone,
      email;
}

class OfficialContact {
  const OfficialContact({
    required this.id,
    required this.nameEn,
    required this.nameMr,
    required this.type,
    this.designationEn,
    this.designationMr,
    this.phone,
    this.email,
  });
  factory OfficialContact.fromJson(Map<String, dynamic> j) => OfficialContact(
    id: j['id'] as String,
    type: j['contact_type'] as String,
    nameEn: j['name_en'] as String,
    nameMr: j['name_mr'] as String,
    designationEn: j['designation_en'] as String?,
    designationMr: j['designation_mr'] as String?,
    phone: j['phone'] as String?,
    email: j['email'] as String?,
  );
  final String id, type, nameEn, nameMr;
  final String? designationEn, designationMr, phone, email;
}

class PanchayatEvent {
  const PanchayatEvent({
    required this.id,
    required this.titleEn,
    required this.titleMr,
    required this.descriptionEn,
    required this.descriptionMr,
    required this.venueEn,
    required this.venueMr,
    required this.startsAt,
    this.endsAt,
  });
  factory PanchayatEvent.fromJson(Map<String, dynamic> j) => PanchayatEvent(
    id: j['id'] as String,
    titleEn: j['title_en'] as String,
    titleMr: j['title_mr'] as String,
    descriptionEn: j['description_en'] as String,
    descriptionMr: j['description_mr'] as String,
    venueEn: j['venue_en'] as String,
    venueMr: j['venue_mr'] as String,
    startsAt: DateTime.parse(j['starts_at'] as String),
    endsAt: j['ends_at'] == null
        ? null
        : DateTime.parse(j['ends_at'] as String),
  );
  final String id,
      titleEn,
      titleMr,
      descriptionEn,
      descriptionMr,
      venueEn,
      venueMr;
  final DateTime startsAt;
  final DateTime? endsAt;
}
