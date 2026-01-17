#!/usr/bin/env python3
import os
import sys
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
django.setup()

from django.contrib.auth import get_user_model
User = get_user_model()

# Supprimer les anciens utilisateurs de test
deleted = User.objects.filter(email__in=['alice@example.com', 'bob@example.com']).delete()
print(f'Supprimés: {deleted}')

# Créer alice avec le bon mot de passe
alice = User.objects.create_user(
    username='alice',
    email='alice@example.com',
    password='testpass123',
    first_name='Alice',
    last_name='Test'
)
print(f'Alice créée: {alice.email}')

# Créer bob avec le bon mot de passe
bob = User.objects.create_user(
    username='bob',
    email='bob@example.com',
    password='testpass123',
    first_name='Bob',
    last_name='Test'
)
print(f'Bob créé: {bob.email}')

# Vérifier que les mots de passe fonctionnent
print(f'Alice check_password: {alice.check_password("testpass123")}')
print(f'Bob check_password: {bob.check_password("testpass123")}')
