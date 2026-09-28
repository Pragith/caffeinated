# Mac App Store Submission Checklist

This guide outlines the technical and administrative steps required to publish Caffeinate-d to the Mac App Store.

## 1. Technical Requirements
- [ ] **Bundle Identifier**: Ensure `net.pragith.caffeinated` is registered in Apple Developer Portal.
- [x] **App Sandbox**: Enabled in the Xcode target.
- [x] **Power management**: Uses Foundation `ProcessInfo` activity assertions; no subprocess or administrator prompt is used.
- [ ] **Iconography**: Needs high-res icons (1024x1024 down to 16x16) in an `.appiconset`.

## 2. Store Assets
- [ ] **Mac screenshot**: Capture the revised build 2 menu without the donation action and replace the screenshot currently uploaded to App Store Connect. The rejected build 1 image is retained at `docs/screenshots/rejected_1.0_1_awake_menu.png` for reference only.
- [x] **Icon**: AppIcon asset catalog includes a 1024x1024 icon.
- [x] **Privacy Policy**: `https://pragith.net/privacy` is live.

## 3. Review remediation for submission 07bb4787-dd6a-44ef-925b-566c2241af03
- Set the subtitle to `Stay awake with one click` in every App Store Connect localization. The previous subtitle used `Mac` in a way App Review rejected under guideline 5.2.5.
- Replace the menu screenshot with one captured from build 2, without the donation item. Remove the prior screenshot from App Store Connect.
- Upload build 2, which removes the external `Buy me a coffee` action. There is no donation or other payment flow in the app, so no in-app purchase is required for this build.
- Inspect all localized descriptions, promotional text, screenshots, and review notes for stale donation prompts or the old subtitle before resubmission.
- Suggested App Review reply: `We changed the subtitle to "Stay awake with one click" and removed the external donation action from the app. The replacement screenshot reflects the updated menu. Build 1.0 (2) contains these changes. No payment or donation flow remains in the app.`

## 4. Deployment Workflow
1. Increment `CURRENT_PROJECT_VERSION` and update `VERSION` / `MARKETING_VERSION`.
2. Run `scripts/release_macos_app_store.sh build` using the local App Store Connect API key.
3. Run `scripts/release_macos_app_store.sh validate`.
4. Run `scripts/release_macos_app_store.sh upload`.
5. Complete listing metadata, screenshots, privacy details, and export compliance in [App Store Connect](https://appstoreconnect.apple.com).
6. Select the processed build, then submit for review.

## 5. App Store Connect API release

Use the existing local API key outside this repository. Keep its private key out of command output and Git. Build an App Store Connect archive with the installed Xcode, export a `.pkg`, run `xcrun altool --validate-app`, then upload only after validation succeeds. Check delivery with `scripts/release_macos_app_store.sh status <delivery-uuid>`. A successful upload still requires processing and a completed App Store listing before review submission.
