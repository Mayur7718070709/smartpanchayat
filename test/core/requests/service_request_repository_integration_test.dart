import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/config/app_config.dart';
import 'package:smartpanchayat/core/network/api_client.dart';
import 'package:smartpanchayat/core/requests/service_request_repository.dart';

class _Adapter implements HttpClientAdapter {
  _Adapter(this.responses);

  final List<Map<String, dynamic>> responses;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      jsonEncode(responses.removeAt(0)),
      200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

const _config = AppConfig(
  useRealApi: true,
  allowDevMockFallback: false,
  apiBaseUrl: 'https://api.example.test',
  supabaseUrl: 'https://project.supabase.co',
  supabaseAnonKey: 'public-key',
);

void main() {
  test('uses versioned draft and submit endpoints with idempotency', () async {
    final adapter = _Adapter([
      {
        'id': 'draft-id',
        'service_id': 'service-id',
        'state': 'ACTIVE',
        'schema_version_id': 'schema-id',
        'schema_version': 1,
        'schema_checksum': List.filled(64, 'a').join(),
        'form_data': {'name': 'Citizen'},
        'version': 1,
        'expires_at': '2026-09-30T10:00:00Z',
      },
      {
        'id': 'request-id',
        'service_id': 'service-id',
        'citizen_id': 'citizen-id',
        'request_number': 'NERLE-2026-000005',
        'status': 'SUBMITTED',
        'form_data': {'name': 'Citizen'},
        'applicant_note': null,
        'officer_remark': null,
        'rejection_reason': null,
        'submitted_at': '2026-08-31T10:00:00Z',
        'assigned_at': null,
        'completed_at': null,
        'rejected_at': null,
        'cancelled_at': null,
        'created_at': '2026-08-31T10:00:00Z',
        'updated_at': '2026-08-31T10:00:00Z',
      },
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final repository = ServiceRequestRepository(
      ApiClient(
        config: _config,
        tokenProvider: () async => 'access-token',
        dio: dio,
      ),
    );

    final draft = await repository.createDraft(
      serviceId: 'service-id',
      schemaVersion: 1,
      formData: const {'name': 'Citizen'},
      idempotencyKey: 'draft-key',
    );
    final request = await repository.submitDraft(
      draftId: draft.id,
      expectedVersion: draft.version,
      idempotencyKey: 'submit-key',
    );

    expect(adapter.requests[0].path, '/api/v1/service-request-drafts');
    expect(adapter.requests[0].headers['Idempotency-Key'], 'draft-key');
    expect(
      adapter.requests[1].path,
      '/api/v1/service-request-drafts/draft-id/submit',
    );
    expect(adapter.requests[1].headers['Idempotency-Key'], 'submit-key');
    expect(request.requestNumber, 'NERLE-2026-000005');
  });
}
