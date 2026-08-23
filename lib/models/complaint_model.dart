import 'package:flutter/material.dart';

enum ComplaintCategory {
  water,
  roads,
  streetLights,
  garbage,
  drainage,
  publicFacilities,
  documents,
  other,
}

enum ComplaintStatus { submitted, assigned, inProgress, resolved, closed }

extension ComplaintCategoryExt on ComplaintCategory {
  String get apiValue => switch (this) {
    ComplaintCategory.water => 'WATER',
    ComplaintCategory.roads => 'ROADS',
    ComplaintCategory.streetLights => 'STREET_LIGHTS',
    ComplaintCategory.garbage => 'GARBAGE',
    ComplaintCategory.drainage => 'DRAINAGE',
    ComplaintCategory.publicFacilities => 'PUBLIC_FACILITIES',
    ComplaintCategory.documents => 'DOCUMENTS',
    ComplaintCategory.other => 'OTHER',
  };

  static ComplaintCategory fromApi(String value) =>
      ComplaintCategory.values.firstWhere(
        (item) => item.apiValue == value,
        orElse: () => ComplaintCategory.other,
      );
  String get labelMr {
    switch (this) {
      case ComplaintCategory.water:
        return 'पाणी';
      case ComplaintCategory.roads:
        return 'रस्ते';
      case ComplaintCategory.streetLights:
        return 'पथदिवे';
      case ComplaintCategory.garbage:
        return 'कचरा';
      case ComplaintCategory.drainage:
        return 'गटार';
      case ComplaintCategory.publicFacilities:
        return 'सार्वजनिक सुविधा';
      case ComplaintCategory.documents:
        return 'कागदपत्रे';
      case ComplaintCategory.other:
        return 'इतर';
    }
  }

  String get labelEn {
    switch (this) {
      case ComplaintCategory.water:
        return 'Water';
      case ComplaintCategory.roads:
        return 'Roads';
      case ComplaintCategory.streetLights:
        return 'Street Lights';
      case ComplaintCategory.garbage:
        return 'Garbage';
      case ComplaintCategory.drainage:
        return 'Drainage';
      case ComplaintCategory.publicFacilities:
        return 'Public Facilities';
      case ComplaintCategory.documents:
        return 'Documents';
      case ComplaintCategory.other:
        return 'Other';
    }
  }

  IconData get icon {
    switch (this) {
      case ComplaintCategory.water:
        return Icons.water_drop_rounded;
      case ComplaintCategory.roads:
        return Icons.add_road_rounded;
      case ComplaintCategory.streetLights:
        return Icons.lightbulb_rounded;
      case ComplaintCategory.garbage:
        return Icons.delete_rounded;
      case ComplaintCategory.drainage:
        return Icons.water_rounded;
      case ComplaintCategory.publicFacilities:
        return Icons.account_balance_rounded;
      case ComplaintCategory.documents:
        return Icons.description_rounded;
      case ComplaintCategory.other:
        return Icons.more_horiz_rounded;
    }
  }

  Color get color {
    switch (this) {
      case ComplaintCategory.water:
        return const Color(0xFF0369A1);
      case ComplaintCategory.roads:
        return const Color(0xFF78350F);
      case ComplaintCategory.streetLights:
        return const Color(0xFFD97706);
      case ComplaintCategory.garbage:
        return const Color(0xFF15803D);
      case ComplaintCategory.drainage:
        return const Color(0xFF1E40AF);
      case ComplaintCategory.publicFacilities:
        return const Color(0xFF7C3AED);
      case ComplaintCategory.documents:
        return const Color(0xFF0F766E);
      case ComplaintCategory.other:
        return const Color(0xFF475569);
    }
  }
}

extension ComplaintStatusExt on ComplaintStatus {
  String get apiValue => switch (this) {
    ComplaintStatus.submitted => 'SUBMITTED',
    ComplaintStatus.assigned => 'ASSIGNED',
    ComplaintStatus.inProgress => 'IN_PROGRESS',
    ComplaintStatus.resolved => 'RESOLVED',
    ComplaintStatus.closed => 'CLOSED',
  };

  static ComplaintStatus fromApi(String value) =>
      ComplaintStatus.values.firstWhere(
        (item) => item.apiValue == value,
        orElse: () => ComplaintStatus.submitted,
      );
  String get labelMr {
    switch (this) {
      case ComplaintStatus.submitted:
        return 'सादर केली';
      case ComplaintStatus.assigned:
        return 'नियुक्त केली';
      case ComplaintStatus.inProgress:
        return 'प्रक्रियेत';
      case ComplaintStatus.resolved:
        return 'निराकरण झाले';
      case ComplaintStatus.closed:
        return 'बंद';
    }
  }

  String get labelEn {
    switch (this) {
      case ComplaintStatus.submitted:
        return 'Submitted';
      case ComplaintStatus.assigned:
        return 'Assigned';
      case ComplaintStatus.inProgress:
        return 'In Progress';
      case ComplaintStatus.resolved:
        return 'Resolved';
      case ComplaintStatus.closed:
        return 'Closed';
    }
  }

  Color get color {
    switch (this) {
      case ComplaintStatus.submitted:
        return const Color(0xFF1A56DB);
      case ComplaintStatus.assigned:
        return const Color(0xFF7C3AED);
      case ComplaintStatus.inProgress:
        return const Color(0xFFD97706);
      case ComplaintStatus.resolved:
        return const Color(0xFF15803D);
      case ComplaintStatus.closed:
        return const Color(0xFF475569);
    }
  }

  IconData get icon {
    switch (this) {
      case ComplaintStatus.submitted:
        return Icons.send_rounded;
      case ComplaintStatus.assigned:
        return Icons.person_pin_rounded;
      case ComplaintStatus.inProgress:
        return Icons.engineering_rounded;
      case ComplaintStatus.resolved:
        return Icons.check_circle_rounded;
      case ComplaintStatus.closed:
        return Icons.lock_rounded;
    }
  }
}

class ComplaintTimelineEvent {
  final ComplaintStatus status;
  final DateTime dateTime;
  final String? officerRemark;
  final String? officerName;

  const ComplaintTimelineEvent({
    required this.status,
    required this.dateTime,
    this.officerRemark,
    this.officerName,
  });
}

class ComplaintModel {
  final String id;
  final String complaintId;
  final ComplaintCategory category;
  final String description;
  final String? photoUrl;
  final String? location;
  final ComplaintStatus currentStatus;
  final DateTime submittedAt;
  final List<ComplaintTimelineEvent> timeline;
  final int? rating;
  final String? additionalInfo;
  final bool canReopen;

  const ComplaintModel({
    required this.id,
    required this.complaintId,
    required this.category,
    required this.description,
    this.photoUrl,
    this.location,
    required this.currentStatus,
    required this.submittedAt,
    required this.timeline,
    this.rating,
    this.additionalInfo,
    this.canReopen = false,
  });

  factory ComplaintModel.fromJson(
    Map<String, dynamic> json, {
    List<ComplaintTimelineEvent> timeline = const [],
  }) {
    return ComplaintModel(
      id: json['id'] as String,
      complaintId: json['complaint_number'] as String,
      category: ComplaintCategoryExt.fromApi(json['category'] as String),
      description: json['description'] as String,
      location: json['location'] as String?,
      currentStatus: ComplaintStatusExt.fromApi(json['status'] as String),
      submittedAt: DateTime.parse(json['submitted_at'] as String),
      timeline: timeline,
      rating: json['rating'] as int?,
      canReopen: json['can_reopen'] as bool? ?? false,
    );
  }
}
