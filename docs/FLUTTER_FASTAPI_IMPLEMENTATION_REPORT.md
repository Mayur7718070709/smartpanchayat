# Flutter ↔ FastAPI Implementation Report

## Outcome

The approved phone OTP integration is implemented locally. Supabase Auth owns OTP/session handling; the access token is injected into FastAPI requests; and FastAPI `/api/v1/auth/context` must confirm an active tenant-scoped citizen before the app enters the authenticated area. Live Phone Auth activation remains an explicit deployment operation.

## Implemented

- Compile-time `AppConfig` for `USE_REAL_API`, `ALLOW_DEV_MOCK_FALLBACK`, `API_BASE_URL`, `SUPABASE_URL`, and public `SUPABASE_ANON_KEY`.
- Real-mode configuration validation; mock-mode defaults remain unchanged.
- One Dio-based `ApiClient` with JSON options, timeouts, cancellation tokens, bearer interceptor, redacted development logs, structured errors, one safe GET retry, and no POST retry.
- `ApiException` mappings for authentication, authorization, validation, not-found, contract-gap, disabled-feature, connectivity, timeout, server, and unknown failures.
- Unit-test sources for configuration, errors, token injection, public calls, GET retry, and no-write-retry.
- Pinned `supabase_flutter` dependency and committed lockfile policy.
- Existing-user-only SMS OTP (`shouldCreateUser: false`) with E.164 normalization.
- OTP verification, resend, persisted-session validation, and local sign-out.
- Fail-closed behavior when the token, app user, active tenant, or citizen linkage is missing.
- Final contract reconciliation and production activation documentation.

## Still gated

- No citizen, service, or service-request repository was wired to the UI.
- No new request screens/routes were added.
- Request creation remains disabled.
- Phone Auth remains disabled in the live project until the SMS provider and abuse controls are approved and configured.
- Existing live email-only Auth identities require an approved phone-linking/onboarding operation; the client will not manufacture them.

## UI and mock preservation

Default `USE_REAL_API=false` preserves the original demo flow and mock data. Real mode hides demo credentials and uses the production auth chain. No screen was redesigned and no mock-data source was deleted.

## Validation

- 15 Flutter tests pass.
- Focused Dart analysis of integration code, affected screens, and tests reports no issues.
- Android debug APK builds successfully with the Supabase native plugin.
- No live OTP, database write, schema change, Storage change, or production-user mutation was performed.
