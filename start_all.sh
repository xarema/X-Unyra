#!/bin/bash

echo "🔧 STARTUP COUPLE APP - COMPLETE"
echo "=================================="

# Kill any existing processes
echo "1️⃣  Tuant les anciens processus..."
pkill -9 -f "python.*runserver" 2>/dev/null
pkill -9 -f "flutter" 2>/dev/null
pkill -9 -f "chrome" 2>/dev/null
sleep 2

# Start backend
echo ""
echo "2️⃣  Démarrage du backend Django..."
cd /Users/alexandre/Apps/couple-app-starter/backend
source .venv/bin/activate

# Setup couple
python3 setup_couple_test.py > /dev/null 2>&1

# Start Django server
python3 manage.py runserver 0.0.0.0:8000 > /tmp/django.log 2>&1 &
DJANGO_PID=$!
sleep 3

# Check if running
if lsof -i :8000 > /dev/null 2>&1; then
  echo "   ✅ Backend running on port 8000 (PID: $DJANGO_PID)"
else
  echo "   ❌ Backend failed to start"
  cat /tmp/django.log
  exit 1
fi

# Start frontend
echo ""
echo "3️⃣  Démarrage du frontend Flutter..."
cd /Users/alexandre/Apps/couple-app-starter/frontend

# Check if Flutter is configured for web
if [ ! -d "build/web" ]; then
  echo "   ⚠️  Flutter web not built, building now..."
  flutter build web > /dev/null 2>&1
fi

# Run Flutter on Chrome
flutter run -d chrome > /tmp/flutter.log 2>&1 &
FLUTTER_PID=$!
sleep 5

echo "   ✅ Frontend launching on Chrome (PID: $FLUTTER_PID)"

echo ""
echo "=================================="
echo "🎉 APP READY!"
echo "=================================="
echo ""
echo "📱 Frontend: http://localhost:* (check Chrome tab)"
echo "🔌 Backend:  http://localhost:8000"
echo ""
echo "👤 Test Credentials:"
echo "   Email: alice@example.com"
echo "   Pass:  testpass123"
echo ""
echo "   Email: bob@example.com"
echo "   Pass:  testpass123"
echo ""
echo "📝 Pairing Code: TEST123"
echo ""
echo "=================================="
