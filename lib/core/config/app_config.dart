class AppConfig {
  const AppConfig({
    required this.useRealApi,
    required this.allowDevMockFallback,
    required this.apiBaseUrl,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
  });

  factory AppConfig.fromEnvironment() => const AppConfig(
    useRealApi: bool.fromEnvironment('USE_REAL_API', defaultValue: false),
    allowDevMockFallback: bool.fromEnvironment(
      'ALLOW_DEV_MOCK_FALLBACK',
      defaultValue: false,
    ),
    apiBaseUrl: String.fromEnvironment('API_BASE_URL'),
    supabaseUrl: String.fromEnvironment('SUPABASE_URL'),
    supabaseAnonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
  );

  final bool useRealApi;
  final bool allowDevMockFallback;
  final String apiBaseUrl;
  final String supabaseUrl;
  final String supabaseAnonKey;

  Uri? get parsedApiBaseUrl => Uri.tryParse(apiBaseUrl);
  Uri? get parsedSupabaseUrl => Uri.tryParse(supabaseUrl);

  List<String> validate() {
    if (!useRealApi) return const [];

    final errors = <String>[];
    final apiUri = parsedApiBaseUrl;
    if (apiUri == null || !apiUri.hasScheme || !apiUri.hasAuthority) {
      errors.add('API_BASE_URL must be an absolute URL in real API mode.');
    } else if (apiUri.scheme != 'https' && !_isLocalDevelopmentHost(apiUri)) {
      errors.add('API_BASE_URL must use HTTPS outside local development.');
    }
    final supabaseUri = parsedSupabaseUrl;
    if (supabaseUri == null ||
        supabaseUri.scheme != 'https' ||
        !supabaseUri.hasAuthority) {
      errors.add('SUPABASE_URL must be an absolute HTTPS URL in real API mode.');
    }
    if (supabaseAnonKey.isEmpty) {
      errors.add('SUPABASE_ANON_KEY is required in real API mode.');
    }
    return errors;
  }

  bool _isLocalDevelopmentHost(Uri uri) =>
      uri.scheme == 'http' &&
      const {'localhost', '127.0.0.1', '10.0.2.2'}.contains(uri.host);
}
