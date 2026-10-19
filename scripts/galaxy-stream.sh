#!/usr/bin/env bash
set -euo pipefail

echo "=========================================================="
echo " [tapflow] Samsung Galaxy AVD Web Streamer"
echo "=========================================================="

export PATH="/opt/homebrew/bin:$PATH"
SDK_PATH="${ANDROID_HOME:-${ANDROID_SDK_ROOT:-$HOME/Library/Android/sdk}}"
export ANDROID_HOME="$SDK_PATH"

# 1. Check running emulator via ADB
echo "🔍 Checking for active Android devices or emulators..."
DEVICES=$(adb devices | grep -v "List of devices" | grep "device$" || true)

if [ -z "$DEVICES" ]; then
  echo "⚠️ No running Android emulator or device found via adb."
  echo "💡 Tip: You can launch your Galaxy AVD first with:"
  echo "   npx galaxy-emu run s24u (or from ~/Documents/projects/galaxy-emulator-mac)"
  echo ""
  read -p "Do you want to launch Galaxy S24 Ultra in background now? (y/N): " -r CONFIRM
  if [[ "$CONFIRM" =~ ^[Yy]$ ]]; then
    if [ -x "$HOME/Documents/projects/galaxy-emulator-mac/bin/galaxy-emu" ]; then
      echo "🚀 Starting Galaxy S24 Ultra in headless/background mode..."
      "$HOME/Documents/projects/galaxy-emulator-mac/bin/galaxy-emu" run s24u --headless &
      sleep 5
    fi
  fi
fi

echo "🌐 Starting tapflow web dashboard and android-agent..."
echo "Open http://localhost:3000 in your browser once the server starts."

pnpm start || pnpm dev || npx tapflow start
