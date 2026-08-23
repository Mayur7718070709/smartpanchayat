import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/config/app_config.dart';
import 'package:smartpanchayat/core/network/api_client.dart';
import 'package:smartpanchayat/core/network/api_exception.dart';

class _FakeAdapter implements HttpClientAdapter {
  _FakeAdapter(this.outcomes);

  final List<Object> outcomes;
  final List<RequestOptions> requests = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    final outcome = outcomes.removeAt(0);
    if (outcome is Exception) throw outcome;
    return ResponseBody.fromString(
      jsonEncode(outcome),
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
  test('adds bearer token without caller-supplied identity', () async {
    final adapter = _FakeAdapter([
      {'ok': true},
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ApiClient(
      config: _config,
      tokenProvider: () async => 'access-token',
      dio: dio,
    );

    final result = await client.get<Map<String, dynamic>>('/api/v1/auth/context');

    expect(result['ok'], isTrue);
    expect(adapter.requests.single.headers['Authorization'], 'Bearer access-token');
    expect(adapter.requests.single.queryParameters, isEmpty);
  });

  test('public request can explicitly omit authorization', () async {
    final adapter = _FakeAdapter([
      {'status': 'healthy'},
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ApiClient(
      config: _config,
      tokenProvider: () async => 'access-token',
      dio: dio,
    );

    await client.get<Map<String, dynamic>>('/health', requiresAuth: false);

    expect(adapter.requests.single.headers['Authorization'], isNull);
  });

  test('GET retries one transient connection failure', () async {
    final request = RequestOptions(path: '/services');
    final adapter = _FakeAdapter([
      DioException(
        requestOptions: request,
        type: DioExceptionType.connectionError,
      ),
      {'items': <dynamic>[]},
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ApiClient(
      config: _config,
      tokenProvider: () async => 'access-token',
      dio: dio,
    );

    final result = await client.get<Map<String, dynamic>>('/api/v1/services');

    expect(result['items'], isEmpty);
    expect(adapter.requests, hasLength(2));
  });

  test('POST is never automatically retried', () async {
    final request = RequestOptions(path: '/service-requests');
    final adapter = _FakeAdapter([
      DioException(
        requestOptions: request,
        type: DioExceptionType.connectionError,
      ),
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ApiClient(
      config: _config,
      tokenProvider: () async => 'access-token',
      dio: dio,
    );

    await expectLater(
      client.post<Map<String, dynamic>>('/api/v1/service-requests', data: {}),
      throwsA(isA<ApiException>()),
    );
    expect(adapter.requests, hasLength(1));
  });

  test('authenticated request fails locally when session is missing', () async {
    final adapter = _FakeAdapter([
      {'shouldNot': 'be called'},
    ]);
    final dio = Dio()..httpClientAdapter = adapter;
    final client = ApiClient(
      config: _config,
      tokenProvider: () async => null,
      dio: dio,
    );

    await expectLater(
      client.get<Map<String, dynamic>>('/api/v1/auth/context'),
      throwsA(
        isA<ApiException>().having(
          (error) => error.code,
          'code',
          ApiErrorCode.authenticationRequired,
        ),
      ),
    );
    expect(adapter.requests, isEmpty);
  });
}
