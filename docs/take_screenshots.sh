#!/bin/bash

# Caffeinate-d Screenshot Utility
# This script takes MAS-compliant screenshots with a 5-second delay.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DEST="$ROOT_DIR/docs/screenshots"
APP_PATH="$ROOT_DIR/caffeinated/build/Build/Products/Release/caffeinate-d.app"
mkdir -p "$DEST"

echo "☕ Caffeinate-d Screenshot Utility"
echo "----------------------------------"

capture() {
    local name=$1
    local desc=$2
    echo "[DELAY] 5 seconds for: $desc"
    sleep 5
    # The operator must place the target state on screen before each capture.
    screencapture -x "$DEST/$name.png"
    echo "✅ Saved to $DEST/$name.png"
    echo ""
}

# Ensure the app is running
if [[ ! -d "$APP_PATH" ]]; then
    echo "Build the Release app first: $APP_PATH" >&2
    exit 1
fi
open -a "$APP_PATH"

echo "Place each requested app state on screen during its five-second countdown."

capture "1_off_state" "Show the 🍵 icon in the menu bar."
capture "2_on_state" "Show the ☕ icon in the menu bar."
capture "3_menu_open" "Right-click the icon to show the Intervals and Preferences menu."
capture "4_about_window" "Open the About window and center it on your screen."

echo "🎉 Done! Screenshots are ready in $DEST"
