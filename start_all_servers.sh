#!/bin/bash

# Start both backend and frontend servers for testing

echo "🚀 Couple App - Complete Setup"
echo "=================================="
echo ""

PROJECT_ROOT="/Users/alexandre/Apps/couple-app-starter"
BACKEND_PORT=8000

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Kill any existing processes on these ports
echo "🧹 Cleaning up old processes..."
lsof -i :$BACKEND_PORT | grep -v COMMAND | awk '{print $2}' | xargs kill -9 2>/dev/null || true
sleep 1

# Start Backend
echo ""
echo -e "${BLUE}1️⃣ Starting Django Backend on port $BACKEND_PORT...${NC}"
cd "$PROJECT_ROOT/backend"
python3 manage.py runserver 0.0.0.0:$BACKEND_PORT > /tmp/django_backend.log 2>&1 &
BACKEND_PID=$!
echo "✅ Backend started (PID: $BACKEND_PID)"
sleep 2

# Verify Backend
if curl -s http://localhost:$BACKEND_PORT/api/auth/me/ > /dev/null 2>&1; then
    echo "✅ Backend responding correctly"
else
    echo "❌ Backend not responding - check /tmp/django_backend.log"
fi

# Create test users
echo ""
echo "🔑 Setting up test users..."
cd "$PROJECT_ROOT/backend"
python3 manage.py shell -c "
from django.contrib.auth import get_user_model
User = get_user_model()

users = [
    ('alice', 'alice@example.com', 'alice12345'),
    ('bob', 'bob@example.com', 'bob12345'),
]

for username, email, password in users:
    user, created = User.objects.get_or_create(username=username, defaults={'email': email})
    user.set_password(password)
    user.save()
    print(f'✅ {username}: {email}')
" 2>/dev/null

echo ""
echo -e "${BLUE}2️⃣ Starting Flutter Frontend on Chrome...${NC}"
cd "$PROJECT_ROOT/frontend"
flutter run -d chrome > /tmp/flutter_frontend.log 2>&1 &
FRONTEND_PID=$!
echo "✅ Frontend started (PID: $FRONTEND_PID)"

echo ""
echo "🎉 Setup Complete!"
echo "=================================="
echo ""
echo "📋 Test Credentials:"
echo "  • Email: alice@example.com"
echo "  • Password: alice12345"
echo ""
echo "  • Email: bob@example.com"
echo "  • Password: bob12345"
echo ""
echo "🔗 URLs:"
echo "  • Backend API: http://localhost:$BACKEND_PORT/api/"
echo "  • Frontend: Check Chrome (should open automatically)"
echo ""
echo "📝 Logs:"
echo "  • Backend: tail -f /tmp/django_backend.log"
echo "  • Frontend: tail -f /tmp/flutter_frontend.log"
echo ""
echo "🛑 To stop:"
echo "  • Kill backend: kill $BACKEND_PID"
echo "  • Kill frontend: kill $FRONTEND_PID"
echo ""

trap "echo 'Stopping servers...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0" INT

echo "Press Ctrl+C to stop all servers"
echo ""

wait
