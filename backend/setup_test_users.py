#!/usr/bin/env python3
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
django.setup()

from django.contrib.auth import get_user_model

User = get_user_model()

# Créer alice
alice, created = User.objects.get_or_create(
    username='alice',
    defaults={'email': 'alice@example.com'}
)
alice.set_password('alice12345')
alice.save()
print(f"✅ alice@example.com / alice12345 {'(créé)' if created else '(mis à jour)'}")

# Créer bob
bob, created = User.objects.get_or_create(
    username='bob',
    defaults={'email': 'bob@example.com'}
)
bob.set_password('bob12345')
bob.save()
print(f"✅ bob@example.com / bob12345 {'(créé)' if created else '(mis à jour)'}")

print("\n📋 Utilisateurs disponibles:")
for user in User.objects.all():
    print(f"  • {user.username} - {user.email}")
