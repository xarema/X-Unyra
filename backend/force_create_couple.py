#!/usr/bin/env python3
import os
import sys
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
sys.path.insert(0, '/Users/alexandre/Apps/couple-app-starter/backend')
django.setup()

from django.contrib.auth import get_user_model
from couples.models import Couple

User = get_user_model()

print("CRÉATION DU COUPLE...")

# Supprimer les anciens
Couple.objects.all().delete()
print("✓ Anciens couples supprimés")

# Récupérer Alice
alice = User.objects.get(email='alice@example.com')
print(f"✓ Alice trouvée: ID={alice.id}")

# Récupérer Bob
bob = User.objects.get(email='bob@example.com')
print(f"✓ Bob trouvé: ID={bob.id}")

# Créer le couple
couple = Couple.objects.create(partner_a=alice, partner_b=bob)
print(f"✓ COUPLE CRÉÉ: ID={couple.id}")

# Vérifier
from couples.utils import get_user_couple
alice_couple = get_user_couple(alice)
bob_couple = get_user_couple(bob)

print(f"\nVÉRIFICATION:")
print(f"  get_user_couple(alice): {alice_couple is not None}")
print(f"  get_user_couple(bob): {bob_couple is not None}")

if alice_couple and bob_couple and alice_couple.id == bob_couple.id:
    print(f"\n✅✅✅ SUCCÈS! Alice et Bob sont en couple!")
    print(f"    Couple ID: {couple.id}")
else:
    print(f"\n❌ ERREUR! Le couple n'est pas trouvé!")
