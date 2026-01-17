#!/usr/bin/env python3
import os
import sys
import django
import requests

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
sys.path.insert(0, '/Users/alexandre/Apps/couple-app-starter/backend')
django.setup()

from django.contrib.auth import get_user_model
from couples.models import Couple

User = get_user_model()

print("=" * 60)
print("DIAGNOSTIC COMPLET DU COUPLE")
print("=" * 60)

# 1. Vérifier Alice et Bob
try:
    alice = User.objects.get(email='alice@example.com')
    print(f"\n✅ Alice existe: ID={alice.id}, email={alice.email}")
except:
    print("\n❌ Alice N'EXISTE PAS!")
    sys.exit(1)

try:
    bob = User.objects.get(email='bob@example.com')
    print(f"✅ Bob existe: ID={bob.id}, email={bob.email}")
except:
    print("❌ Bob N'EXISTE PAS!")
    sys.exit(1)

# 2. Vérifier les couples
couples = Couple.objects.all()
print(f"\n📊 Couples dans la BD: {couples.count()}")

if couples.count() > 0:
    for c in couples:
        print(f"\n  Couple ID: {c.id}")
        print(f"    partner_a_id: {c.partner_a_id} (Alice={alice.id})")
        print(f"    partner_b_id: {c.partner_b_id} (Bob={bob.id})")
        print(f"    Match: partner_a={c.partner_a_id == alice.id}, partner_b={c.partner_b_id == bob.id}")
else:
    print("\n❌ AUCUN COUPLE DANS LA BD!")

# 3. Tester get_user_couple
from couples.utils import get_user_couple

alice_couple = get_user_couple(alice)
if alice_couple:
    print(f"\n✅ get_user_couple(alice) retourne: {alice_couple.id}")
else:
    print(f"\n❌ get_user_couple(alice) retourne: None")

bob_couple = get_user_couple(bob)
if bob_couple:
    print(f"✅ get_user_couple(bob) retourne: {bob_couple.id}")
else:
    print(f"❌ get_user_couple(bob) retourne: None")

print("\n" + "=" * 60)
