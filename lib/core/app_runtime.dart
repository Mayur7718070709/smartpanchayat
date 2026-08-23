import 'package:supabase_flutter/supabase_flutter.dart';

import 'auth/auth_context_repository.dart';
import 'auth/phone_auth_service.dart';
import 'config/app_config.dart';
import 'network/api_client.dart';

class AppRuntime {
  AppRuntime._();

  static final AppConfig config = AppConfig.fromEnvironment();
  static PhoneAuthService? _auth;
  static AuthContextRepository? _authContext;

  static bool get usesRealApi => config.useRealApi;

  static PhoneAuthService get auth =>
      _auth ?? (throw StateError('Real authentication is not initialized.'));

  static AuthContextRepository get authContext =>
      _authContext ?? (throw StateError('FastAPI client is not initialized.'));

  static Future<void> initialize() async {
    final errors = config.validate();
    if (errors.isNotEmpty) throw StateError(errors.join(' '));
    if (!usesRealApi) return;

    await Supabase.initialize(
      url: config.supabaseUrl,
      publishableKey: config.supabaseAnonKey,
    );
    final authService = PhoneAuthService(Supabase.instance.client);
    final apiClient = ApiClient(
      config: config,
      tokenProvider: () async => authService.accessToken,
    );
    _auth = authService;
    _authContext = AuthContextRepository(apiClient);
  }
}
