import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/config/app_config.dart';

void main() {
  test('mock mode does not require network configuration', () {
    const config = AppConfig(
      useRealApi: false,
      allowDevMockFallback: false,
      apiBaseUrl: '',
      supabaseUrl: '',
      supabaseAnonKey: '',
    );

    expect(config.validate(), isEmpty);
  });

  test('real mode reports every missing public configuration value', () {
    const config = AppConfig(
      useRealApi: true,
      allowDevMockFallback: false,
      apiBaseUrl: '',
      supabaseUrl: '',
      supabaseAnonKey: '',
    );

    expect(config.validate(), hasLength(3));
  });

  test('real mode accepts absolute API and public Supabase values', () {
    const config = AppConfig(
      useRealApi: true,
      allowDevMockFallback: false,
      apiBaseUrl: 'https://api.example.test',
      supabaseUrl: 'https://project.supabase.co',
      supabaseAnonKey: 'public-key',
    );

    expect(config.validate(), isEmpty);
  });

  test('real mode rejects insecure non-local endpoints', () {
    const config = AppConfig(
      useRealApi: true,
      allowDevMockFallback: false,
      apiBaseUrl: 'http://api.example.test',
      supabaseUrl: 'http://project.supabase.co',
      supabaseAnonKey: 'public-key',
    );

    expect(config.validate(), hasLength(2));
  });

  test('Android emulator may use a local HTTP FastAPI endpoint', () {
    const config = AppConfig(
      useRealApi: true,
      allowDevMockFallback: false,
      apiBaseUrl: 'http://10.0.2.2:8000',
      supabaseUrl: 'https://project.supabase.co',
      supabaseAnonKey: 'public-key',
    );

    expect(config.validate(), isEmpty);
  });
}
