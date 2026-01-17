#!/usr/bin/env python3
import os
import sys
import django

# Setup Django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
sys.path.insert(0, '/Users/alexandre/Apps/couple-app-starter/backend')
django.setup()

from django.contrib.auth import get_user_model
from couples.models import Couple

User = get_user_model()

print("=" * 50)
print("CRÉATION DU COUPLE DE TEST")
print("=" * 50)

# Supprimer tous les couples existants
deleted_couples = Couple.objects.all().delete()
print(f"\n1. Couples supprimés: {deleted_couples[0]}")

# Récupérer Alice
try:
    alice = User.objects.get(email='alice@example.com')
    print(f"\n2. Alice trouvée: {alice.email} (ID: {alice.id})")
except User.DoesNotExist:
    print("\n❌ ERREUR: Alice n'existe pas!")
    print("   Créez Alice d'abord avec:")
    print("   python create_test_users.py")
    sys.exit(1)

# Récupérer Bob
try:
    bob = User.objects.get(email='bob@example.com')
    print(f"3. Bob trouvé: {bob.email} (ID: {bob.id})")
except User.DoesNotExist:
    print("\n❌ ERREUR: Bob n'existe pas!")
    print("   Créez Bob d'abord avec:")
    print("   python create_test_users.py")
    sys.exit(1)

# Créer le couple
couple = Couple.objects.create(
    user1=alice,
    user2=bob,
    pairing_code='TEST123'
)

print(f"\n4. ✅ COUPLE CRÉÉ!")
print(f"   - ID: {couple.id}")
print(f"   - User1: {couple.user1.email}")
print(f"   - User2: {couple.user2.email}")
print(f"   - Code: {couple.pairing_code}")
print(f"   - Créé le: {couple.created_at}")

print("\n" + "=" * 50)
print("✅ SUCCÈS! Alice et Bob sont maintenant en couple!")
print("=" * 50)
