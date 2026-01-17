#!/bin/bash
cd /Users/alexandre/Apps/couple-app-starter/backend
python3 << 'ENDPYTHON'
import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
django.setup()

from accounts.models import User
from couples.models import Couple

print("Step 1: Getting/Creating Alice...")
alice = User.objects.get(email='alice@example.com')
print(f"  Alice OK: {alice.email}")

print("Step 2: Getting/Creating Bob...")
bob, created = User.objects.get_or_create(
    email='bob@example.com',
    defaults={'username': 'bob', 'first_name': 'Bob', 'last_name': 'Smith'}
)
bob.set_password('TestPass123!')
bob.save()
print(f"  Bob OK: {bob.email} (created={created})")

print("Step 3: Creating couple...")
existing = Couple.objects.filter(partner_a=alice).first()
if existing:
    print(f"  Couple already exists")
    couple = existing
else:
    couple = Couple.objects.create(partner_a=alice, partner_b=bob)
    print(f"  Couple created: {couple.id}")

# Ensure Bob is connected
if couple.partner_b != bob:
    couple.partner_b = bob
    couple.save()
    print(f"  Updated partner_b to Bob")

print(f"\nSUCCESS!")
print(f"  Couple ID: {couple.id}")
print(f"  Partner A: {couple.partner_a.email}")
print(f"  Partner B: {couple.partner_b.email if couple.partner_b else 'None'}")
ENDPYTHON
