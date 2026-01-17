"""Tests for couples (pairing) app."""

from django.contrib.auth import get_user_model
from django.utils import timezone
from datetime import timedelta
from rest_framework import status
from rest_framework.test import APITestCase

from .models import Couple, PairingInvite

User = get_user_model()


class CoupleCreateTests(APITestCase):
    """Test couple creation endpoint."""

    def setUp(self):
        """Create test users."""
        self.user_a = User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='TestPass123!'
        )
        self.user_b = User.objects.create_user(
            username='bob',
            email='bob@example.com',
            password='TestPass123!'
        )

    def test_create_couple_success(self):
        """Test successful couple creation."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/couple/create/')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIn('couple', response.data)
        self.assertEqual(response.data['couple']['partner_a']['id'], self.user_a.id)
        self.assertIsNone(response.data['couple']['partner_b'])

    def test_create_couple_already_paired(self):
        """Test creating couple when user already in couple."""
        Couple.objects.create(partner_a=self.user_a)

        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/couple/create/')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_create_couple_unauthenticated(self):
        """Test creating couple without authentication."""
        response = self.client.post('/api/couple/create/')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class CoupleGetTests(APITestCase):
    """Test couple retrieval endpoint."""

    def setUp(self):
        """Create test users and couple."""
        self.user_a = User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='TestPass123!'
        )
        self.user_b = User.objects.create_user(
            username='bob',
            email='bob@example.com',
            password='TestPass123!'
        )
        self.couple = Couple.objects.create(partner_a=self.user_a)

    def test_get_couple_success(self):
        """Test retrieving couple successfully."""
        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/couple/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('couple', response.data)
        self.assertEqual(response.data['couple']['id'], str(self.couple.id))

    def test_get_couple_not_found(self):
        """Test retrieving couple when user not in couple."""
        self.client.force_authenticate(self.user_b)
        response = self.client.get('/api/couple/')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_get_couple_unauthenticated(self):
        """Test retrieving couple without authentication."""
        response = self.client.get('/api/couple/')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class CoupleInviteTests(APITestCase):
    """Test couple invitation code generation."""

    def setUp(self):
        """Create test users and couple."""
        self.user_a = User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='TestPass123!'
        )
        self.user_b = User.objects.create_user(
            username='bob',
            email='bob@example.com',
            password='TestPass123!'
        )
        self.couple = Couple.objects.create(partner_a=self.user_a)

    def test_invite_success(self):
        """Test successful invite code generation."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/couple/invite/', {'ttl_minutes': 60})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('invite', response.data)
        self.assertEqual(len(response.data['invite']['code']), 6)
        self.assertTrue(response.data['invite']['code'].isdigit())

    def test_invite_with_custom_ttl(self):
        """Test invite with custom TTL."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/couple/invite/', {'ttl_minutes': 120})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        invite = PairingInvite.objects.latest('created_at')
        self.assertIsNotNone(invite.expires_at)

    def test_invite_ttl_too_short(self):
        """Test invite with TTL too short."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/couple/invite/', {'ttl_minutes': 0})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_invite_ttl_too_long(self):
        """Test invite with TTL too long (>7 days)."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/couple/invite/', {'ttl_minutes': 10081})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_invite_not_in_couple(self):
        """Test inviting when not in couple."""
        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/invite/')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_invite_not_partner_a(self):
        """Test inviting when not partner A."""
        self.couple.partner_b = self.user_b
        self.couple.save()

        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/invite/')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_invite_unauthenticated(self):
        """Test inviting without authentication."""
        response = self.client.post('/api/couple/invite/')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class CoupleJoinTests(APITestCase):
    """Test couple join (pairing) endpoint."""

    def setUp(self):
        """Create test users and couple with invite."""
        self.user_a = User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='TestPass123!'
        )
        self.user_b = User.objects.create_user(
            username='bob',
            email='bob@example.com',
            password='TestPass123!'
        )
        self.user_c = User.objects.create_user(
            username='charlie',
            email='charlie@example.com',
            password='TestPass123!'
        )
        self.couple = Couple.objects.create(partner_a=self.user_a)
        self.invite = PairingInvite.create_for_couple(self.couple, ttl_minutes=60)

    def test_join_success(self):
        """Test successful couple join."""
        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/join/', {'code': self.invite.code})

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('couple', response.data)

        # Verify couple was updated
        self.couple.refresh_from_db()
        self.assertEqual(self.couple.partner_b_id, self.user_b.id)

        # Verify invite was marked used
        self.invite.refresh_from_db()
        self.assertIsNotNone(self.invite.used_at)

    def test_join_invalid_code(self):
        """Test joining with invalid code."""
        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/join/', {'code': '000000'})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_join_expired_code(self):
        """Test joining with expired code."""
        # Create expired invite
        expired_invite = PairingInvite.objects.create(
            couple=self.couple,
            code='999999',
            expires_at=timezone.now() - timedelta(minutes=1)
        )

        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/join/', {'code': expired_invite.code})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_join_already_used_code(self):
        """Test joining with already-used code."""
        # Use the invite
        self.invite.mark_used()

        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/join/', {'code': self.invite.code})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_join_already_paired(self):
        """Test joining when user already in couple."""
        other_couple = Couple.objects.create(partner_a=self.user_c)

        self.client.force_authenticate(self.user_c)
        response = self.client.post('/api/couple/join/', {'code': self.invite.code})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_join_couple_already_has_partner_b(self):
        """Test joining couple that already has partner B."""
        # Complete the pairing
        self.couple.partner_b = self.user_b
        self.couple.save()

        self.client.force_authenticate(self.user_c)
        response = self.client.post('/api/couple/join/', {'code': self.invite.code})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_join_invalid_code_format(self):
        """Test joining with invalid code format."""
        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/join/', {'code': 'invalid'})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_join_missing_code(self):
        """Test joining without code."""
        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/join/', {})

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_join_unauthenticated(self):
        """Test joining without authentication."""
        response = self.client.post('/api/couple/join/', {'code': self.invite.code})
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class PairingIntegrationTests(APITestCase):
    """Integration tests for full pairing flow."""

    def setUp(self):
        """Create test users."""
        self.user_a = User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='TestPass123!'
        )
        self.user_b = User.objects.create_user(
            username='bob',
            email='bob@example.com',
            password='TestPass123!'
        )

    def test_full_pairing_flow(self):
        """Test complete pairing flow from A to B."""
        # 1. User A creates couple
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/couple/create/')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        couple_id = response.data['couple']['id']

        # 2. User A generates invite
        response = self.client.post('/api/couple/invite/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        code = response.data['invite']['code']

        # 3. User B joins with code
        self.client.force_authenticate(self.user_b)
        response = self.client.post('/api/couple/join/', {'code': code})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['couple']['id'], couple_id)
        self.assertEqual(response.data['couple']['partner_a']['id'], self.user_a.id)
        self.assertEqual(response.data['couple']['partner_b']['id'], self.user_b.id)

        # 4. Both can retrieve couple
        response = self.client.get('/api/couple/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['couple']['id'], couple_id)

        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/couple/')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['couple']['id'], couple_id)
