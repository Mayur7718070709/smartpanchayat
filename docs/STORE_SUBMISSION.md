# Store Submission Package

## Proposed listing

- App name: Smart Panchayat
- Android application ID / iOS bundle ID: `com.mexonintelligence.smartpanchayat`
- Category: Government / Productivity (confirm against each store's available categories)
- Default language: Marathi; English localization
- Version: `1.0.0` build `1` (increment build before every upload)
- Support URL: required — publish before submission
- Privacy URL: required — publish the approved policy over public HTTPS before submission
- Account deletion URL: required if deletion is not available in-app

Short description: Apply for Gram Panchayat services, track requests, view notices and manage civic services securely.

Full description: Smart Panchayat connects registered residents with their participating Gram Panchayat. Citizens can authenticate by phone, manage their profile, browse available services and schemes, submit and track service applications, raise complaints, read official notices, review dues and receipts, submit feedback, and access approved FAQ and assistant information. Availability varies by Panchayat and enabled production modules.

## Google Play checklist

- Create the app using the final publisher account and exact package ID.
- Complete developer identity verification and Play App Signing.
- Upload a signed Android App Bundle, not the debug APK.
- Complete App access with a working review phone/account and OTP instructions.
- Complete Data safety using `STORE_PRIVACY_DISCLOSURES.md` after provider/legal review.
- Complete content rating, target audience, ads declaration, government-app affiliation declaration, financial features declaration and permissions declaration as applicable.
- Provide public privacy, support and account-deletion URLs.
- Upload phone screenshots, high-resolution icon, feature graphic and localized listing text.
- Run internal testing, then closed testing requirements applicable to the developer account, followed by a staged production rollout.

## Apple checklist

- Create the Bundle ID and App Store Connect record under the legal publisher.
- Configure Xcode Team signing; archive and upload from macOS.
- Complete App Privacy using `STORE_PRIVACY_DISCLOSURES.md`, including third-party SDKs/providers.
- Provide privacy and support URLs, age rating, category, copyright, export-compliance answers and review contact.
- Provide a working review account/phone, OTP instructions and notes explaining Panchayat eligibility and region restrictions.
- Upload required iPhone/iPad screenshots for supported devices.
- Test through TestFlight, select the accepted build, add it for review, then submit for review.

## Release gates

Do not submit until production OTP works, account deletion/grievance routes exist, the privacy policy has legal approval and a public URL, runtime-role security testing is complete, backup restore is tested, monitoring alerts are active, payment declarations match the enabled build, and an end-to-end citizen workflow passes on physical Android and iOS devices.
