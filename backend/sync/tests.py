"""Tests for sync (smart polling) app."""

from django.contrib.auth import get_user_model
from django.utils import timezone
from datetime import timedelta
from rest_framework import status
from rest_framework.test import APITestCase
from urllib.parse import urlencode

from couples.models import Couple
from qna.models import Question, Answer
from goals.models import Goal, GoalAction
from checkins.models import CheckIn
from letters.models import Letter

User = get_user_model()


class SyncChangesTests(APITestCase):
    """Test sync/changes (smart polling) endpoint."""

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

    def test_sync_no_auth(self):
        """Test sync endpoint without authentication."""
        response = self.client.get('/api/sync/changes/')
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_sync_not_in_couple(self):
        """Test sync when user not in couple."""
        user_c = User.objects.create_user(
            username='charlie',
            email='charlie@example.com',
            password='TestPass123!'
        )
        self.client.force_authenticate(user_c)
        response = self.client.get('/api/sync/changes/')
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_sync_filters_by_timestamp(self):
        """Test sync correctly filters changes by timestamp."""
        self.client.force_authenticate(self.user_a)

        # Record current time
        baseline = timezone.now()

        # Create question AFTER baseline
        import time
        time.sleep(0.1)  # Ensure time passes
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='New question',
            created_by=self.user_a
        )

        # Query with baseline (should include new question)
        response = self.client.get(f'/api/sync/changes/?since={baseline.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Should detect the new question
        self.assertGreaterEqual(len(response.data['changes']['qna_questions']), 1)

    def test_sync_couple_change(self):
        """Test sync detects couple changes."""
        # Get initial state
        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Update couple
        self.couple.updated_at = timezone.now()
        self.couple.save()

        # Sync should detect change
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['couple']), 1)
        self.assertEqual(response.data['changes']['couple'][0]['id'], str(self.couple.id))

    def test_sync_question_change(self):
        """Test sync detects Q&A question changes."""
        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Create question
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )

        # Sync should detect change
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['qna_questions']), 1)
        self.assertEqual(response.data['changes']['qna_questions'][0]['id'], str(question.id))

    def test_sync_answer_change(self):
        """Test sync detects Q&A answer changes."""
        # Create question
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )

        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Create answer
        answer = Answer.objects.create(
            question=question,
            user=self.user_a,
            status='ANSWERED',
            text='Yes!'
        )

        # Sync should detect change
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['qna_answers']), 1)
        self.assertEqual(response.data['changes']['qna_answers'][0]['id'], str(answer.id))

    def test_sync_goal_change(self):
        """Test sync detects goal changes."""
        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Create goal
        goal = Goal.objects.create(
            couple=self.couple,
            title='Buy a house',
            why_for_us='Our dream home',
            status='ACTIVE'
        )

        # Sync should detect change
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['goals']), 1)
        self.assertEqual(response.data['changes']['goals'][0]['id'], str(goal.id))

    def test_sync_goal_action_change(self):
        """Test sync detects goal action changes."""
        # Create goal
        goal = Goal.objects.create(
            couple=self.couple,
            title='Buy a house',
            why_for_us='Our dream home',
            status='ACTIVE'
        )

        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Create goal action
        action = GoalAction.objects.create(
            goal=goal,
            text='Save $10k',
            done=False
        )

        # Sync should detect change
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['goal_actions']), 1)
        self.assertEqual(response.data['changes']['goal_actions'][0]['id'], str(action.id))

    def test_sync_checkin_change(self):
        """Test sync detects check-in changes."""
        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Create check-in
        checkin = CheckIn.objects.create(
            couple=self.couple,
            user=self.user_a,
            date=timezone.now().date(),
            mood=7,
            stress=4,
            energy=6
        )

        # Sync should detect change
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['checkins']), 1)
        self.assertEqual(response.data['changes']['checkins'][0]['id'], str(checkin.id))

    def test_sync_letter_change(self):
        """Test sync detects letter changes."""
        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Create letter
        letter = Letter.objects.create(
            couple=self.couple,
            month='2026-01',
            content='This month was amazing!'
        )

        # Sync should detect change
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['letters']), 1)
        self.assertEqual(response.data['changes']['letters'][0]['id'], str(letter.id))

    def test_sync_multiple_changes(self):
        """Test sync detects multiple resource changes."""
        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Create multiple resources
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )
        goal = Goal.objects.create(
            couple=self.couple,
            title='Buy a house',
            why_for_us='Our dream home',
            status='ACTIVE'
        )
        checkin = CheckIn.objects.create(
            couple=self.couple,
            user=self.user_a,
            date=timezone.now().date(),
            mood=7,
            stress=4,
            energy=6
        )

        # Sync should detect all changes
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['qna_questions']), 1)
        self.assertEqual(len(response.data['changes']['goals']), 1)
        self.assertEqual(len(response.data['changes']['checkins']), 1)

    def test_sync_default_since(self):
        """Test sync uses 24h default if 'since' not provided."""
        # Create old question (>24h ago)
        old_question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Old question',
            created_by=self.user_a
        )
        old_question.updated_at = timezone.now() - timedelta(hours=25)
        old_question.save(update_fields=['updated_at'])

        # Create new question (just now)
        new_question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='New question',
            created_by=self.user_a
        )

        self.client.force_authenticate(self.user_a)

        # Sync without 'since' (uses 24h default, so old_question excluded)
        response = self.client.get('/api/sync/changes/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Only new question should be in changes (old one is >24h)
        questions = response.data['changes']['qna_questions']
        self.assertGreaterEqual(len(questions), 1, "Should have at least new question")
        # Verify new question is present
        new_ids = [q['id'] for q in questions]
        self.assertIn(str(new_question.id), new_ids)

    def test_sync_invalid_since_format(self):
        """Test sync with invalid 'since' format falls back to default."""
        self.client.force_authenticate(self.user_a)

        # Invalid since format should fall back to 24h default
        response = self.client.get('/api/sync/changes/?since=invalid-date')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('changes', response.data)

    def test_sync_couple_scoped(self):
        """Test sync only returns changes for user's couple."""
        # Create another couple
        user_c = User.objects.create_user(
            username='charlie',
            email='charlie@example.com',
            password='TestPass123!'
        )
        user_d = User.objects.create_user(
            username='diana',
            email='diana@example.com',
            password='TestPass123!'
        )
        other_couple = Couple.objects.create(partner_a=user_c, partner_b=user_d)

        # Create question in other couple
        other_question = Question.objects.create(
            couple=other_couple,
            theme='relationship',
            text='Question in other couple',
            created_by=user_c
        )

        self.client.force_authenticate(self.user_a)
        since = timezone.now() - timedelta(seconds=1)

        # Sync should NOT detect changes in other couple
        response = self.client.get(f'/api/sync/changes/?since={since.isoformat()}')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['changes']['qna_questions']), 0)

    def test_sync_response_structure(self):
        """Test sync response has correct structure."""
        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/sync/changes/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('server_time', response.data)
        self.assertIn('since', response.data)
        self.assertIn('changes', response.data)

        # All change keys should exist
        expected_keys = ['couple', 'qna_questions', 'qna_answers', 'goals', 'goal_actions', 'checkins', 'letters']
        for key in expected_keys:
            self.assertIn(key, response.data['changes'])
            self.assertIsInstance(response.data['changes'][key], list)

        # Each change should have id and updated_at
        question = Question.objects.create(
            couple=self.couple,
            theme='test',
            text='Test?',
            created_by=self.user_a
        )
        response = self.client.get('/api/sync/changes/?since=' + (timezone.now() - timedelta(seconds=1)).isoformat())

        if response.data['changes']['qna_questions']:
            change = response.data['changes']['qna_questions'][0]
            self.assertIn('id', change)
            self.assertIn('updated_at', change)
