# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/0.1.4/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-05-25

### Added
- Overhauled status bar icon to use beautiful, native SF Symbols (`cup.and.saucer` / `cup.and.saucer.fill`).
- Added "Prevent Lid Sleep (Requires Password)" context menu checkbox to prevent MacBook sleep on lid close.
- Integrated administrator password/Touch ID prompts via native AppleScript secure dialogs.
- Placed "Buy me a coffee..." option cleanly inside the tray context menu.

### Removed
- Removed the large "Buy me a coffee" image button from the About window.

## [1.0] - 2026-09-23

### Added
- Replaced the `caffeinate` subprocess with native `ProcessInfo` activity assertions for display and system idle sleep prevention, compatible with App Sandbox distribution.
- Added VoiceOver labels and values for the menu bar control.
- Read the app version from its bundle metadata and set the release copyright in the generated Info.plist.

### Changed
- Aligned the release with the existing App Store Connect macOS version record and incremented the build number.

## [0.1.4] - 2026-05-08

### Added
- Initial release of Caffeinate-d.
- Menu bar integration with status toggle.
- Support for `caffeinate -d` background execution.
- About window with developer information and donate link.
- Automatic hiding of Dock icon (LSUIElement).
