#!/bin/bash

# Simpler startup script
cd /Users/alexandre/Apps/couple-app-starter

# Kill old processes
pkill -9 -f "python.*runserver" 2>/dev/null
pkill -9 -f flutter 2>/dev/null
sleep 2

# Backend
cd backend
source .venv/bin/activate
python setup_couple_test.py 2>/dev/null
python manage.py runserver 0.0.0.0:8000 &
sleep 3

# Frontend
cd ../frontend
flutter pub get 2>/dev/null
flutter run -d chrome &

sleep 5
echo ""
echo "================================"
echo "✅ STARTUP COMPLETE"
echo "================================"
echo ""
echo "🔌 Backend: http://localhost:8000"
echo "📱 Frontend: Check Chrome tabs"
echo ""
echo "👤 Test: alice@example.com / testpass123"
echo ""
