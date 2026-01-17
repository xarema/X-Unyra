#!/bin/bash

# Script robuste pour démarrer les serveurs

cd /Users/alexandre/Apps/couple-app-starter

echo "🚀 Couple App — Démarrage Robuste"
echo "=================================="

# Kill any existing processes
echo "Nettoyage des anciens processus..."
pkill -9 -f "python.*manage" 2>/dev/null || true
pkill -9 -f "http.server" 2>/dev/null || true
sleep 2

# Start backend
echo ""
echo "📝 Démarrage Backend Django..."
cd backend

# Activer virtualenv et lancer le serveur
source /Users/alexandre/Apps/couple-app-starter/backend/.venv/bin/activate
export PYTHONUNBUFFERED=1
export DJANGO_SETTINGS_MODULE=couple_backend.settings

python -u manage.py runserver 0.0.0.0:8000 &
BACKEND_PID=$!
sleep 2

if ! ps -p $BACKEND_PID > /dev/null; then
    echo "❌ Backend failed to start"
    exit 1
fi
echo "✅ Backend started (PID: $BACKEND_PID)"

# Start frontend
echo ""
echo "🌐 Démarrage Frontend Web..."
cd ../web
python3 -m http.server 8080 > /dev/null 2>&1 &
FRONTEND_PID=$!
sleep 1

if ! ps -p $FRONTEND_PID > /dev/null; then
    echo "❌ Frontend failed to start"
    kill $BACKEND_PID
    exit 1
fi
echo "✅ Frontend started (PID: $FRONTEND_PID)"

echo ""
echo "=================================="
echo "✅ TOUT EST PRÊT!"
echo ""
echo "🌐 Ouvrir: http://localhost:8080"
echo ""
echo "Identifiants:"
echo "  alice@example.com / TestPass123!"
echo "  bob@example.com / TestPass123!"
echo ""
echo "PIDs: Backend=$BACKEND_PID Frontend=$FRONTEND_PID"
echo ""
echo "Appuyez Ctrl+C pour arrêter"
echo ""

# Keep running
wait
