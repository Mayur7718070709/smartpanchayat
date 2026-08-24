import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/app_config.dart';
import 'api_exception.dart';
import 'auth_interceptor.dart';

class ApiClient {
  ApiClient({
    required AppConfig config,
    required AccessTokenProvider tokenProvider,
    Dio? dio,
  }) : _dio = dio ?? Dio() {
    final configurationErrors = config.validate();
    if (configurationErrors.isNotEmpty) {
      throw StateError(configurationErrors.join(' '));
    }

    _dio.options = BaseOptions(
      baseUrl: config.apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 20),
      responseType: ResponseType.json,
      contentType: Headers.jsonContentType,
      headers: const {'Accept': Headers.jsonContentType},
    );
    _dio.interceptors.add(AuthInterceptor(tokenProvider));
    if (kDebugMode) _dio.interceptors.add(_RedactedLogInterceptor());
  }

  final Dio _dio;

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool requiresAuth = true,
    T Function(dynamic data)? decode,
  }) async {
    const maximumAttempts = 2;
    for (var attempt = 1; attempt <= maximumAttempts; attempt++) {
      try {
        final response = await _dio.get<dynamic>(
          path,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          options: Options(extra: {'requiresAuth': requiresAuth}),
        );
        return decode == null ? response.data as T : decode(response.data);
      } on DioException catch (error) {
        if (attempt < maximumAttempts && _isRetryableRead(error)) continue;
        throw ApiException.fromDio(error);
      }
    }
    throw const ApiException(
      code: ApiErrorCode.unknownError,
      message: 'The request could not be completed.',
    );
  }

  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? headers,
    CancelToken? cancelToken,
    T Function(dynamic data)? decode,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: data,
        cancelToken: cancelToken,
        options: Options(extra: const {'requiresAuth': true}, headers: headers),
      );
      return decode == null ? response.data as T : decode(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<T> postBytes<T>(
    String path,
    List<int> data, {
    required String contentType,
    T Function(dynamic data)? decode,
  }) => post<T>(
    path,
    data: data,
    headers: {'Content-Type': contentType},
    decode: decode,
  );

  Future<T> delete<T>(String path, {T Function(dynamic data)? decode}) async {
    try {
      final response = await _dio.delete<dynamic>(
        path,
        options: Options(extra: const {'requiresAuth': true}),
      );
      return decode == null ? response.data as T : decode(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  Future<T> put<T>(
    String path, {
    Object? data,
    T Function(dynamic data)? decode,
  }) async {
    try {
      final response = await _dio.put<dynamic>(
        path,
        data: data,
        options: Options(extra: const {'requiresAuth': true}),
      );
      return decode == null ? response.data as T : decode(response.data);
    } on DioException catch (error) {
      throw ApiException.fromDio(error);
    }
  }

  bool _isRetryableRead(DioException error) {
    if (error.type == DioExceptionType.connectionError ||
        error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return true;
    }
    final status = error.response?.statusCode;
    return status != null && status >= 500;
  }
}

class _RedactedLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('API → ${options.method} ${options.uri.path}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'API ← ${response.requestOptions.method} '
      '${response.requestOptions.uri.path} ${response.statusCode}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    debugPrint(
      'API ! ${error.requestOptions.method} '
      '${error.requestOptions.uri.path} ${error.response?.statusCode ?? 'transport'}',
    );
    handler.next(error);
  }
}
