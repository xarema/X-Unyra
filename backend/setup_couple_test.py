#!/usr/bin/env python3
import os
import sys
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
django.setup()

from django.contrib.auth import get_user_model
from couples.models import Couple

User = get_user_model()

# Supprimer les anciens couples
Couple.objects.all().delete()

# Récupérer ou créer Alice et Bob
alice, created_alice = User.objects.get_or_create(
    email='alice@example.com',
    defaults={
        'username': 'alice',
        'first_name': 'Alice',
        'last_name': 'Test'
    }
)
if created_alice:
    alice.set_password('testpass123')
    alice.save()

bob, created_bob = User.objects.get_or_create(
    email='bob@example.com',
    defaults={
        'username': 'bob',
        'first_name': 'Bob',
        'last_name': 'Test'
    }
)
if created_bob:
    bob.set_password('testpass123')
    bob.save()

# Créer un couple avec Alice et Bob
couple = Couple.objects.create(
    user1=alice,
    user2=bob,
    pairing_code='TEST123'
)

print("✅ SUCCESS!")
print(f"Alice (ID: {alice.id}): {alice.email}")
print(f"Bob (ID: {bob.id}): {bob.email}")
print(f"Couple créé (ID: {couple.id})")
print(f"Pairing Code: {couple.pairing_code}")
print(f"\n✅ Identifiants de test:")
print(f"  Email: alice@example.com / Password: testpass123")
print(f"  Email: bob@example.com / Password: testpass123")
