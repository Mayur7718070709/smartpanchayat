import 'package:shared_preferences/shared_preferences.dart';

class LanguagePreference {
  LanguagePreference._();

  static const key = 'selected_language';
  static const supported = {'mr', 'en'};

  static bool isSupported(String? value) => supported.contains(value);

  static Future<String?> load() async {
    final value = (await SharedPreferences.getInstance()).getString(key);
    return isSupported(value) ? value : null;
  }

  static Future<void> save(String value) async {
    if (!isSupported(value)) {
      throw ArgumentError.value(value, 'value', 'Unsupported language');
    }
    await (await SharedPreferences.getInstance()).setString(key, value);
  }
}
