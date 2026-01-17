"""Tests for check-ins feature."""

from django.contrib.auth import get_user_model
from django.utils import timezone
from datetime import date
from rest_framework import status
from rest_framework.test import APITestCase

from couples.models import Couple
from .models import CheckIn

User = get_user_model()


class CheckInViewSetTests(APITestCase):
    """Test Check-ins CRUD."""

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
        self.couple = Couple.objects.create(partner_a=self.user_a, partner_b=self.user_b)

    def test_list_checkins(self):
        """Test listing check-ins for couple."""
        CheckIn.objects.create(
            couple=self.couple,
            user=self.user_a,
            date=date.today(),
            mood=7,
            stress=4,
            energy=6
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/checkins/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreaterEqual(len(response.data['results']), 1)

    def test_create_checkin(self):
        """Test creating a check-in."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/checkins/', {
            'date': date.today().isoformat(),
            'mood': 7,
            'stress': 4,
            'energy': 6,
            'note': 'Great day!'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['mood'], 7)

    def test_retrieve_checkin(self):
        """Test retrieving a check-in."""
        checkin = CheckIn.objects.create(
            couple=self.couple,
            user=self.user_a,
            date=date.today(),
            mood=7,
            stress=4,
            energy=6,
            note='Good day'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get(f'/api/checkins/{checkin.id}/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['mood'], 7)
        self.assertEqual(response.data['note'], 'Good day')

    def test_update_checkin(self):
        """Test updating a check-in."""
        checkin = CheckIn.objects.create(
            couple=self.couple,
            user=self.user_a,
            date=date.today(),
            mood=5
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.patch(f'/api/checkins/{checkin.id}/', {
            'mood': 8
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        checkin.refresh_from_db()
        self.assertEqual(checkin.mood, 8)

    def test_checkin_ordering(self):
        """Test check-ins are ordered by date descending."""
        from datetime import date, timedelta

        old_date = date.today() - timedelta(days=1)
        CheckIn.objects.create(
            couple=self.couple,
            user=self.user_a,
            date=old_date,
            mood=5
        )
        CheckIn.objects.create(
            couple=self.couple,
            user=self.user_a,
            date=date.today(),
            mood=8
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/checkins/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Most recent should be first
        self.assertEqual(response.data['results'][0]['mood'], 8)
        self.assertEqual(response.data['results'][1]['mood'], 5)
