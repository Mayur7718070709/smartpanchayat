# Flutter API Gaps

This register distinguishes missing/disabled FastAPI capability from Flutter plumbing that has not yet been built. A route that returns a controlled gate is not considered implemented for UI integration.

| # | Feature | Flutter screen | Expected data | Required endpoint | Current status | Backend dependency / DB block | Recommendation |
|---:|---|---|---|---|---|---|---|
| 1 | Phone OTP authentication | Login, OTP dialog | OTP request/verify and refreshable session | Supabase Auth, not FastAPI | No SDK; live phone identities/provider unverified | Auth/provider and identity-linkage decision | Product/security approval before code |
| 2 | Profile onboarding/write | Profile Setup, Citizen Profile edit | validated citizen create/update fields | Citizen profile create/update endpoint | Only GET exists | Safe column-level write contract | Keep mock edit/save; design separately |
| 3 | Panchayat confirmation | Panchayat Confirmation | canonical bilingual tenant/Panchayat metadata | Tenant/Panchayat detail endpoint | Not found | Read contract and exposure policy | Add only after backend approval |
| 4 | Service bilingual/display adapter | Services, Service Detail | Marathi/English names, icon, color, eligibility | Existing service GETs lack these fields | Read endpoint exists, UI contract differs | Authoritative catalogue content | Adapter may return explicit unavailable state; never invent |
| 5 | Immutable form versions | Application Form | schema version and stable fields | Current legacy form-schema GET | Legacy only | Form-versioning migration | Read legacy defensively; label limitation |
| 6 | Service-request creation | Review, Submitted | server request number and stored snapshot | `POST /api/v1/service-requests` | Returns `DATABASE_CONTRACT_GAP` | Tenant-safe numbering + form versions | Do not integrate as successful write |
| 7 | My Requests UI | No dedicated screen | paged owned requests | Existing request-list GET | Backend READY, Flutter model/screen absent | No DB block | Requires product UI placement approval |
| 8 | Request detail UI | No screen | complete owned request | Existing request-detail GET | Backend READY, Flutter model/screen absent | No DB block | Add DTO/adapter and approved screen later |
| 9 | Request history UI | No screen | ordered status events | Existing history GET | Backend READY, Flutter model/screen absent | No DB block | Add DTO and approved tracking UI later |
| 10 | Status transitions | No admin request screen | approved transition/result/history | No write route | Not implemented | Approved transition function/ACL | Keep unavailable |
| 11 | Complaints | four complaint screens | catalogue, create, timeline, rating/reopen | complaint routes are gates | `DATABASE_CONTRACT_GAP` | Complaint tables/history/ratings/RLS | Preserve mocks |
| 12 | Notices | list/detail and Home | bilingual notices, attachments/read state | notice list gate; no detail | `DATABASE_CONTRACT_GAP` | Notice/read/attachment contracts | Preserve mocks |
| 13 | Notifications and push | Notifications | feed/read state/device delivery | notification/push gates | Contract gap/disabled | Notification/device-token contracts | Preserve mocks |
| 14 | Schemes | list/detail and Home | bilingual catalogue/eligibility | scheme list gate; no detail | `DATABASE_CONTRACT_GAP` | Scheme contract | Preserve mocks |
| 15 | Payments/dues/receipts | five payment screens and Home | dues, transaction, webhook result, receipt | payment routes are gates | `FEATURE_NOT_ENABLED` | Payment provider and ledger contracts | Preserve mocks; never simulate real charge |
| 16 | Feedback | Feedback/Thank You | submission and prior state | feedback routes are gates | `FEATURE_NOT_ENABLED` | Feedback table/policy | Preserve local flow |
| 17 | Dynamic FAQ/assistant | Assistant | dynamic answers/citations | FAQ route is a gate | `FEATURE_NOT_ENABLED` | FAQ/content contract; no assistant API | Keep `FaqData` |
| 18 | Dynamic events | Home | published tenant events | events route is a gate | `FEATURE_NOT_ENABLED` | Events contract | Keep mock events |
| 19 | Dynamic contacts | Home/Profile help | Panchayat contacts | contacts route is a gate | `FEATURE_NOT_ENABLED` | Contacts contract | Keep static contacts |
| 20 | Storage uploads | Profile Setup, complaints, future request documents | signed/private upload lifecycle | No enabled endpoint | Disabled | Buckets, paths, type/size and RLS policies | Do not upload yet |
| 21 | Home aggregate/counters | Home | dues, complaint count, active applications, unread notices | No aggregate endpoint | Not found | Multiple gated modules | Compose only supported reads; retain remaining mocks |

## Count interpretation

- **21 documented integration gaps** are listed above.
- Of these, **15 are backend/database/capability gaps** (#2–6, #10–21).
- Six are principally Flutter/auth/product integration gaps with an existing or external read contract (#1 and #7–9, plus the client-side portions of #4–5).

No gap authorizes a migration or a new endpoint. Request creation, complaints, notices, notifications, schemes, payments, feedback, dynamic content, push, and Storage remain disabled.
