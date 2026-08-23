import 'package:dio/dio.dart';

typedef AccessTokenProvider = Future<String?> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenProvider);

  final AccessTokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra['requiresAuth'] == false) {
      handler.next(options);
      return;
    }

    final token = await _tokenProvider();
    if (token == null || token.isEmpty) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          error: const MissingAccessToken(),
        ),
      );
      return;
    }
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }
}

class MissingAccessToken {
  const MissingAccessToken();
}
