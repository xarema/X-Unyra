#!/bin/bash

# Script de démarrage automatique pour Couple App
# Usage: ./run_tests.sh

set -e

echo "🚀 Couple App MVP — Démarrage automatique"
echo "=========================================="
echo ""

# Check Python
if ! command -v python3 &> /dev/null; then
    echo "❌ Python 3 n'est pas trouvé!"
    echo "Installez Python 3 d'abord:"
    echo "  macOS: brew install python3"
    echo "  Windows: https://python.org"
    echo "  Linux: sudo apt-get install python3"
    exit 1
fi

echo "✅ Python trouvé: $(python3 --version)"
echo ""

# Check if port 8000 is in use
if lsof -Pi :8000 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "⚠️  Port 8000 déjà utilisé!"
    echo "Tuer le processus: lsof -ti:8000 | xargs kill -9"
    exit 1
fi

echo "🔧 Démarrage des serveurs..."
echo ""

# Start backend
echo "📝 Backend Django (port 8000)..."
cd backend
python3 manage.py runserver 0.0.0.0:8000 > /tmp/backend.log 2>&1 &
BACKEND_PID=$!
echo "✅ Backend démarré (PID: $BACKEND_PID)"

sleep 2

# Start frontend
echo "🌐 Frontend Web (port 8080)..."
cd ../web
python3 -m http.server 8080 > /tmp/frontend.log 2>&1 &
FRONTEND_PID=$!
echo "✅ Frontend démarré (PID: $FRONTEND_PID)"

echo ""
echo "=========================================="
echo "🎉 SERVEURS DÉMARRÉS!"
echo "=========================================="
echo ""
echo "📱 Navigateur: http://localhost:8080"
echo ""
echo "👤 Identifiants de test:"
echo "   Alice: alice@example.com / TestPass123!"
echo "   Bob:   bob@example.com / TestPass123!"
echo ""
echo "⏹️  Pour arrêter:"
echo "   kill $BACKEND_PID $FRONTEND_PID"
echo ""
echo "📊 Logs:"
echo "   Backend: tail -f /tmp/backend.log"
echo "   Frontend: tail -f /tmp/frontend.log"
echo ""

# Keep script running
wait
