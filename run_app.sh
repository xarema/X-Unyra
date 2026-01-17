#!/bin/bash
# 🚀 FLUTTER APP LAUNCHER - Smart device selection

set -e

cd "$(dirname "$0")/frontend" || exit 1

echo "================================================"
echo "🚀 FLUTTER APP LAUNCHER"
echo "================================================"
echo ""

# Add Flutter to PATH if needed
export PATH="/Users/alexandre/development/flutter/bin:$PATH"

echo "Checking Flutter installation..."
flutter --version | head -1

echo ""
echo "Available devices:"
echo "1. Chrome (Web)   - Best for quick testing"
echo "2. macOS (Desktop) - Native app"
echo "3. Exit"
echo ""

# Check which devices are actually available
HAS_CHROME=false
HAS_MACOS=false

DEVICES=$(flutter devices 2>/dev/null)

if echo "$DEVICES" | grep -q "chrome"; then
    HAS_CHROME=true
fi

if echo "$DEVICES" | grep -q "macos"; then
    HAS_MACOS=true
fi

# If running non-interactively, default to Chrome
if [ -z "$PS1" ]; then
    TARGET_DEVICE="chrome"
else
    # Interactive mode
    read -p "Choose device (1-3): " choice

    case $choice in
        1)
            TARGET_DEVICE="chrome"
            ;;
        2)
            TARGET_DEVICE="macos"
            ;;
        3)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid choice. Defaulting to Chrome..."
            TARGET_DEVICE="chrome"
            ;;
    esac
fi

echo ""
echo "🚀 Launching Flutter app on $TARGET_DEVICE..."
echo ""
echo "Tips:"
echo "- Press 'r' to hot reload"
echo "- Press 'R' to hot restart"
echo "- Press 'q' to quit"
echo ""

# Kill any existing Flutter processes for clean start
pkill -f "flutter run" 2>/dev/null || true
sleep 1

# Run on selected device
if [ "$TARGET_DEVICE" = "chrome" ]; then
    echo "💻 Opening Chrome browser..."
    flutter run -d chrome
elif [ "$TARGET_DEVICE" = "macos" ]; then
    echo "🖥️  Opening macOS app..."
    flutter run -d macos
fi
