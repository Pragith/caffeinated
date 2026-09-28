# Caffeinate-d 🍵☕️

A minimalist macOS menu bar application to keep your Mac's display and system awake.

[![Release](https://img.shields.io/github/v/release/Pragith/caffeinated)](https://github.com/Pragith/caffeinated/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- **Menu Bar Toggle**: A cup icon shows whether sleep prevention is active.
- **Native Power Management**: Uses macOS activity assertions to prevent display and idle system sleep while active.
- **Minimalist Design**: No Dock icon; controls live in the menu bar.
- **About Window**: Shows the app version and developer information.

## Installation

1. Download the latest `.dmg` from the [Releases](https://github.com/pragithp/caffeinated/releases) page.
2. Drag **Caffeinate-d** to your Applications folder.
3. Launch and enjoy.

## Usage

- **Left Click**: Toggles state.
- **Right Click**: Opens the menu for timed sessions, Launch at Login, About, and Exit.

Timed sessions are available for 1, 2, 5, and 10 minutes. The app does not prevent sleep when the Mac's lid is closed.

## Development

```bash
xcodebuild -project caffeinated/caffeinated.xcodeproj -scheme caffeinated -configuration Release -sdk macosx27.0 build
```

For Mac App Store distribution, see [the submission guide](docs/SUBMISSION_GUIDE.md) and use `scripts/release_macos_app_store.sh`. The App Store Connect API key stays outside the repository.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for details.

## License

MIT © 2026 Pragith Prakash. See [LICENSE](LICENSE) for details.
