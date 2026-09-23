# Mac App Store Submission Checklist

This guide outlines the technical and administrative steps required to publish Caffeinate-d to the Mac App Store.

## 1. Technical Requirements
- [ ] **Bundle Identifier**: Ensure `net.pragith.caffeinated` is registered in Apple Developer Portal.
- [x] **App Sandbox**: Enabled in the Xcode target.
- [x] **Power management**: Uses Foundation `ProcessInfo` activity assertions; no subprocess or administrator prompt is used.
- [ ] **Iconography**: Needs high-res icons (1024x1024 down to 16x16) in an `.appiconset`.

## 2. Store Assets
- [x] **Mac screenshot**: The actual awake menu is captured at `docs/screenshots/caffeinated_app_store_awake_menu.png` (1280×800, opaque PNG) and uploaded to the 1.0 App Store Connect listing. Add further states such as a timed session or About window if desired.
- [x] **Icon**: AppIcon asset catalog includes a 1024x1024 icon.
- [x] **Privacy Policy**: `https://pragith.net/privacy` is live.

## 3. Deployment Workflow
1. Increment `CURRENT_PROJECT_VERSION` and update `VERSION` / `MARKETING_VERSION`.
2. Run `scripts/release_macos_app_store.sh build` using the local App Store Connect API key.
3. Run `scripts/release_macos_app_store.sh validate`.
4. Run `scripts/release_macos_app_store.sh upload`.
5. Complete listing metadata, screenshots, privacy details, and export compliance in [App Store Connect](https://appstoreconnect.apple.com).
6. Select the processed build, then submit for review.

## 4. App Store Connect API release

Use the existing local API key outside this repository. Keep its private key out of command output and Git. Build an App Store Connect archive with the installed Xcode, export a `.pkg`, run `xcrun altool --validate-app`, then upload only after validation succeeds. Check delivery with `scripts/release_macos_app_store.sh status <delivery-uuid>`. A successful upload still requires processing and a completed App Store listing before review submission.
