#!/bin/bash
cd /Users/alexandre/Apps/couple-app-starter/backend
source .venv/bin/activate
python3 << 'PYEOF'
import os, sys, django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
sys.path.insert(0, '/Users/alexandre/Apps/couple-app-starter/backend')
django.setup()

from django.contrib.auth import get_user_model
from couples.models import Couple
User = get_user_model()

# Supprimer anciens couples
Couple.objects.all().delete()

# Récupérer users
alice = User.objects.get(email='alice@example.com')
bob = User.objects.get(email='bob@example.com')

# Créer couple
couple = Couple.objects.create(user1=alice, user2=bob, pairing_code='TEST123')

print(f"✅ COUPLE CRÉÉ: {couple.user1.email} + {couple.user2.email}")
print(f"   Code: {couple.pairing_code}")
PYEOF
