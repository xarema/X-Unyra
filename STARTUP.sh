#!/bin/bash

echo "==============================================="
echo "🚀 COUPLE APP - COMPLETE STARTUP"
echo "==============================================="
echo ""

# Kill everything
echo "1️⃣  Killing old processes..."
pkill -9 -f "python.*runserver" 2>/dev/null
pkill -9 -f "flutter" 2>/dev/null
pkill -9 Chrome 2>/dev/null
sleep 2

# Start backend
echo ""
echo "2️⃣  Starting Django Backend..."
cd /Users/alexandre/Apps/couple-app-starter/backend
source .venv/bin/activate
python setup_couple_test.py > /dev/null 2>&1
nohup python manage.py runserver 0.0.0.0:8000 > /tmp/django.log 2>&1 &
DJANGO_PID=$!
sleep 3

if lsof -i :8000 > /dev/null 2>&1; then
  echo "   ✅ Backend running on http://localhost:8000"
else
  echo "   ❌ Backend failed to start!"
  cat /tmp/django.log
  exit 1
fi

# Start frontend
echo ""
echo "3️⃣  Starting Flutter Frontend..."
cd /Users/alexandre/Apps/couple-app-starter/frontend

# Ensure dependencies are up to date
flutter pub get > /dev/null 2>&1

# Launch on Chrome
nohup flutter run -d chrome > /tmp/flutter.log 2>&1 &
FLUTTER_PID=$!
sleep 10

if pgrep -f "chrome.*flutter" > /dev/null 2>&1; then
  echo "   ✅ Frontend launching in Chrome (PID: $FLUTTER_PID)"
else
  echo "   ⚠️  Flutter launch in progress..."
  echo "   Check Chrome tab in a moment"
fi

echo ""
echo "==============================================="
echo "✅ STARTUP COMPLETE!"
echo "==============================================="
echo ""
echo "📍 ENDPOINTS:"
echo "   Backend:  http://localhost:8000"
echo "   Frontend: Check your Chrome tabs"
echo ""
echo "👤 TEST CREDENTIALS:"
echo "   alice@example.com / testpass123"
echo "   bob@example.com / testpass123"
echo ""
echo "💌 PAIRING CODE: TEST123"
echo ""
echo "📋 LOGS:"
echo "   Django:  tail -f /tmp/django.log"
echo "   Flutter: tail -f /tmp/flutter.log"
echo ""
echo "==============================================="
