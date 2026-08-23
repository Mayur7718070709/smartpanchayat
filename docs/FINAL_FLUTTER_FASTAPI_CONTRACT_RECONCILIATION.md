# Final Flutter ↔ FastAPI Contract Reconciliation

## Verification result

Verified on 2026-08-23 against the current Flutter checkout, current `smartpanchayat-api`, approved discovery documents, and a read-only request to the live Supabase Auth settings endpoint.

Live Auth provider result:

```text
email=true
phone=false
anonymous_users=false
```

No database query or mutation was performed by this verification.

| Feature | Flutter current implementation | FastAPI current implementation | Expected contract | Gap | Action | Blocked? | Database dependency? | Risk |
|---|---|---|---|---|---|---|---|---|
| Configuration | No API/Supabase compile-time config | Environment-based server config | Public Flutter dart-defines | Missing | Implement Phase 1 config | No | No | Misconfiguration must fail visibly in real mode |
| API client | Dio declared, unused | JSON/error API | One Dio client with redaction/retry rules | Missing | Implement Phase 1 client | No | No | Token leakage or write retry if incorrect |
| Authentication | Phone field + local OTP `123456` | Validates Supabase bearer through Auth `/user` | Confirmed Supabase auth method → JWT → context | Live phone provider is disabled; email is enabled | Preserve mock login; document `AUTHENTICATION_CONTRACT_GAP` | **YES** | Auth configuration/product decision, not DB schema | Silently changing UI to email violates approval; enabling phone requires provider/security setup |
| Auth context | No API call | `GET /api/v1/auth/context` | Immutable user/role/tenant/citizen | Token cannot be obtained through approved phone UI | Prepare client only; do not wire real flow | YES | Existing identity rows | Client must never supply identity fields |
| Session restore/logout | No Supabase session; Splash checks language only | Stateless bearer validation | Supabase session restore/refresh/sign-out | SDK/method unresolved | Preserve current mock behavior | YES | No | Fake restoration would misrepresent security |
| Citizen profile read | Mock map | `GET /api/v1/citizen/profile` | Own typed profile | Repository/DTO absent; auth blocked | Defer until auth decision | YES | Existing citizen linkage | Cannot E2E ownership without real user session |
| Citizen profile write | Local edit appears saved in widget state | No approved write endpoint | Controlled persistence | Endpoint absent | Keep mock-mode behavior; real mode must not claim save | YES | Approved write contract required | False persistence/data integrity |
| Services | Mock service maps/typed UI model | list/detail/form-schema GETs | Live catalogue with adapter | Auth blocked; API lacks several UI display fields | Defer wiring; never copy mock content into live mapping | YES for E2E | Authoritative catalogue content | Invented bilingual/display content |
| Form schema | Mock `formFields` | legacy form-schema response | Defensive legacy mapper | No immutable version | Defer; label legacy later | YES for E2E | Form-versioning migration for target state | Wrong form/request snapshot |
| Request reads | No DTO/list/detail/history screens | list/detail/history GETs | Owned request tracking | Flutter layer absent; auth blocked | Defer minimal screens until auth resolution | YES | Existing read tables | Ownership cannot be live-tested |
| Request creation | Local `GP...` number + fake success | POST returns `DATABASE_CONTRACT_GAP` | Server-authoritative creation | Database contract absent | Mock mode only; never show real-mode success | **YES** | Tenant-safe numbering and form versions | Duplicate/fake request numbers |
| Gated modules | Mock/local UI | controlled gates | Remain disabled | By design | No integration | YES | Various missing contracts | Fake transactional success |

## Precedence and discrepancies

1. The actual FastAPI route surface matches the discovery documents; there is no service-category route in the current backend.
2. The master prompt correctly treats request POST as a hard database gate.
3. The actual live Auth settings resolve the earlier uncertainty: phone Auth is disabled. This live configuration takes precedence over any assumption that the phone OTP UI can immediately use Supabase.
4. The repository has no Flutter/Dart test directory and no API/repository layer; Phase 1 adds infrastructure/tests only.

## Gate decision

Phase 1 is safe to implement without changing UI behavior. Phase 2 cannot proceed because the authentication method is unresolved. Per the master stop conditions, feature integration and E2E work stop at that specific gate.
