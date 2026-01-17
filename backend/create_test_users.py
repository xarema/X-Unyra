import os
import django
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'couple_backend.settings')
django.setup()

from django.contrib.auth import get_user_model
User = get_user_model()

# Delete old users
User.objects.filter(email__in=['alice@example.com', 'bob@example.com']).delete()

# Create alice
alice = User.objects.create_user(
    username='alice',
    email='alice@example.com',
    password='testpass123',
    first_name='Alice'
)

# Create bob
bob = User.objects.create_user(
    username='bob',
    email='bob@example.com',
    password='testpass123',
    first_name='Bob'
)

print("✅ Users created:")
print(f"Alice: {alice.email}")
print(f"Bob: {bob.email}")

# Verify login will work
print(f"\n✅ Password verification:")
print(f"Alice password OK: {alice.check_password('testpass123')}")
print(f"Bob password OK: {bob.check_password('testpass123')}")

# Count
all_users = User.objects.all()
print(f"\n✅ Total users in DB: {all_users.count()}")
