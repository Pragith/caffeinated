# Mac App Store Submission Checklist

This guide outlines the technical and administrative steps required to publish Caffeinate-d to the Mac App Store.

**Current state (2026-09-28):** Build 1.0 (4) and the corrected listing are submitted; Apple reports `WAITING_FOR_REVIEW`. See [resubmission evidence](RESUBMISSION_2026-09-28.md).

## 1. Technical Requirements
- [x] **Bundle Identifier**: Apple accepted build 1.0 (2) for `net.pragith.caffeinated` into App Store Connect.
- [x] **App Sandbox**: Enabled in the Xcode target.
- [x] **Power management**: Uses Foundation `ProcessInfo` activity assertions; no subprocess or administrator prompt is used.
- [x] **Iconography**: The AppIcon asset catalog includes sizes from 1024x1024 down to 16x16.

## 2. Store Assets
- [x] **Mac screenshots**: Two new store images use a genuine build 4 menu capture and are complete in App Store Connect. The rejected build 1 image is retained at `docs/screenshots/rejected_1.0_1_awake_menu.png` for reference only.
- [x] **Icon**: AppIcon asset catalog includes a 1024x1024 icon.
- [x] **Privacy Policy**: `https://pragith.net/privacy` is live.
- [x] **Build 1.0 (2)**: Uploaded and processed as valid by Apple. See [review remediation and delivery evidence](REVIEW_REMEDIATION_2026-09-28.md).

## 3. Review remediation for submission 07bb4787-dd6a-44ef-925b-566c2241af03
- [x] Set the sole live subtitle to `Stay awake with one click`.
- [x] Replace the rejected screenshot with two images based on the genuine build 4 menu capture.
- [x] Upload, process, and select build 1.0 (4); Apple delivery UUID: `b64d37f8-aabb-48cd-b4c4-5d9c52a93865`.
- [x] Check live English (U.S.) listing text and screenshots for the rejected subtitle and donation prompts.
- [x] Add concise App Review notes explaining the changes and how to inspect the menu.
- [x] Resubmit the existing review submission; Apple reports `WAITING_FOR_REVIEW`.
- [ ] Send a separate Resolution Center reply if Apple still permits one. It was not sent or verified during resubmission.

## 4. Deployment Workflow
1. Increment `CURRENT_PROJECT_VERSION` in both Xcode configurations and update `VERSION` / `MARKETING_VERSION` as needed. The release script reads the build number from the project.
2. Run `scripts/release_macos_app_store.sh build` using the local App Store Connect API key.
3. Run `scripts/release_macos_app_store.sh validate`.
4. Run `scripts/release_macos_app_store.sh upload`.
5. Complete listing metadata, screenshots, privacy details, and export compliance in [App Store Connect](https://appstoreconnect.apple.com).
6. Select the processed build, then submit for review.

## 5. App Store Connect API release

Use the existing local API key outside this repository. Keep its private key out of command output and Git. Build an App Store Connect archive with the installed Xcode, export a `.pkg`, run `xcrun altool --validate-app`, then upload only after validation succeeds. Check delivery with `scripts/release_macos_app_store.sh status <delivery-uuid>`. A successful upload still requires processing and a completed App Store listing before review submission.
