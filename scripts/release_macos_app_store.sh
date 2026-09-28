#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT="$ROOT_DIR/caffeinated/caffeinated.xcodeproj"
VERSION="$(tr -d '[:space:]' < "$ROOT_DIR/VERSION")"
BUILD_NUMBER="$(sed -n 's/^[[:space:]]*CURRENT_PROJECT_VERSION = \([0-9][0-9]*\);$/\1/p' "$PROJECT/project.pbxproj" | sort -u)"
[[ "$BUILD_NUMBER" =~ ^[0-9]+$ ]] || { printf 'error: Xcode build numbers are missing or inconsistent\n' >&2; exit 1; }
RELEASE_DIR="$ROOT_DIR/caffeinated/build/releases/$VERSION-$BUILD_NUMBER"
ARCHIVE="$RELEASE_DIR/Caffeinate-d-$VERSION-$BUILD_NUMBER.xcarchive"
EXPORT_DIR="$RELEASE_DIR/export"
PACKAGE="$EXPORT_DIR/caffeinate-d.pkg"
ACTION="${1:-}"
KEY_ID="${ASC_KEY_ID:-DGY98Y73K3}"
ISSUER_ID="${ASC_ISSUER_ID:-698b6c7e-33bb-4bc7-a929-ae075b141ed2}"
KEY_PATH="${ASC_KEY_PATH:-/Users/pragith/Downloads/projects/velvet/secrets/AuthKey_${KEY_ID}.p8}"

die() { printf 'error: %s\n' "$*" >&2; exit 1; }
require_key() {
    [[ -f "$KEY_PATH" ]] || die "App Store Connect API key not found: $KEY_PATH"
    local mode
    mode="$(stat -f '%Lp' "$KEY_PATH")"
    [[ "$mode" == 600 || "$mode" == 400 ]] || die "API key permissions must be 600 or 400 (found $mode)"
}
altool() {
    require_key
    API_PRIVATE_KEYS_DIR="$(dirname "$KEY_PATH")" xcrun altool "$1" -f "$PACKAGE" -t macos \
        --api-key "$KEY_ID" --api-issuer "$ISSUER_ID"
}

case "$ACTION" in
    build)
        require_key
        mkdir -p "$RELEASE_DIR"
        export_options="$(mktemp "${TMPDIR:-/tmp}/caffeinated-export.XXXXXX")"
        trap 'rm -f "$export_options"' EXIT
        cat > "$export_options" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0"><dict>
  <key>destination</key><string>export</string>
  <key>method</key><string>app-store-connect</string>
  <key>signingStyle</key><string>automatic</string>
  <key>teamID</key><string>CX233729CS</string>
</dict></plist>
PLIST
        xcodebuild -project "$PROJECT" -scheme caffeinated -configuration Release -sdk macosx27.0 \
            -destination 'generic/platform=macOS' -archivePath "$ARCHIVE" archive \
            CURRENT_PROJECT_VERSION="$BUILD_NUMBER" MARKETING_VERSION="$VERSION" \
            CODE_SIGN_STYLE=Automatic -allowProvisioningUpdates \
            -authenticationKeyPath "$KEY_PATH" -authenticationKeyID "$KEY_ID" \
            -authenticationKeyIssuerID "$ISSUER_ID"
        xcodebuild -exportArchive -archivePath "$ARCHIVE" -exportPath "$EXPORT_DIR" \
            -exportOptionsPlist "$export_options" -allowProvisioningUpdates \
            -authenticationKeyPath "$KEY_PATH" -authenticationKeyID "$KEY_ID" \
            -authenticationKeyIssuerID "$ISSUER_ID"
        found_package="$(find "$EXPORT_DIR" -maxdepth 1 -type f -name '*.pkg' -print -quit)"
        [[ -n "$found_package" ]] || die "Xcode did not export an App Store package"
        [[ "$found_package" == "$PACKAGE" ]] || mv "$found_package" "$PACKAGE"
        pkgutil --check-signature "$PACKAGE"
        printf 'Package ready: %s\n' "$PACKAGE"
        ;;
    validate)
        [[ -f "$PACKAGE" ]] || die "Build first; package missing: $PACKAGE"
        altool --validate-app
        ;;
    upload)
        [[ -f "$PACKAGE" ]] || die "Build and validate first; package missing: $PACKAGE"
        altool --upload-app
        ;;
    status)
        [[ $# -eq 2 && -n "$2" ]] || die "pass the App Store Connect delivery UUID"
        require_key
        API_PRIVATE_KEYS_DIR="$(dirname "$KEY_PATH")" xcrun altool --build-status \
            --delivery-id "$2" --api-key "$KEY_ID" --api-issuer "$ISSUER_ID"
        ;;
    *)
        printf 'Usage: %s {build|validate|upload|status DELIVERY_UUID}\n' "$0" >&2
        exit 2
        ;;
esac
