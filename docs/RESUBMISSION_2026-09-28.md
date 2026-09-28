# Mac App Store resubmission evidence

Date: 2026-09-28. App ID: `6767426617`. Bundle ID: `net.pragith.caffeinated`. App Store version: `1.0`.

## App and genuine captures

- Build 1.0 (4) links `Pragith Prakash` in About to `https://pragith.net/projects/caffeinate-d?utm_source=caffeinate-d&utm_medium=app&utm_campaign=about`. About no longer says `Pragith AI Inc.`; the external donation action remains removed.
- The release build was compiled, archived and exported with `scripts/release_macos_app_store.sh build`; Apple validation returned `VERIFY SUCCEEDED with no errors`.
- `docs/screenshots/build_1.0_4_menu_with_durations_original.png` is an unedited capture from the running build (SHA-256 `2be20b728531c01b7f8fd212a9e27127968ac6e802e9d261257c3f8d4683c32d`). It shows 1, 2, 5, and 10 minute options without a donation action.
- `docs/screenshots/build_1.0_4_about_original.png` is an unedited About capture (SHA-256 `c7bdea72a8df892821c91916c5d81f7754d6b1ebb63f0b991d18a274ac51d249`). These captures were supplied by the user from the running build, not reconstructed from the rejected image.
- `scripts/create_store_screenshots.py` creates two 1280 × 800 promotional images using the genuine menu capture: `docs/screenshots/app_store_01_one_click.png` and `docs/screenshots/app_store_02_timed_sessions.png`. The proposed About marketing image was withdrawn.

## Upload, processing, and selection

- Prior build 1.0 (2), delivery `44738ad1-f165-4d82-8eb9-9fb6c4a0c642`, was separately verified on App Store Connect as processed `VALID` and `APP_STORE_ELIGIBLE`; it was not reuploaded.
- Build 1.0 (4) upload returned `UPLOAD SUCCEEDED with no errors`, delivery UUID `b64d37f8-aabb-48cd-b4c4-5d9c52a93865`.
- Apple's delivery status reported `BUILD-STATUS VALID`, `IMPORT-STATUS VALID`, `IS-ON-APP-STORE-CONNECT true`, `BUILD-AUDIENCE-TYPE APP_STORE_ELIGIBLE`, and `PROCESSINGSTATE VALID`.
- The live App Store Connect API returned build 4 with `processingState=VALID`, `buildAudienceType=APP_STORE_ELIGIBLE`, `usesNonExemptEncryption=false`. Build 4 was selected for App Store version `807b24b0-2129-48f2-94bf-38ca79ed1f39` and confirmed in the live version page.
- Signing, entitlements, bundle ID, and deployment target were not changed. The API private key remains outside this repository.

## Live metadata and screenshots

- The sole App Information localization is `en-US` (`d9881f62-37ca-45c6-8b5d-ece590a7717c`); its live subtitle is exactly `Stay awake with one click`.
- The sole version localization is `en-US` (`e4e811a4-f6f2-4b44-8f54-8248ab002f74`); its live description, promotional text, keywords, URLs, and copyright match `docs/STORE_DESCRIPTION.md`. No donation prompt or rejected subtitle remains.
- Marketing URL: `https://pragith.net/apps/caffeinated`. It currently redirects to `/projects/caffeinate-d`, whose public page still says version 0.2.0; that website content needs a separate update.
- Screenshot set `208d6cb5-28d8-497c-a32e-4270f53502fe` contains only two completed `APP_DESKTOP` assets: `d22a47ce-c2f6-474e-8ec9-67353782ae7e` (`app_store_01_one_click.png`) and `ab6a56e4-249a-4527-b687-5ced50a7e442` (`app_store_02_timed_sessions.png`). A fresh API response reported total 2 with both `assetDeliveryState=COMPLETE`; the refreshed App Store Connect page showed these filenames. The rejected screenshot and discarded About graphic were removed from the live set.
- App Review notes (`appStoreReviewDetails/4cc5e075-334d-4933-a5ab-860708023f1f`) tell Apple about the subtitle, donation removal, replacement screenshots, and how to inspect the menu. A separate Resolution Center reply was not sent or verified.

## Submission and resulting state

- The existing rejected submission `07bb4787-dd6a-44ef-925b-566c2241af03` was updated: its rejected item became `READY_FOR_REVIEW`, then the submission was resubmitted via Apple's official App Store Connect API.
- Apple returned `submittedDate=2026-09-28T18:19:16.622Z` and `state=WAITING_FOR_REVIEW`. A fresh version query independently returned `appStoreState=WAITING_FOR_REVIEW` and `appVersionState=WAITING_FOR_REVIEW`.
- An empty draft submission (`b0ca4d58-f887-4388-a42e-73772f15d1a0`) was inadvertently created while checking the API flow. It has no items and was never submitted. Apple's API declined a cancel request because this draft state is not cancellable.

Apple has received the resubmission; approval and App Store publication have not occurred yet.
