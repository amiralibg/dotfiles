#!/usr/bin/env bash
# Compiles main.swift into a menu-bar agent .app bundle.
set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
APP="$DIR/build/YabaiSpaces.app"
BIN="$APP/Contents/MacOS/YabaiSpaces"

rm -rf "$APP"
mkdir -p "$APP/Contents/MacOS"

echo "Compiling…"
swiftc -O "$DIR/main.swift" -o "$BIN"

cat > "$APP/Contents/Info.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>CFBundleName</key><string>YabaiSpaces</string>
  <key>CFBundleDisplayName</key><string>YabaiSpaces</string>
  <key>CFBundleIdentifier</key><string>local.yabai.spaces</string>
  <key>CFBundleExecutable</key><string>YabaiSpaces</string>
  <key>CFBundlePackageType</key><string>APPL</string>
  <key>CFBundleShortVersionString</key><string>1.0</string>
  <key>LSUIElement</key><true/>
  <key>LSMinimumSystemVersion</key><string>13.0</string>
</dict>
</plist>
PLIST

echo "Built: $APP"
echo
echo "Launch now:        open \"$APP\""
echo "Auto-start: System Settings → General → Login Items → + → pick YabaiSpaces.app"
