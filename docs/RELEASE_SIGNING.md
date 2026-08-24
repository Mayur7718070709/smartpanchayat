# Release Signing

Production identity: `com.mexonintelligence.smartpanchayat`

Display name: Smart Panchayat

## Android

Use Google Play App Signing with a separate upload key. The repository will now refuse a release task if `android/key.properties` is absent; it no longer falls back to the debug certificate.

1. Create the upload keystore outside the repository with a unique strong password and at least 25 years validity:

   `keytool -genkeypair -v -keystore C:\secure\smartpanchayat-upload.jks -alias smartpanchayat-upload -keyalg RSA -keysize 4096 -validity 10000`

2. Copy `android/key.properties.example` to ignored `android/key.properties` and set the absolute keystore path and passwords.
3. Back up the `.jks`, alias, and passwords in two access-controlled locations. Never store them in Git, Flutter assets, chat, or ordinary cloud folders.
4. Build with the production `--dart-define` values:

   `flutter build appbundle --release --obfuscate --split-debug-info=build/symbols --dart-define=USE_REAL_API=true --dart-define=ALLOW_DEV_MOCK_FALLBACK=false --dart-define=API_BASE_URL=https://smartpanchayat-api.onrender.com --dart-define=SUPABASE_URL=https://dpelcjcuegkzvgvuepbg.supabase.co --dart-define=SUPABASE_ANON_KEY=<PUBLISHABLE_KEY>`

5. Preserve `build/symbols` privately for crash symbolication. Upload the `.aab`, enroll in Play App Signing, and retain the upload certificate fingerprints.

Do not generate a key until the legal publisher name and package identifier are approved. Once published, the application ID cannot be changed without creating a different app.

## iOS

1. Enroll the legal publisher in the Apple Developer Program.
2. Register App ID `com.mexonintelligence.smartpanchayat`.
3. In Xcode, select the correct Team and automatic signing for Runner. Certificates and provisioning profiles remain in Apple/Xcode keychain, never Git.
4. Set a unique monotonically increasing build number, archive on macOS, validate, and upload to App Store Connect/TestFlight.
5. Keep the distribution certificate recovery process and Account Holder access under two-person control.

The iOS project is identifier-ready, but final signing cannot be performed on Windows or without the Apple team account.
