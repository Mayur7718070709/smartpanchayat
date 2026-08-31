import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/requests/service_request.dart';

void main() {
  test('decodes the FastAPI service-request contract', () {
    final request = ServiceRequest.fromJson({
      'id': 'request-id',
      'service_id': 'service-id',
      'citizen_id': 'citizen-id',
      'request_number': 'NERLE-2026-000004',
      'status': 'CANCELLED',
      'form_data': {'reason': 'test'},
      'applicant_note': null,
      'officer_remark': 'Closed',
      'rejection_reason': null,
      'submitted_at': '2026-08-20T10:00:00Z',
      'assigned_at': null,
      'completed_at': null,
      'rejected_at': null,
      'cancelled_at': '2026-08-21T10:00:00Z',
      'created_at': '2026-08-20T10:00:00Z',
      'updated_at': '2026-08-21T10:00:00Z',
    });

    expect(request.requestNumber, 'NERLE-2026-000004');
    expect(request.status, 'CANCELLED');
    expect(request.formData['reason'], 'test');
    expect(request.cancelledAt, isNotNull);
  });

  test('decodes an ordered history row', () {
    final history = ServiceRequestStatusHistory.fromJson({
      'id': 'history-id',
      'service_request_id': 'request-id',
      'previous_status': 'SUBMITTED',
      'new_status': 'UNDER_REVIEW',
      'changed_by': null,
      'remark': 'Review started',
      'changed_at': '2026-08-20T12:00:00Z',
    });

    expect(history.previousStatus, 'SUBMITTED');
    expect(history.newStatus, 'UNDER_REVIEW');
    expect(history.remark, 'Review started');
  });

  test('decodes a versioned service-request draft', () {
    final draft = ServiceRequestDraft.fromJson({
      'id': 'draft-id',
      'service_id': 'service-id',
      'state': 'ACTIVE',
      'schema_version_id': 'schema-id',
      'schema_version': 1,
      'schema_checksum': List.filled(64, 'a').join(),
      'form_data': {'applicant_name': 'Mayur'},
      'version': 1,
      'expires_at': '2026-09-30T10:00:00Z',
    });

    expect(draft.state, 'ACTIVE');
    expect(draft.schemaVersion, 1);
    expect(draft.formData['applicant_name'], 'Mayur');
  });

  test('decodes a private draft document receipt', () {
    final document = ServiceRequestDraftDocument.fromJson({
      'id': 'document-id',
      'draft_id': 'draft-id',
      'document_code': 'aadhaar_card',
      'original_filename': 'aadhaar.pdf',
      'mime_type': 'application/pdf',
      'size_bytes': 1024,
      'sha256': List.filled(64, 'b').join(),
      'status': 'UPLOADED',
    });

    expect(document.documentCode, 'aadhaar_card');
    expect(document.mimeType, 'application/pdf');
    expect(document.status, 'UPLOADED');
  });
}
