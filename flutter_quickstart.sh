#!/bin/bash
# ✅ FLUTTER PROJECT QUICK START SCRIPT

echo "================================================"
echo "🚀 COUPLE APP FLUTTER - QUICK START"
echo "================================================"
echo ""

# Ensure Flutter is in PATH
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found in PATH"
    echo "Adding to PATH..."
    export PATH="/Users/alexandre/development/flutter/bin:$PATH"
fi

cd "$(dirname "$0")/frontend" || exit 1

echo "✅ Flutter version:"
flutter --version
echo ""

echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "✅ Dart analysis:"
flutter analyze --no-preamble | tail -1

echo ""
echo "================================================"
echo "🎯 READY TO RUN!"
echo "================================================"
echo ""
echo "Available commands:"
echo "  flutter run              - Run on connected device/emulator"
echo "  flutter build apk        - Build Android APK"
echo "  flutter build ios        - Build iOS app"
echo "  flutter build web        - Build web version"
echo ""
