# 🚀 FLUTTER RUN - HOW TO START THE APP

## Available Devices

You have these devices available:

1. **Chrome (Web)** - Best for quick testing
2. **macOS (Desktop)** - Native app experience
3. *(Mobile devices - Connect Android/iOS device to enable)*

---

## 🌐 Option 1: Run on Web (Recommended for testing)

### Quick Start:
```bash
cd /Users/alexandre/Apps/couple-app-starter/frontend
flutter run -d chrome
```

This will:
- ✅ Launch Chrome automatically
- ✅ Start the dev server
- ✅ Open http://localhost:55245 (or similar)
- ✅ Enable hot reload

### What to expect:
- Browser opens with your Flutter app
- Changes auto-reload when you save code
- DevTools available at http://localhost:9100

---

## 🖥️ Option 2: Run on macOS Desktop

### First time only:
```bash
cd /Users/alexandre/Apps/couple-app-starter/frontend
flutter pub get
flutter run -d macos
```

### What to expect:
- Native macOS app window opens
- Full desktop experience
- Hot reload enabled
- Better performance than web

---

## 📱 Option 3: Run on Android Emulator (if available)

```bash
# Check available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator_id>

# Then run the app
flutter run
```

---

## 🎯 Quick Commands

```bash
cd /Users/alexandre/Apps/couple-app-starter/frontend

# List available devices
flutter devices

# Run with device selection
flutter run -d chrome          # Web
flutter run -d macos           # macOS
flutter run -d android         # Android (if connected)

# Run with hot reload
flutter run --hot

# Run with verbose logging
flutter run -v

# Build for production
flutter build web              # Web build
flutter build macos            # macOS app
flutter build apk              # Android APK
```

---

## 🔧 Troubleshooting

### If Chrome doesn't start:
```bash
# Kill any existing processes
pkill -f flutter
pkill -f chrome

# Try again
flutter run -d chrome
```

### If macOS build fails:
```bash
flutter clean
flutter pub get
flutter run -d macos
```

### If port is in use:
```bash
# Find what's using port 8080 or 55245
lsof -i :8080
lsof -i :55245

# Kill it
kill -9 <PID>

# Try again
flutter run -d chrome
```

---

## ✅ What to Test

Once the app is running, you can:

1. **Navigation** - Test bottom navigation bar
2. **Screens** - Check all feature screens load
3. **Hot Reload** - Edit code and see changes
4. **Responsive** - Resize browser/window to test responsiveness

---

## 🎨 Development Workflow

```bash
# Terminal 1: Start the app
cd frontend
flutter run -d chrome

# Terminal 2: (Optional) Run tests
flutter test

# Terminal 3: (Optional) Analyze code
flutter analyze
```

---

## 📊 Device Status

```bash
# Check your setup
flutter doctor

# This shows:
✓ Flutter SDK
✓ Android toolchain (if available)
✓ Xcode (if available)
✓ Chrome
✓ VS Code / Android Studio
```

---

## 🎉 You're Ready!

Choose your preferred device and run:

### For Web (Fastest):
```bash
flutter run -d chrome
```

### For Desktop:
```bash
flutter run -d macos
```

**App will start in ~30 seconds!**

---

**Date**: 16 January 2026  
**Status**: ✅ READY TO RUN
