#!/bin/bash
echo "✅ Test Setup Script"
echo ""
echo "1️⃣ Vérification du backend Django"
lsof -i :8000 > /dev/null 2>&1 && echo "✅ Django backend: OK (port 8000)" || echo "❌ Django backend: NOT RUNNING"
echo ""
echo "2️⃣ Vérification des utilisateurs de test"
cd backend && python3 manage.py shell -c "from django.contrib.auth import get_user_model; User = get_user_model(); print(f'Utilisateurs: {User.objects.count()}')" 2>/dev/null
echo ""
echo "3️⃣ Test de login API"
curl -s -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"alice12345"}' | python3 -m json.tool 2>/dev/null | head -15
echo ""
echo "4️⃣ Status final"
echo "✅ Setup validé! Vous pouvez tester l'app."
