#!/bin/bash

echo "=================================================="
echo "🧪 TEST COMPLET DE L'API COUPLE APP"
echo "=================================================="

BACKEND="http://localhost:8000"

# Test 1: API racine
echo ""
echo "1️⃣ TEST: API Racine GET /"
curl -s $BACKEND | python3 -m json.tool | head -20
echo ""

# Test 2: Login Alice
echo "2️⃣ TEST: Login Alice"
LOGIN=$(curl -s -X POST $BACKEND/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"testpass123"}')

echo "$LOGIN" | python3 -m json.tool | head -30
ALICE_TOKEN=$(echo "$LOGIN" | python3 -c "import sys,json; print(json.load(sys.stdin)['access'])" 2>/dev/null)
echo "Token Alice: ${ALICE_TOKEN:0:20}..."
echo ""

# Test 3: Vérifier le couple
echo "3️⃣ TEST: Get Couple pour Alice"
curl -s -X GET $BACKEND/api/couple/ \
  -H "Authorization: Bearer $ALICE_TOKEN" \
  -H "Content-Type: application/json" | python3 -m json.tool
echo ""

# Test 4: Login Bob
echo "4️⃣ TEST: Login Bob"
LOGIN_BOB=$(curl -s -X POST $BACKEND/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"bob@example.com","password":"testpass123"}')

BOB_TOKEN=$(echo "$LOGIN_BOB" | python3 -c "import sys,json; print(json.load(sys.stdin)['access'])" 2>/dev/null)
echo "Token Bob: ${BOB_TOKEN:0:20}..."
echo ""

# Test 5: Vérifier le couple pour Bob
echo "5️⃣ TEST: Get Couple pour Bob"
curl -s -X GET $BACKEND/api/couple/ \
  -H "Authorization: Bearer $BOB_TOKEN" \
  -H "Content-Type: application/json" | python3 -m json.tool
echo ""

echo "=================================================="
echo "✅ TESTS TERMINÉS"
echo "=================================================="
