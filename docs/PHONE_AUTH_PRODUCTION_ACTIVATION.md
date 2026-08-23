# Phone Auth Production Activation

## Code status

The Flutter application is prepared for the approved phone OTP contract. Real mode uses Supabase Auth for OTP/session handling and sends the resulting access token only to FastAPI. FastAPI remains the authority for application role, tenant, and citizen identity.

No live Supabase configuration or user record was changed while implementing this code.

## Required dashboard activation

Before a real-mode release:

1. Configure a supported SMS provider in Supabase Auth using production-owned credentials.
2. Enable Phone Auth only after the provider test succeeds.
3. Set production OTP expiry, resend interval, and rate limits.
4. Configure CAPTCHA/abuse protection appropriate for a public citizen application.
5. Verify SMS templates in Marathi/English and confirm regulatory sender requirements.
6. Ensure each approved citizen Auth identity has a verified E.164 phone number (India: `+91` plus 10 digits).
7. Ensure the same Auth UUID is linked through `app_users` to an active tenant-scoped `citizens` row.

The application sends OTP with `shouldCreateUser: false`. Unknown phone numbers therefore must not create production users. User onboarding remains an administrative/approved backend workflow until a separate registration contract is approved.

## Release configuration

Pass public values at build time; never bundle the database password or Supabase secret/service-role key:

```text
--dart-define=USE_REAL_API=true
--dart-define=API_BASE_URL=https://api.example.gov.in
--dart-define=SUPABASE_URL=https://PROJECT_REF.supabase.co
--dart-define=SUPABASE_ANON_KEY=PUBLIC_PUBLISHABLE_KEY
```

Use HTTPS for both production URLs. The Flutter application contains only the public publishable key. FastAPI secrets belong in the deployment platform's secret manager.

## Controlled end-to-end verification

Use a designated non-production citizen identity linked to the correct tenant:

1. Send an OTP from Flutter.
2. Verify the SMS code.
3. Confirm `GET /api/v1/auth/context` returns `role=CITIZEN`, the expected `tenant_id`, and a non-null `citizen_id`.
4. Confirm the application navigates to Home only after that response succeeds.
5. Confirm an unknown phone cannot create a user.
6. Confirm an admin/officer identity, inactive user, inactive tenant, and unlinked citizen are rejected.
7. Restart the app and confirm the persisted session is accepted only after FastAPI context resolution.
8. Log out and confirm the local Supabase session is removed.

Do not use or alter protected production fixtures during this test.
