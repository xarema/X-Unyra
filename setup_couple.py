#!/usr/bin/env python3
import os
import sys
import django

sys.path.insert(0, '/Users/alexandre/Apps/couple-app-starter/backend')
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
django.setup()

from accounts.models import User
from couples.models import Couple

# Create bob
bob, created = User.objects.get_or_create(
    email='bob@example.com',
    defaults={
        'username': 'bob',
        'first_name': 'Bob',
        'last_name': 'Smith',
        'language': 'fr',
        'timezone': 'UTC'
    }
)

if created:
    bob.set_password('TestPass123!')
    bob.save()
    print(f'✓ Created Bob: {bob.email}')
else:
    bob.set_password('TestPass123!')
    bob.save()
    print(f'✓ Bob exists (updated password): {bob.email}')

# Get Alice
alice = User.objects.get(email='alice@example.com')
print(f'✓ Alice: {alice.email}')

# Create couple
couple = Couple.objects.filter(partner_a=alice).first()
if not couple:
    couple = Couple.objects.create(partner_a=alice, partner_b=bob)
    print(f'✓ Couple created: Alice + Bob')
else:
    if couple.partner_b != bob:
        couple.partner_b = bob
        couple.save()
    print(f'✓ Couple updated: Alice + Bob')

print(f'\n✅ COUPLE OPERATIONAL!')
print(f'   Partner A: {couple.partner_a.email}')
print(f'   Partner B: {couple.partner_b.email}')
print(f'\n📝 TEST CREDENTIALS:')
print(f'   Alice - Email: alice@example.com, Password: TestPass123!')
print(f'   Bob   - Email: bob@example.com, Password: TestPass123!')
