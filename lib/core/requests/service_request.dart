class ServiceRequest {
  const ServiceRequest({
    required this.id,
    required this.serviceId,
    required this.citizenId,
    required this.requestNumber,
    required this.status,
    required this.formData,
    required this.createdAt,
    required this.updatedAt,
    this.applicantNote,
    this.officerRemark,
    this.rejectionReason,
    this.submittedAt,
    this.assignedAt,
    this.completedAt,
    this.rejectedAt,
    this.cancelledAt,
  });

  factory ServiceRequest.fromJson(Map<String, dynamic> json) => ServiceRequest(
    id: json['id'] as String,
    serviceId: json['service_id'] as String,
    citizenId: json['citizen_id'] as String,
    requestNumber: json['request_number'] as String,
    status: json['status'] as String,
    formData: Map<String, dynamic>.from(json['form_data'] as Map),
    applicantNote: json['applicant_note'] as String?,
    officerRemark: json['officer_remark'] as String?,
    rejectionReason: json['rejection_reason'] as String?,
    submittedAt: _date(json['submitted_at']),
    assignedAt: _date(json['assigned_at']),
    completedAt: _date(json['completed_at']),
    rejectedAt: _date(json['rejected_at']),
    cancelledAt: _date(json['cancelled_at']),
    createdAt: DateTime.parse(json['created_at'] as String),
    updatedAt: DateTime.parse(json['updated_at'] as String),
  );

  final String id;
  final String serviceId;
  final String citizenId;
  final String requestNumber;
  final String status;
  final Map<String, dynamic> formData;
  final String? applicantNote;
  final String? officerRemark;
  final String? rejectionReason;
  final DateTime? submittedAt;
  final DateTime? assignedAt;
  final DateTime? completedAt;
  final DateTime? rejectedAt;
  final DateTime? cancelledAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  static DateTime? _date(dynamic value) =>
      value == null ? null : DateTime.parse(value as String);
}

class ServiceRequestStatusHistory {
  const ServiceRequestStatusHistory({
    required this.id,
    required this.serviceRequestId,
    required this.newStatus,
    required this.changedAt,
    this.previousStatus,
    this.changedBy,
    this.remark,
  });

  factory ServiceRequestStatusHistory.fromJson(Map<String, dynamic> json) =>
      ServiceRequestStatusHistory(
        id: json['id'] as String,
        serviceRequestId: json['service_request_id'] as String,
        previousStatus: json['previous_status'] as String?,
        newStatus: json['new_status'] as String,
        changedBy: json['changed_by'] as String?,
        remark: json['remark'] as String?,
        changedAt: DateTime.parse(json['changed_at'] as String),
      );

  final String id;
  final String serviceRequestId;
  final String? previousStatus;
  final String newStatus;
  final String? changedBy;
  final String? remark;
  final DateTime changedAt;
}

class ServiceRequestDocument {
  const ServiceRequestDocument({
    required this.id,
    required this.documentCode,
    required this.filename,
    required this.status,
    this.rejectionReason,
  });
  final String id;
  final String documentCode;
  final String filename;
  final String status;
  final String? rejectionReason;
  factory ServiceRequestDocument.fromJson(Map<String, dynamic> json) =>
      ServiceRequestDocument(
        id: json['id'] as String,
        documentCode: json['document_code'] as String,
        filename: json['original_filename'] as String,
        status: json['status'] as String,
        rejectionReason: json['rejection_reason'] as String?,
      );
}

class ServiceRequestCorrection {
  const ServiceRequestCorrection({
    required this.reason,
    required this.status,
    this.documentCode,
  });
  final String reason;
  final String status;
  final String? documentCode;
  factory ServiceRequestCorrection.fromJson(Map<String, dynamic> json) =>
      ServiceRequestCorrection(
        reason: json['reason'] as String,
        status: json['status'] as String,
        documentCode: json['document_code'] as String?,
      );
}

class ServiceRequestDraft {
  const ServiceRequestDraft({
    required this.id,
    required this.serviceId,
    required this.state,
    required this.schemaVersionId,
    required this.schemaVersion,
    required this.schemaChecksum,
    required this.formData,
    required this.version,
    required this.expiresAt,
  });

  factory ServiceRequestDraft.fromJson(Map<String, dynamic> json) =>
      ServiceRequestDraft(
        id: json['id'] as String,
        serviceId: json['service_id'] as String,
        state: json['state'] as String,
        schemaVersionId: json['schema_version_id'] as String,
        schemaVersion: json['schema_version'] as int,
        schemaChecksum: json['schema_checksum'] as String,
        formData: Map<String, dynamic>.from(json['form_data'] as Map),
        version: json['version'] as int,
        expiresAt: DateTime.parse(json['expires_at'] as String),
      );

  final String id;
  final String serviceId;
  final String state;
  final String schemaVersionId;
  final int schemaVersion;
  final String schemaChecksum;
  final Map<String, dynamic> formData;
  final int version;
  final DateTime expiresAt;
}

class ServiceRequestDraftDocument {
  const ServiceRequestDraftDocument({
    required this.id,
    required this.draftId,
    required this.documentCode,
    required this.filename,
    required this.mimeType,
    required this.sizeBytes,
    required this.sha256,
    required this.status,
  });

  factory ServiceRequestDraftDocument.fromJson(Map<String, dynamic> json) =>
      ServiceRequestDraftDocument(
        id: json['id'] as String,
        draftId: json['draft_id'] as String,
        documentCode: json['document_code'] as String,
        filename: json['original_filename'] as String,
        mimeType: json['mime_type'] as String,
        sizeBytes: json['size_bytes'] as int,
        sha256: json['sha256'] as String,
        status: json['status'] as String,
      );

  final String id;
  final String draftId;
  final String documentCode;
  final String filename;
  final String mimeType;
  final int sizeBytes;
  final String sha256;
  final String status;
}
