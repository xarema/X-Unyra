#!/bin/bash
cd /Users/alexandre/Apps/couple-app-starter/backend
source .venv/bin/activate

# Kill any existing server
pkill -f "python.*runserver" 2>/dev/null
sleep 1

# Run fix_users script
echo "=== Fixing users ==="
python fix_users.py

# Start server
echo "=== Starting Django server ==="
python manage.py runserver 0.0.0.0:8000 &
SERVER_PID=$!
sleep 3

# Check if running
echo "=== Server check ==="
lsof -i :8000

# Test login
echo "=== Testing login ==="
curl -s -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"testpass123"}'

echo ""
echo "=== DONE ==="
echo "Server PID: $SERVER_PID"
echo "Access: http://localhost:8000"
