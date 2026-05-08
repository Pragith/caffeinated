# Mac App Store Submission Checklist

This guide outlines the technical and administrative steps required to publish Caffeinate-d to the Mac App Store.

## 1. Technical Requirements
- [ ] **Bundle Identifier**: Ensure `net.pragith.caffeinated` is registered in Apple Developer Portal.
- [ ] **App Sandbox**: App Store apps must be sandboxed.
    - *Note*: Sandboxing may restrict the ability to run `/usr/bin/caffeinate` directly. We may need to use `IOPMAssertionCreateWithName` for a Sandboxed MAS version.
- [ ] **Hardened Runtime**: Required for notarization and MAS submission.
- [ ] **Iconography**: Needs high-res icons (1024x1024 down to 16x16) in an `.appiconset`.

## 2. Store Assets
- [ ] **Screenshots**: At least 3 high-res screenshots of the menu bar toggle and About window.
- [ ] **Icon**: Final professional icon (the ☕ emoji is great for menu bar, but MAS requires a real `.png` icon).
- [ ] **Privacy Policy**: A hosted privacy policy URL is mandatory.

## 3. Deployment Workflow
1. Increment build number in Xcode.
2. Archive the app: `Product -> Archive`.
3. Validate Archive in Xcode Organizer.
4. Distribute to "App Store Connect".
5. Complete metadata in [App Store Connect](https://appstoreconnect.apple.com).
6. Submit for Review.

## 4. Technical Note on 'caffeinate'
The current implementation uses `Process()` to call `/usr/bin/caffeinate`. For the **official Mac App Store version**, Apple usually requires using the Power Management API directly to avoid Sandbox violations.

**Recommended API for MAS Version:**
```swift
import IOKit.pwr_mgt
var assertionID: IOPMAssertionID = 0
IOPMAssertionCreateWithName(kIOPMAssertionTypeNoDisplaySleep as CFString, 
                           IOPMAssertionLevel(kIOPMAssertionLevelOn), 
                           "Caffeinate-d App Awake" as CFString, 
                           &assertionID)
```
