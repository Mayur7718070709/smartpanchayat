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
}
