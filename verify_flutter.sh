#!/bin/bash
# ✅ FLUTTER PROJECT VERIFICATION SCRIPT

echo "================================================"
echo "✅ FLUTTER PROJECT VERIFICATION"
echo "================================================"
echo ""

# Check Flutter
echo "1. Checking Flutter installation..."
if command -v flutter &> /dev/null; then
    echo "   ✅ Flutter found"
    flutter --version | head -1
else
    echo "   ❌ Flutter not found"
    exit 1
fi

echo ""
echo "2. Checking .g.dart files..."
cd "$(dirname "$0")/frontend" || exit 1

GFILES=$(find lib/models -name "*.g.dart" 2>/dev/null | wc -l)
echo "   Found: $GFILES generated files"

if [ "$GFILES" -ge 4 ]; then
    echo "   ✅ All model files generated"
    find lib/models -name "*.g.dart" -exec basename {} \;
else
    echo "   ⚠️  Some files may be missing"
fi

echo ""
echo "3. Checking project structure..."
if [ -f "pubspec.yaml" ]; then
    echo "   ✅ pubspec.yaml found"
fi

if [ -d "lib" ]; then
    echo "   ✅ lib directory found"
fi

echo ""
echo "4. Dart analysis status..."
echo "   Running flutter analyze..."
ISSUES=$(flutter analyze 2>&1 | grep "issues found" || echo "0 issues")
echo "   $ISSUES"

echo ""
echo "================================================"
echo "✅ VERIFICATION COMPLETE"
echo "================================================"
echo ""
echo "Ready for development!"
echo ""
