# App Review remediation and build 1.0 (2) delivery

**Follow-up:** Build 1.0 (4) and the corrected listing were resubmitted on 2026-09-28. See [resubmission evidence](RESUBMISSION_2026-09-28.md). The remaining-work section below records the state at the time of build 2 delivery.

Date: 2026-09-28

App: Caffeinate-d (`net.pragith.caffeinated`)

Rejected submission: `07bb4787-dd6a-44ef-925b-566c2241af03`

Reviewed build: 1.0 (1)

## Review findings and decisions

App Review cited guideline 5.2.5 because the subtitle used `Mac` inappropriately, and guideline 3.1.1 because the app's `Buy me a coffee...` menu item opened an external donation page. The name `Caffeinate-d` was not cited. We kept it and changed the proposed subtitle from `Keep Mac awake with one click` to `Stay awake with one click`. We removed the donation action rather than adding an in-app purchase. The revised app has no payment flow.

Policy reference: [Apple App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/).

## Changes made

- Removed the external donation menu item, its action, and the unused Buy Me a Coffee image asset.
- Removed the About window link to a public page describing an older implementation; replaced the missing-icon emoji fallback with a system symbol.
- Set both Xcode configurations to build number 2, preserving marketing version 1.0 and bundle ID `net.pragith.caffeinated`.
- Revised the draft store description and subtitle, README, release notes, changelog, and submission guide. The old screenshot, which visibly includes the donation item, is preserved as `docs/screenshots/rejected_1.0_1_awake_menu.png` and must not be submitted again.
- Ignored a local agent-configuration symlink and a temporary screenshot file without adding either to Git.
- Corrected the release script to read the build number from the Xcode project and to use a separate `1.0-2` archive/export directory. Previously it forced build 1 and reused the `1.0` directory.

The source changes were pushed in commits `0f516e1`, `a63ed5b`, and `721af5d`. The release-script fix and this record accompany the build 2 delivery.

## Build and delivery evidence

The script `scripts/release_macos_app_store.sh` used Xcode 27.0 and its macOS 27.0 SDK. It created an archive at `caffeinated/build/releases/1.0-2/Caffeinate-d-1.0-2.xcarchive` and exported `caffeinated/build/releases/1.0-2/export/caffeinate-d.pkg`. Both archive and export succeeded. The archive itself used a development signature; the **exported package** contains an app signed by `Apple Distribution: Pragith Prakash (CX233729CS)` and a package signed by the team's installer certificate. The exported app is universal (arm64 and x86_64), identifies as version 1.0, build 2, and has App Sandbox enabled. A binary-string check found no donation URL or prompt.

Package SHA-256: `e9d0170df87bcc793da6a15d766b407babe15d539626e2b2d8b3cc46947b348a`

Apple's `altool --validate-app` returned `VERIFY SUCCEEDED with no errors`. The upload returned `UPLOAD SUCCEEDED with no errors` with delivery UUID `44738ad1-f165-4d82-8eb9-9fb6c4a0c642`. A subsequent `altool --build-status` query returned `BUILD-STATUS: VALID`, `IMPORT-STATUS: VALID`, `IS-ON-APP-STORE-CONNECT: true`, `BUILD-AUDIENCE-TYPE: APP_STORE_ELIGIBLE`, and `PROCESSINGSTATE: VALID` for build 2.

The API private key stayed outside this repository. Local command logs are in `/tmp/caffeinated-build-2-{archive,validate,upload,status}.log` and are not part of the committed evidence.

## Remaining App Store Connect work

The upload and processing succeeded; the app has **not** been resubmitted or approved. Set the subtitle to `Stay awake with one click` in each localization, update any other stale listing text, capture and upload a genuine screenshot of build 2's menu without the donation item, remove the old screenshot, select build 1.0 (2), then resubmit. Send the review reply drafted in `docs/SUBMISSION_GUIDE.md` only after those changes are complete.

Computer-use access to the rebuilt app was repeatedly rejected with `Computer Use was not approved to use Caffeinate-d`; the tool supplied no further reason. Therefore a replacement screenshot and live menu inspection were not completed in this session. The old screenshot remains archived solely as evidence of the rejected listing.
