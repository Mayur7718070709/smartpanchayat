import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/network/api_exception.dart';

void main() {
  test('maps structured database contract error', () {
    final request = RequestOptions(path: '/api/v1/service-requests');
    final error = DioException(
      requestOptions: request,
      response: Response<dynamic>(
        requestOptions: request,
        statusCode: 501,
        data: {
          'error': {
            'code': 'DATABASE_CONTRACT_GAP',
            'message': 'Migration required',
            'details': {'feature': 'REQUEST_CREATION'},
          },
        },
      ),
      type: DioExceptionType.badResponse,
    );

    final result = ApiException.fromDio(error);
    expect(result.code, ApiErrorCode.databaseContractGap);
    expect(result.statusCode, 501);
    expect(result.details['feature'], 'REQUEST_CREATION');
  });

  test('maps authentication and validation statuses', () {
    ApiException mapped(int status) {
      final request = RequestOptions(path: '/test');
      return ApiException.fromDio(
        DioException(
          requestOptions: request,
          response: Response<dynamic>(
            requestOptions: request,
            statusCode: status,
          ),
          type: DioExceptionType.badResponse,
        ),
      );
    }

    expect(mapped(401).code, ApiErrorCode.authenticationRequired);
    expect(mapped(403).code, ApiErrorCode.forbidden);
    expect(mapped(404).code, ApiErrorCode.notFound);
    expect(mapped(422).code, ApiErrorCode.validationError);
    expect(mapped(500).code, ApiErrorCode.serverError);
  });

  test('maps timeout and connectivity without leaking request data', () {
    final request = RequestOptions(
      path: '/private',
      headers: {'Authorization': 'Bearer never-log-this'},
    );

    final timeout = ApiException.fromDio(
      DioException(
        requestOptions: request,
        type: DioExceptionType.connectionTimeout,
      ),
    );
    final connectivity = ApiException.fromDio(
      DioException(
        requestOptions: request,
        type: DioExceptionType.connectionError,
      ),
    );

    expect(timeout.code, ApiErrorCode.timeout);
    expect(connectivity.code, ApiErrorCode.connectivityError);
    expect(timeout.toString(), isNot(contains('never-log-this')));
  });
}
