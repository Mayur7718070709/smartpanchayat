# Mock Data Retirement Proposal

## Current decision

**Retire nothing.** Authentication and E2E testing are blocked, so no mock source qualifies for removal.

## Future eligibility criteria

A mock consumer may be migrated away from direct production use only when:

1. Its approved backend contract exists and is enabled.
2. DTO and adapter tests pass.
3. Mock and real modes both pass Flutter tests.
4. Real E2E covers loading, empty, error, authorization, tenant, and ownership behavior.
5. Product accepts the live content and UI mapping.
6. Explicit mock-retirement approval is recorded.

## File-by-file proposal

| File | Current consumers | Earliest possible production switch | Retention after switch |
|---|---|---|---|
| `lib/data/mock_data.dart` | auth demo, profile, services, notices, complaints, schemes, home | Per feature after E2E; not as one global replacement | Keep for mock mode, demos, widget fixtures, and gated features |
| `lib/data/mock_notifications.dart` | Notifications | Only after notification backend is enabled and tested | Keep as fixture |
| `lib/data/mock_payment_data.dart` | Payment screens | Only after separate payment/security approval | Keep; payments remain gated |
| `lib/data/faq_data.dart` | Assistant | Only after dynamic FAQ/assistant contract approval | Keep as offline/test fixture |

## Prohibited retirement actions

- No deletion.
- No rewriting mock values to resemble live data.
- No global replacement before per-feature E2E approval.
- No silent real-to-mock fallback.
- No mock success in real-mode request creation, complaints, or payments.
