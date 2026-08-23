import '../network/api_client.dart';
import 'auth_context.dart';

class AuthContextRepository {
  const AuthContextRepository(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthContext> fetch() => _apiClient.get<AuthContext>(
    '/api/v1/auth/context',
    decode: (data) => AuthContext.fromJson(data as Map<String, dynamic>),
  );
}
