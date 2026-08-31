# Step 4 — Versioned Citizen Application Integration

## Status

Implemented locally. The Flutter code has not been committed or pushed, and the production
FastAPI service must be redeployed before this mobile workflow can be tested end to end.

## Citizen workflow

1. The service detail screen fetches the tenant-scoped published form version.
2. Existing bilingual dynamic controls render the 42 approved citizen fields.
3. Dates are sent as ISO `YYYY-MM-DD` values.
4. Approved document slots render separately with bilingual labels and required markers.
5. File Picker accepts PDF, JPEG and PNG, then applies the slot-specific MIME and size limits.
6. The review screen creates an idempotent draft, uploads selected files to the private
   server-managed Storage workflow, and submits the same immutable form version atomically.
7. Duplicate taps are disabled while submission is running. Stable draft/submission
   idempotency keys are retained for safe retries in the current review session.
8. A successful response opens the existing submission receipt using the authoritative
   request number returned by FastAPI.

The legacy direct request-creation method remains in the repository only for source
compatibility; the production screen no longer calls it.

## Security boundaries

- Flutter receives only the Supabase publishable key and citizen access token.
- Flutter never receives the service-role key or a direct Storage write credential.
- Every API operation is authenticated by the existing Supabase session interceptor.
- FastAPI and its private PostgreSQL functions enforce actor, citizen and tenant ownership.
- Files are uploaded only after FastAPI validates the authoritative document slot.

## Validation

- Flutter analyzer: no new errors; existing repository notices remain.
- Complete Flutter test suite: 39 tests passed.
- Final request/document regression tests: passed.
