import 'package:dio/dio.dart';

import 'auth_interceptor.dart';

enum ApiErrorCode {
  authenticationRequired('AUTHENTICATION_REQUIRED'),
  forbidden('FORBIDDEN'),
  validationError('VALIDATION_ERROR'),
  notFound('NOT_FOUND'),
  databaseContractGap('DATABASE_CONTRACT_GAP'),
  featureNotEnabled('FEATURE_NOT_ENABLED'),
  connectivityError('CONNECTIVITY_ERROR'),
  timeout('TIMEOUT'),
  serverError('SERVER_ERROR'),
  unknownError('UNKNOWN_ERROR');

  const ApiErrorCode(this.wireValue);
  final String wireValue;
}

class ApiException implements Exception {
  const ApiException({
    required this.code,
    required this.message,
    this.statusCode,
    this.details = const <String, dynamic>{},
  });

  final ApiErrorCode code;
  final String message;
  final int? statusCode;
  final Map<String, dynamic> details;

  factory ApiException.fromDio(DioException error) {
    if (error.error is MissingAccessToken) {
      return const ApiException(
        code: ApiErrorCode.authenticationRequired,
        message: 'Please sign in again.',
        statusCode: 401,
      );
    }
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const ApiException(
        code: ApiErrorCode.timeout,
        message: 'The request timed out.',
      );
    }
    if (error.type == DioExceptionType.connectionError) {
      return const ApiException(
        code: ApiErrorCode.connectivityError,
        message: 'Unable to connect to the service.',
      );
    }

    final response = error.response;
    final status = response?.statusCode;
    final payload = response?.data;
    final errorBody = payload is Map ? payload['error'] : null;
    final body = errorBody is Map ? errorBody : const <String, dynamic>{};
    final wireCode = body['code']?.toString();
    final message = body['message']?.toString() ?? _messageForStatus(status);
    final rawDetails = body['details'];
    final details = rawDetails is Map
        ? rawDetails.map((key, value) => MapEntry(key.toString(), value))
        : const <String, dynamic>{};

    return ApiException(
      code: _codeFor(wireCode, status),
      message: message,
      statusCode: status,
      details: details,
    );
  }

  static ApiErrorCode _codeFor(String? wireCode, int? status) {
    if (wireCode == 'DATABASE_CONTRACT_GAP') {
      return ApiErrorCode.databaseContractGap;
    }
    if (wireCode == 'FEATURE_NOT_ENABLED') {
      return ApiErrorCode.featureNotEnabled;
    }
    if (status == 401) return ApiErrorCode.authenticationRequired;
    if (status == 403) return ApiErrorCode.forbidden;
    if (status == 404) return ApiErrorCode.notFound;
    if (status == 422) return ApiErrorCode.validationError;
    if (status != null && status >= 500) return ApiErrorCode.serverError;
    return ApiErrorCode.unknownError;
  }

  static String _messageForStatus(int? status) {
    if (status == 401) return 'Authentication is required.';
    if (status == 403) return 'This operation is not permitted.';
    if (status == 404) return 'The requested resource was not found.';
    if (status == 422) return 'The request is invalid.';
    if (status != null && status >= 500) return 'The service is unavailable.';
    return 'An unexpected error occurred.';
  }

  @override
  String toString() => 'ApiException(${code.wireValue}, status=$statusCode)';
}
