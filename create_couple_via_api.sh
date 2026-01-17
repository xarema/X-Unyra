#!/bin/bash
set -e

echo "=== CRÉATION DU COUPLE ALICE + BOB ==="

# 1. Login Alice
echo "1. Login Alice..."
ALICE_RESPONSE=$(curl -s -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"testpass123"}')

ALICE_TOKEN=$(echo $ALICE_RESPONSE | python3 -c "import sys,json; print(json.load(sys.stdin).get('access',''))")

if [ -z "$ALICE_TOKEN" ]; then
  echo "❌ Erreur: Login Alice échoué"
  exit 1
fi

echo "   ✅ Alice token: ${ALICE_TOKEN:0:20}..."

# 2. Login Bob
echo "2. Login Bob..."
BOB_RESPONSE=$(curl -s -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"bob@example.com","password":"testpass123"}')

BOB_TOKEN=$(echo $BOB_RESPONSE | python3 -c "import sys,json; print(json.load(sys.stdin).get('access',''))")

if [ -z "$BOB_TOKEN" ]; then
  echo "❌ Erreur: Login Bob échoué"
  exit 1
fi

echo "   ✅ Bob token: ${BOB_TOKEN:0:20}..."

# 3. Alice crée un couple
echo "3. Alice crée un couple..."
CREATE_RESPONSE=$(curl -s -X POST http://localhost:8000/api/couple/create/ \
  -H "Authorization: Bearer $ALICE_TOKEN" \
  -H "Content-Type: application/json")

echo "   Réponse: $CREATE_RESPONSE"

INVITE_CODE=$(echo $CREATE_RESPONSE | python3 -c "import sys,json; data=json.load(sys.stdin); print(data.get('invite_code', data.get('pairing_code', '')))")

if [ -z "$INVITE_CODE" ]; then
  echo "   ⚠️  Pas de code d'invitation dans la réponse"
  # Essayer de générer un code
  echo "   Génération d'un code d'invitation..."
  INVITE_RESPONSE=$(curl -s -X POST http://localhost:8000/api/couple/invite/ \
    -H "Authorization: Bearer $ALICE_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{"ttl_minutes": 60}')

  echo "   Réponse invite: $INVITE_RESPONSE"
  INVITE_CODE=$(echo $INVITE_RESPONSE | python3 -c "import sys,json; print(json.load(sys.stdin).get('code',''))")
fi

if [ -z "$INVITE_CODE" ]; then
  echo "   ❌ Impossible d'obtenir un code d'invitation"
  exit 1
fi

echo "   ✅ Code d'invitation: $INVITE_CODE"

# 4. Bob rejoint le couple avec le code
echo "4. Bob rejoint le couple..."
JOIN_RESPONSE=$(curl -s -X POST http://localhost:8000/api/couple/join/ \
  -H "Authorization: Bearer $BOB_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"code\": \"$INVITE_CODE\"}")

echo "   Réponse: $JOIN_RESPONSE"

# 5. Vérifier le couple d'Alice
echo "5. Vérification du couple d'Alice..."
COUPLE_RESPONSE=$(curl -s -X GET http://localhost:8000/api/couple/ \
  -H "Authorization: Bearer $ALICE_TOKEN")

echo "   Couple d'Alice: $COUPLE_RESPONSE"

echo ""
echo "=== ✅ TERMINÉ ==="
