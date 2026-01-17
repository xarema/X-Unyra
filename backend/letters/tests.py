"""Tests for letters feature."""

from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.test import APITestCase

from couples.models import Couple
from .models import Letter

User = get_user_model()


class LetterViewSetTests(APITestCase):
    """Test Letters CRUD."""

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

    def test_list_letters(self):
        """Test listing letters for couple."""
        Letter.objects.create(
            couple=self.couple,
            month='2026-01',
            content='This month was amazing!'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/letters/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreaterEqual(len(response.data['results']), 1)

    def test_create_letter(self):
        """Test creating a letter."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/letters/', {
            'month': '2026-01',
            'content': 'This month was wonderful!'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # Response is wrapped in 'letter' key
        self.assertIn('letter', response.data)
        self.assertEqual(response.data['letter']['month'], '2026-01')

    def test_retrieve_letter(self):
        """Test retrieving a letter."""
        letter = Letter.objects.create(
            couple=self.couple,
            month='2026-01',
            content='This month was amazing!'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get(f'/api/letters/{letter.id}/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['content'], 'This month was amazing!')

    def test_update_letter(self):
        """Test updating a letter."""
        letter = Letter.objects.create(
            couple=self.couple,
            month='2026-01',
            content='Beginning of month'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.patch(f'/api/letters/{letter.id}/', {
            'content': 'End of month reflections'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        letter.refresh_from_db()
        self.assertEqual(letter.content, 'End of month reflections')

    def test_delete_letter(self):
        """Test deleting a letter."""
        letter = Letter.objects.create(
            couple=self.couple,
            month='2026-01',
            content='Content'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.delete(f'/api/letters/{letter.id}/')

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Letter.objects.filter(id=letter.id).exists())

    def test_letter_ordering(self):
        """Test letters are ordered by month descending."""
        Letter.objects.create(
            couple=self.couple,
            month='2025-12',
            content='December'
        )
        Letter.objects.create(
            couple=self.couple,
            month='2026-01',
            content='January'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/letters/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Most recent month should be first (2026-01)
        self.assertEqual(response.data['results'][0]['month'], '2026-01')
        self.assertEqual(response.data['results'][1]['month'], '2025-12')
