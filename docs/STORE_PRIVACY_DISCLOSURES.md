# Store Privacy Disclosure Working Sheet

This is a conservative working sheet, not a completed legal/store declaration. Confirm actual release features and every third-party SDK before answering the store forms.

| Data category | Collected | Linked to identity | Primary purpose | Notes |
|---|---:|---:|---|---|
| Name, phone, email | Yes | Yes | Authentication, account and services | Phone sent to OTP provider |
| Address and ward | Yes | Yes | Eligibility and Panchayat service delivery | Not precise device location |
| Date of birth and gender | Optional/profile | Yes | Eligibility and profile | Confirm lawful basis |
| User IDs | Yes | Yes | Authentication, tenant isolation, security | Supabase Auth UUID |
| User content | Yes | Yes | Applications, complaints, feedback, assistant | Includes remarks and form data |
| Photos/files | Optional | Yes | Profile and supporting documents | Private Supabase Storage |
| Financial information | When enabled | Yes | Dues, transactions, refunds and receipts | Payment credentials handled by Razorpay |
| Purchase/payment history | When enabled | Yes | Payment fulfilment and accounting | No advertising purpose |
| Diagnostics/security logs | Yes | May be linked | Reliability, fraud and security | Request IDs; define retention |
| Device/push token | Not in current enabled release | Yes if enabled later | Notifications | Update forms before enabling |
| Precise location, contacts, microphone, health | No | No | Not collected | Re-audit permissions each release |

Data is not used for third-party advertising or tracking in the current design. Whether infrastructure processing counts as “sharing” must be answered using each store's definitions and the signed provider agreements. Transport encryption is used. Account deletion is not yet a complete production workflow and must be resolved before submission.
