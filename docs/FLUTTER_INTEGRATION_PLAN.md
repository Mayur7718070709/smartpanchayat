# Flutter ↔ FastAPI Integration Plan

## Guardrails

- Preserve UI layout, routes, styling, animations, icons, and mock datasets.
- No database or migration action belongs to this plan.
- One Dio client only; no feature-owned clients.
- Never put a database URL/password, service-role key, or Supabase secret key in Flutter.
- `USE_REAL_API=true` must not silently fall back to mock data. Optional fallback requires an explicit development-only flag.
- Do not enable any gated capability.

## Phase 1 — API client foundation

1. Add compile-time configuration using `String.fromEnvironment`/`bool.fromEnvironment`:
   - `USE_REAL_API`
   - `ALLOW_DEV_MOCK_FALLBACK` (default false)
   - `API_BASE_URL`
   - `SUPABASE_URL`
   - public publishable/anon key only
2. Create a single Dio-backed `ApiClient` with connect/receive/send timeouts, JSON headers, normalized FastAPI error parsing, cancellation, and development-only redacted logging.
3. Add a token provider/interceptor that reads the current Supabase session and attaches `Authorization: Bearer ...`; never log the header.
4. Retry only safe/idempotent reads for transient transport failures; do not automatically retry writes.
5. Create explicit `ApiException` categories for auth, forbidden, validation, not found, contract gap, disabled feature, connectivity, timeout, and server error.
6. Add configuration and client unit tests. Preserve Dio dependency.

Deliverable boundary: infrastructure only; screens still use mocks.

## Phase 2 — Authentication

1. Obtain product/security approval for phone OTP versus email authentication.
2. Add and pin the official Supabase Flutter SDK only after that decision.
3. Keep the existing Login and OTP UI; route button/dialog actions through an `AuthRepository`.
4. Implement mock and Supabase auth data sources selected by configuration.
5. On session establishment, call `GET /api/v1/auth/context` and require a supported active identity/role/tenant.
6. Restore/refresh sessions at Splash and perform real sign-out from Citizen Profile.
7. Do not trust Flutter-supplied role, tenant, user, or citizen IDs.
8. Test invalid/expired sessions, blocked users, missing app profile, and logout.

Exit criterion: a real existing citizen reaches Home with server-derived Nerle context.

## Phase 3 — Citizen profile

1. Introduce typed API DTO and a mapper to the current UI contract.
2. Add `CitizenRepository`, `MockCitizenDataSource`, and `ApiCitizenDataSource`.
3. Integrate read-only `GET /api/v1/citizen/profile`.
4. Preserve editing UI but disable/label persistence in real mode until an approved write endpoint exists; do not pretend an edit succeeded.
5. Keep profile setup/panchayat confirmation mock-backed pending their contracts.

Exit criterion: profile load/error/empty/auth states render without visual redesign.

## Phase 4 — Services

1. Add service API DTOs and a mapper to `ServiceModel`.
2. Integrate `GET /api/v1/services` and `GET /api/v1/services/{service_id}`.
3. Integrate the confirmed legacy `GET /api/v1/services/{service_id}/form-schema` only with explicit legacy status.
4. Never synthesize bilingual names, icon/color, eligibility, fee, days, or documents. Define approved display fallbacks separately from mock content.
5. Verify all actual live 11-service IDs and empty/unavailable fields read-only.

Exit criterion: list/detail load from live API with accurate content-status signaling.

## Phase 5 — Service requests

1. Add request/create DTOs and repository abstraction.
2. Retain current mock review/submission flow when `USE_REAL_API=false`.
3. When real mode is enabled, treat POST as unavailable while FastAPI returns `DATABASE_CONTRACT_GAP`.
4. Do not generate `GP...` or any request number client-side in real mode.
5. Enable POST only after a separately approved backend/database change and contract test.
6. Prevent automatic retry/idempotency ambiguity for submission.

Exit criterion: mock creation remains functional; real mode fails visibly and safely until backend approval.

## Phase 6 — Request tracking/history

1. Obtain product approval for the missing request list/detail/history UI placement.
2. Add typed request and status-history models.
3. Integrate existing GET list/detail/history endpoints with owner-safe 404 handling.
4. Reuse current design-system widgets and status badges; do not redesign navigation.
5. Verify ordered history rendering and cancellation/rejection remarks without exposing SQL/internal errors.

Exit criterion: citizen can see only owned requests and their ordered histories.

## Phase 7 — E2E testing

Test matrix:

- Mock mode remains visually and functionally equivalent.
- Real health/readiness and API error contracts.
- Supabase login, refresh, app restart/session restore, blocked user, expiry, and logout.
- Forged tenant/user/citizen/role values have no effect.
- Profile/service list/service detail/form-schema mappings, including empty fields.
- Request list/detail/history ownership, unknown/invalid UUIDs, and offline/timeout states.
- POST request gate renders a visible controlled error and creates no local fake success in real mode.
- Android emulator URL (`10.0.2.2`) versus physical-device/LAN HTTPS configuration.
- Logs contain no JWT, password, publishable configuration beyond its intended public nature, or sensitive profile payload.

Run backend and Flutter automated tests plus a read-only integration smoke test. No destructive database test is permitted.

## Phase 8 — Mock-data retirement only after approval

Do not delete mocks automatically. After E2E approval, produce a per-feature retirement proposal. Keep mocks for widget tests, demos, offline fixtures, and every gated module until replacements are approved. Remove a direct screen import only after its repository path has equivalent test coverage.

## Proposed files for the later implementation phase

Names are proposals, not files created during discovery:

```text
lib/core/config/app_config.dart
lib/core/network/api_client.dart
lib/core/network/api_exception.dart
lib/core/network/auth_interceptor.dart
lib/data/datasources/mock/*
lib/data/datasources/api/*
lib/data/repositories/*
lib/models/api/*
```

The project currently has no dependency-injection/state-management framework. Prefer constructor composition at the app/root feature boundary initially rather than introducing a framework solely for integration.

## Approval checkpoints

1. Authentication method and provider configuration.
2. Mapper policy for missing bilingual/display service fields.
3. Request tracking UI/route placement.
4. Backend migration approval before request creation.
5. E2E acceptance before mock retirement.
