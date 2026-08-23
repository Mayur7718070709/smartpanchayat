# Flutter ↔ FastAPI Integration Discovery Map

## Scope and evidence

Discovery was performed against the actual Flutter repository `Mayur7718070709/smartpanchayat` and the current local `smartpanchayat-api` implementation. No Flutter source, mock dataset, Supabase object, or backend behavior was changed. The repository has no `test/` directory.

## Current architecture

- Flutter SDK constraint: `^3.9.0`.
- UI/state: screen-local `StatefulWidget` + `setState`; no Provider, Riverpod, Bloc, service locator, repository, or data-source layer exists.
- Navigation: centralized `GoRouter` for top-level routes plus direct `Navigator` pushes for details/forms/submission flows.
- Data: screens import static mock collections directly.
- Networking: `dio ^5.4.0` is declared but unused. No Dio instance, interceptor, HTTP call, base URL, or API error mapper exists.
- Authentication: simulated mobile OTP (`9876543210`, OTP `123456`) followed by mock profile setup and hard-coded Nerle confirmation.
- Supabase: no Supabase Flutter SDK dependency, initialization, session, token refresh, or logout integration.
- Persistence: `SharedPreferences` stores only language-selection state (`language_selected`, `selected_language`).
- Connectivity: one-shot `Connectivity().checkConnectivity()` calls in Home, Complaints, Notices, Schemes, Notifications, and Assistant. There is no centralized connectivity policy.
- Errors/loading: several screens simulate delays and use local loading/empty/offline UI. API failures are not modeled.

## Authentication and onboarding flow

```text
Splash
  → language selected? (SharedPreferences)
  → Language Selection
  → Login mobile form
  → simulated delay
  → OTP dialog compares input with MockData.mockOtp
  → Profile Setup (mock save)
  → Panchayat Confirmation (hard-coded Nerle data)
  → Home
```

Target flow:

```text
Existing Login UI
  → Supabase Auth OTP request/verification
  → Supabase access/refresh session
  → Dio Authorization: Bearer <access token>
  → GET /api/v1/auth/context
  → server-derived role + tenant + citizen
  → profile/onboarding decision
  → Home
```

### Authentication conflict

**CONFLICT**

- Source A: Flutter login collects a mobile number and verifies a local six-digit OTP.
- Source B: live discovery found two email identities, no phone identities, and phone-provider availability was unverified.
- Impact: the approved login UI cannot authenticate the known citizen until a phone identity/provider and citizen-phone ownership policy are approved, or the product approves an email-based adaptation.
- Recommended resolution: product/security approval must select phone OTP or email authentication before implementation. Do not silently reinterpret a phone field as email.

## Routing inventory

Top-level GoRouter paths are `/`, `/language-selection`, `/login-screen`, `/profile-setup`, `/panchayat-confirmation`, `/home-screen`, `/services-screen`, `/complaints-screen`, `/notices-screen`, `/schemes-screen`, `/assistant-screen`, `/notifications-screen`, `/payment-summary`, `/payment-history`, `/citizen-profile`, `/feedback`, and `/feedback-thank-you`. Home, Services, Complaints, Notices, Schemes, and Notifications are branches of `StatefulShellRoute.indexedStack`.

Detail/workflow screens are pushed directly and have no named GoRouter path: service detail, application form, application review, application submitted, complaint creation/tracking/submitted, notice detail, scheme detail, and payment processing/success/failure.

## Models

| Model | Important current fields | Integration observation |
|---|---|---|
| `ServiceModel` | bilingual names/descriptions/eligibility, icon, color, category, days, fee, documents, form fields | Requires an adapter; FastAPI returns one `name`, one `description`, category data, fee/days/documents/form schema, but not the current bilingual/icon/color/eligibility contract. |
| `ServiceFormField` | id, bilingual labels, type, required, options, hint | Legacy `form_schema` requires a defensive parser; immutable schema version is absent. |
| Service request | **Not found** | A new API DTO plus UI adapter is required. Do not overload `ServiceModel`. |
| Status history | **Not found** | A new API DTO is required; no request history screen exists. |
| `ComplaintModel` | complaint ID, category/status, description, photo/location, timeline, rating | Backend route is a database-contract gate. |
| `NoticeModel` | bilingual content, category/read state, attachment and Panchayat metadata | Backend route is a database-contract gate. |
| `NotificationModel` | bilingual text, date/category/reference | Backend route is a database-contract gate. |
| `SchemeModel` | bilingual catalogue/detail, eligibility, documents, URLs | Backend route is a database-contract gate. |
| Payment models | summary, charges, transaction, status/service enums | Payments are disabled. |
| FAQ/chat models | bilingual FAQ answer and chat-message state | Dynamic FAQ is disabled. |
| Citizen profile | **No typed model; `Map<String,dynamic>`** | Add an API DTO and mapper; preserve the UI-facing map/model contract during integration. |

## Mock-data inventory

| File | Contents | Direct consumers |
|---|---|---|
| `lib/data/mock_data.dart` | citizen profile, OTP, notices, 11 service maps, quick actions, events, complaints, schemes | Login/OTP, Home, Profile, Services, Complaints, Notices, Schemes |
| `lib/data/mock_notifications.dart` | notification list | Notifications |
| `lib/data/mock_payment_data.dart` | transactions and sample payment summary | Payment history/summary |
| `lib/data/faq_data.dart` | FAQ catalogue and local answer matching | Assistant |

All four files remain unchanged and must become inputs to `MockDataSource`, not be deleted.

## Screen → API mapping

Status values: `READY` means the FastAPI read contract exists; `GATED` means the route intentionally fails closed; `GAP` means no usable endpoint/contract exists; `LOCAL` means backend integration is not required.

| Flutter screen | Current source/model | Confirmed target FastAPI endpoint | Auth / role / tenant | Status |
|---|---|---|---|---|
| Splash | `SharedPreferences`; no session | `GET /health`, `GET /ready`, then local Supabase session + `GET /api/v1/auth/context` | context requires auth; server-derived role/tenant | GAP: session layer absent |
| Language Selection | `SharedPreferences` | None | None | LOCAL |
| Login | simulated delay/mobile | Supabase Auth directly; then `GET /api/v1/auth/context` | authenticated user | GAP: SDK/provider decision |
| OTP dialog | `MockData.mockOtp` | Supabase Auth OTP verify | authenticated after verification | GAP |
| Profile Setup | controllers; mock save | No create/update endpoint | citizen/Nerle | GAP |
| Panchayat Confirmation | hard-coded `_panchayatData` | No tenant/Panchayat-detail endpoint | citizen/Nerle | GAP |
| Home | citizen map, notices, quick actions/events and static widgets | profile can use `GET /api/v1/citizen/profile`; remaining modules have only gates or no aggregate | citizen/Nerle | PARTIAL |
| Citizen Profile | `MockData.citizenProfile` map | `GET /api/v1/citizen/profile` | citizen/own tenant | READY read; edit is GAP |
| Services | `MockData.serviceMaps → ServiceModel` | `GET /api/v1/services` | authenticated tenant context | READY with adapter |
| Service Detail | passed `ServiceModel` | `GET /api/v1/services/{service_id}` | authenticated tenant context | READY with adapter |
| Application Form | passed service/form fields, local controllers | `GET /api/v1/services/{service_id}/form-schema` | authenticated tenant context | PARTIAL: legacy schema only |
| Application Review | in-memory service/form values; locally generated `GP...` ID | `POST /api/v1/service-requests` | citizen/Nerle/own identity | GATED; local ID generation must be removed only when API is enabled |
| Application Submitted | passed local ID/date | POST response | citizen/Nerle | GATED |
| Service-request list | No dedicated screen; profile links back to Services | `GET /api/v1/service-requests` or citizen alias `/api/v1/citizen/requests` | citizen sees own requests | READY API; GAP UI/model |
| Service-request detail | No screen | `GET /api/v1/service-requests/{request_id}` | owner or approved tenant role | READY API; GAP UI/model |
| Request history | No screen | `GET /api/v1/service-requests/{request_id}/history` | owner or approved tenant role | READY API; GAP UI/model |
| Complaints | `MockData.mockComplaints` | `GET/POST /api/v1/complaints` | authenticated | GATED: `DATABASE_CONTRACT_GAP` |
| Create Complaint | local form | `POST /api/v1/complaints` | citizen/Nerle | GATED |
| Track Complaint | passed `ComplaintModel` | No usable backend contract | citizen/Nerle | GATED/GAP |
| Complaint Submitted | passed local values | POST response eventually | citizen/Nerle | GATED |
| Notices | `MockData.mockNotices` | `GET /api/v1/notices` | authenticated | GATED: `DATABASE_CONTRACT_GAP` |
| Notice Detail | passed `NoticeModel` | No detail endpoint | authenticated tenant | GAP |
| Notifications | `MockNotifications.notifications` | `GET /api/v1/notifications` | authenticated | GATED: `DATABASE_CONTRACT_GAP` |
| Schemes | `MockData.mockSchemes` | `GET /api/v1/schemes` | authenticated | GATED: `DATABASE_CONTRACT_GAP` |
| Scheme Detail | passed `SchemeModel` | No detail endpoint | authenticated tenant | GAP |
| Payment Summary/Processing/Success/Failure/History | `MockPaymentData` and passed models; forced success | `GET/POST /api/v1/payments` | authenticated | GATED: `FEATURE_NOT_ENABLED` |
| Feedback/Thank You | local form/result | `GET/POST /api/v1/feedback` | authenticated | GATED: `FEATURE_NOT_ENABLED` |
| Assistant | `FaqData.findAnswer` | `GET /api/v1/faq` exists only as gate | authenticated | GATED: `FEATURE_NOT_ENABLED` |

Dynamic home widgets map to confirmed gated routes `/api/v1/events` and `/api/v1/contacts`; notification push maps to `/api/v1/push-notifications`. These must remain mock/static.

## Confirmed current FastAPI surface

- Public: `GET /health`, `GET /ready`.
- Identity: `GET /api/v1/auth/context`.
- Citizen: `GET /api/v1/citizen/profile`, `/citizen/requests`, `/citizen/requests/{request_id}`.
- Services: `GET /api/v1/services`, `/services/{service_id}`, `/services/{service_id}/form-schema`.
- Requests: `GET /api/v1/service-requests`, `/{request_id}`, `/{request_id}/history`; POST exists but returns `DATABASE_CONTRACT_GAP`.
- Explicit gates: complaints, notices, notifications, schemes, payments, push notifications, feedback, FAQ, events, contacts.

## Recommended integration seam

Add one composition layer without changing widgets visually:

```text
Screen/controller state
  → feature Repository interface
      → MockDataSource (existing files)
      → ApiDataSource (one shared Dio ApiClient)
          → TokenProvider (Supabase session)
          → FastAPI
```

Use compile-time `--dart-define` configuration such as `USE_REAL_API`, `API_BASE_URL`, and public Supabase URL/publishable key. No configuration package currently exists. Real API failure must surface as error state; development mock fallback must require a separate explicit flag.

## Screens requiring backend integration

There are 29 screen classes. Language Selection is fully local; the other **28** are backend-dependent now or in later gated phases. The approved first real scope directly touches **8 existing screens** (Login, Profile, Services, Service Detail, Application Form, Application Review, Application Submitted, and Splash/session bootstrap) and requires new request list/detail/history UI decisions because those screens do not exist.

## Recommended order

1. Approve phone OTP versus email authentication.
2. Add environment configuration, Supabase client/session boundary, and one Dio client.
3. Add repositories/data sources while retaining every mock.
4. Integrate auth/context and session routing.
5. Integrate citizen profile read.
6. Integrate services and legacy form-schema adapters.
7. Integrate request list/detail/history reads after UI/model approval.
8. Keep request creation disabled until its database contract is approved and migrated.
9. Run E2E tests before any mock retirement proposal.
