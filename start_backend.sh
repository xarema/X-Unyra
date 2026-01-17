#!/bin/bash
set -x
cd /Users/alexandre/Apps/couple-app-starter/backend
echo "=== Killing all Django processes ==="
pkill -9 -f "python.*manage" 2>/dev/null || true
sleep 1
echo "=== Starting Django server on 8000 ==="
python3 manage.py runserver 0.0.0.0:8000
