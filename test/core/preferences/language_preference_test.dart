import 'package:flutter_test/flutter_test.dart';
import 'package:smartpanchayat/core/preferences/language_preference.dart';

void main() {
  test('accepts only supported device language codes', () {
    expect(LanguagePreference.isSupported('mr'), isTrue);
    expect(LanguagePreference.isSupported('en'), isTrue);
    expect(LanguagePreference.isSupported('MR'), isFalse);
    expect(LanguagePreference.isSupported('hi'), isFalse);
    expect(LanguagePreference.isSupported(null), isFalse);
  });
}
