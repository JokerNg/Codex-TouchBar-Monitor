#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
APP_DIR="$ROOT_DIR/build/CodexTouchBarMonitor.app"
MACOS_DIR="$APP_DIR/Contents/MacOS"
RESOURCES_DIR="$APP_DIR/Contents/Resources"
FRAMEWORKS_DIR="$APP_DIR/Contents/Frameworks"
EXECUTABLE_PATH="$ROOT_DIR/.build/release/CodexTouchBarMonitor"
MODULE_CACHE="${TMPDIR:-/tmp}/codex-touchbar-monitor-module-cache"

cd "$ROOT_DIR"

if ! swift build -c release; then
    SDK_PATH="${SDKROOT:-$(xcrun --sdk macosx --show-sdk-path)}"
    SPARKLE_FRAMEWORK="$(find "$ROOT_DIR/.build/artifacts" -path '*/macos-arm64_x86_64/Sparkle.framework' -print -quit)"
    test -n "$SPARKLE_FRAMEWORK"
    mkdir -p "$(dirname "$EXECUTABLE_PATH")" "$MODULE_CACHE"
    swiftc -sdk "$SDK_PATH" \
        -Xcc "-fmodules-cache-path=$MODULE_CACHE" \
        -F "$(dirname "$SPARKLE_FRAMEWORK")" \
        -framework Sparkle \
        -Xlinker -rpath -Xlinker @executable_path/../Frameworks \
        Sources/*.swift \
        -o "$EXECUTABLE_PATH"
fi

rm -rf "$APP_DIR"
mkdir -p "$MACOS_DIR" "$RESOURCES_DIR" "$FRAMEWORKS_DIR"
cp "$EXECUTABLE_PATH" "$MACOS_DIR/CodexTouchBarMonitor"
SPARKLE_FRAMEWORK="${SPARKLE_FRAMEWORK:-$(find "$ROOT_DIR/.build/artifacts" -path '*/macos-arm64_x86_64/Sparkle.framework' -print -quit)}"
test -n "$SPARKLE_FRAMEWORK"
cp -R "$SPARKLE_FRAMEWORK" "$FRAMEWORKS_DIR/Sparkle.framework"
cp "Resources/Info.plist" "$APP_DIR/Contents/Info.plist"
cp "Resources/AppIcon.icns" "$RESOURCES_DIR/AppIcon.icns"
cp "Resources/codex-token-launcher.sh" "$RESOURCES_DIR/codex-token-launcher.sh"
chmod +x "$RESOURCES_DIR/codex-token-launcher.sh"
codesign --force --deep --sign - "$APP_DIR" >/dev/null 2>&1 || true

echo "$APP_DIR"
