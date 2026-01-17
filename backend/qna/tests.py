"""Tests for Q&A (qna) feature."""

from django.contrib.auth import get_user_model
from django.utils import timezone
from rest_framework import status
from rest_framework.test import APITestCase

from couples.models import Couple
from .models import Question, Answer

User = get_user_model()


class QuestionViewSetTests(APITestCase):
    """Test Q&A Questions CRUD."""

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

    def test_list_questions(self):
        """Test listing questions for couple."""
        Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )
        Question.objects.create(
            couple=self.couple,
            theme='future',
            text='Where do we see ourselves in 5 years?',
            created_by=self.user_b
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/qna/questions/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data['results']), 2)

    def test_create_question(self):
        """Test creating a question."""
        self.client.force_authenticate(self.user_a)
        response = self.client.post('/api/qna/questions/', {
            'theme': 'relationship',
            'text': 'Do you love me?'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(response.data['theme'], 'relationship')
        self.assertEqual(response.data['text'], 'Do you love me?')

        # Verify in DB
        question = Question.objects.get(id=response.data['id'])
        self.assertEqual(question.couple_id, self.couple.id)
        self.assertEqual(question.created_by_id, self.user_a.id)

    def test_create_question_not_in_couple(self):
        """Test creating question when not in couple."""
        user_c = User.objects.create_user(
            username='charlie',
            email='charlie@example.com',
            password='TestPass123!'
        )
        self.client.force_authenticate(user_c)
        response = self.client.post('/api/qna/questions/', {
            'theme': 'relationship',
            'text': 'Do you love me?'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_retrieve_question(self):
        """Test retrieving a question with answers."""
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )
        Answer.objects.create(
            question=question,
            user=self.user_b,
            status=Answer.STATUS_ANSWERED,
            text='Yes, absolutely!'
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get(f'/api/qna/questions/{question.id}/')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['text'], 'Do you love me?')
        self.assertEqual(len(response.data['answers']), 1)
        self.assertEqual(response.data['answers'][0]['text'], 'Yes, absolutely!')

    def test_update_question_creator_only(self):
        """Test updating question (creator only)."""
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.patch(f'/api/qna/questions/{question.id}/', {
            'text': 'Do you love me deeply?'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        question.refresh_from_db()
        self.assertEqual(question.text, 'Do you love me deeply?')

    def test_update_question_non_creator(self):
        """Test non-creator cannot edit question."""
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )

        self.client.force_authenticate(self.user_b)
        response = self.client.patch(f'/api/qna/questions/{question.id}/', {
            'text': 'Do you love me deeply?'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_delete_question(self):
        """Test deleting a question."""
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.delete(f'/api/qna/questions/{question.id}/')

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertFalse(Question.objects.filter(id=question.id).exists())

    def test_answer_question(self):
        """Test answering a question."""
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )

        self.client.force_authenticate(self.user_b)
        response = self.client.post(f'/api/qna/questions/{question.id}/answer/', {
            'status': Answer.STATUS_ANSWERED,
            'text': 'Yes, I love you!'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['answer']['text'], 'Yes, I love you!')

        # Verify in DB
        answer = Answer.objects.get(question=question, user=self.user_b)
        self.assertEqual(answer.text, 'Yes, I love you!')
        self.assertEqual(answer.status, Answer.STATUS_ANSWERED)

    def test_update_answer(self):
        """Test updating existing answer."""
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )
        Answer.objects.create(
            question=question,
            user=self.user_b,
            status=Answer.STATUS_ANSWERED,
            text='Maybe...'
        )

        self.client.force_authenticate(self.user_b)
        response = self.client.post(f'/api/qna/questions/{question.id}/answer/', {
            'status': Answer.STATUS_NEEDS_TIME,
            'text': 'I need time to think'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        answer = Answer.objects.get(question=question, user=self.user_b)
        self.assertEqual(answer.status, Answer.STATUS_NEEDS_TIME)
        self.assertEqual(answer.text, 'I need time to think')

    def test_answer_not_in_couple(self):
        """Test answering question when not in couple."""
        question = Question.objects.create(
            couple=self.couple,
            theme='relationship',
            text='Do you love me?',
            created_by=self.user_a
        )

        user_c = User.objects.create_user(
            username='charlie',
            email='charlie@example.com',
            password='TestPass123!'
        )
        self.client.force_authenticate(user_c)
        response = self.client.post(f'/api/qna/questions/{question.id}/answer/', {
            'status': Answer.STATUS_ANSWERED,
            'text': 'Yes'
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_list_questions_couple_scoped(self):
        """Test questions are couple-scoped."""
        other_couple = Couple.objects.create(
            partner_a=User.objects.create_user(username='charlie', password='test'),
            partner_b=User.objects.create_user(username='diana', password='test')
        )

        Question.objects.create(
            couple=self.couple,
            theme='test',
            text='Q1',
            created_by=self.user_a
        )
        Question.objects.create(
            couple=other_couple,
            theme='test',
            text='Q2',
            created_by=other_couple.partner_a
        )

        self.client.force_authenticate(self.user_a)
        response = self.client.get('/api/qna/questions/')

        # Should only see self.couple's questions
        self.assertEqual(len(response.data['results']), 1)
        self.assertEqual(response.data['results'][0]['text'], 'Q1')
