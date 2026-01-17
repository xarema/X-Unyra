"""Tests for goals feature."""

from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.test import APITestCase

from couples.models import Couple
from .models import Goal, GoalAction

User = get_user_model()


class GoalViewSetTests(APITestCase):
    """Test Goals CRUD."""

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

    def test_list_goals(self):
        """Test listing goals for couple."""
        Goal.objects.create(
            couple=self.couple,
            title='Buy a house',
            why_for_us='Our dream home',
            status=Goal.STATUS_ACTIVE
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/goals/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertGreaterEqual(len(response.data['results']), 1)

    def test_create_goal(self):
        """Test creating a goal."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/goals/', {
            'title': 'Buy a house',
            'why_for_us': 'Our dream home',
            'status': Goal.STATUS_ACTIVE
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['title'], 'Buy a house')

    def test_retrieve_goal(self):
        """Test retrieving a goal."""
        goal = Goal.objects.create(
            couple=self.couple,
            title='Buy a house',
            why_for_us='Our dream home'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get(f'/api/goals/{goal.id}/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['title'], 'Buy a house')

    def test_update_goal(self):
        """Test updating a goal."""
        goal = Goal.objects.create(
            couple=self.couple,
            title='Buy a house',
            status=Goal.STATUS_ACTIVE
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.patch(f'/api/goals/{goal.id}/', {
            'status': Goal.STATUS_PAUSED
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        goal.refresh_from_db()
        self.assertEqual(goal.status, Goal.STATUS_PAUSED)

    def test_delete_goal(self):
        """Test deleting a goal."""
        goal = Goal.objects.create(
            couple=self.couple,
            title='Buy a house'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.delete(f'/api/goals/{goal.id}/')

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Goal.objects.filter(id=goal.id).exists())
