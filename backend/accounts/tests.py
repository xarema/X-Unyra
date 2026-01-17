"""Tests for accounts (auth) app."""

from django.contrib.auth import get_user_model
from rest_framework import status
from rest_framework.test import APITestCase

User = get_user_model()


class RegisterTests(APITestCase):
    """Test user registration endpoint."""

    def test_register_success(self):
        """Test successful user registration."""
        payload = {
            'username': 'alice',
            'email': 'alice@example.com',
            'password': 'SecurePass123!',
            'password_confirm': 'SecurePass123!',
            'first_name': 'Alice',
            'last_name': 'Wonder',
            'language': 'en',
            'timezone': 'UTC',
        }
        response = self.client.post('/api/auth/register/', payload, format='json')

        # Check status
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        # Check response structure
        self.assertIn('user', response.data)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

        # Check user created
        self.assertEqual(response.data['user']['email'], 'alice@example.com')
        self.assertEqual(response.data['user']['first_name'], 'Alice')

        # Check user exists in DB
        user = User.objects.get(email='alice@example.com')
        self.assertEqual(user.username, 'alice')

    def test_register_duplicate_username(self):
        """Test registering with duplicate username."""
        User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='Pass123!'
        )

        payload = {
            'username': 'alice',
            'email': 'alice2@example.com',
            'password': 'SecurePass123!',
            'password_confirm': 'SecurePass123!',
        }
        response = self.client.post('/api/auth/register/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('username', response.data)

    def test_register_duplicate_email(self):
        """Test registering with duplicate email."""
        User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='Pass123!'
        )

        payload = {
            'username': 'bob',
            'email': 'alice@example.com',
            'password': 'SecurePass123!',
            'password_confirm': 'SecurePass123!',
        }
        response = self.client.post('/api/auth/register/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('email', response.data)

    def test_register_password_mismatch(self):
        """Test registering with mismatched passwords."""
        payload = {
            'username': 'alice',
            'email': 'alice@example.com',
            'password': 'SecurePass123!',
            'password_confirm': 'DifferentPass456!',
        }
        response = self.client.post('/api/auth/register/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertIn('password', response.data)

    def test_register_weak_password(self):
        """Test registering with weak password."""
        payload = {
            'username': 'alice',
            'email': 'alice@example.com',
            'password': 'short',
            'password_confirm': 'short',
        }
        response = self.client.post('/api/auth/register/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        # Either "password" field error or custom message
        self.assertTrue('password' in response.data or 'non_field_errors' in response.data)

    def test_register_missing_fields(self):
        """Test registering with missing required fields."""
        payload = {
            'username': 'alice',
            # missing email, password, password_confirm
        }
        response = self.client.post('/api/auth/register/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class LoginTests(APITestCase):
    """Test user login endpoint."""

    def setUp(self):
        """Create test user."""
        self.user = User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='SecurePass123!',
            first_name='Alice',
        )

    def test_login_success(self):
        """Test successful login."""
        payload = {
            'email': 'alice@example.com',
            'password': 'SecurePass123!',
        }
        response = self.client.post('/api/auth/login/', payload, format='json')

        # Debug: print response if error
        if response.status_code != 200:
            print(f"\nDEBUG: Status {response.status_code}, Response: {response.data}")

        # Check status
        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Check response structure
        self.assertIn('user', response.data)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

        # Check user data
        self.assertEqual(response.data['user']['email'], 'alice@example.com')
        self.assertEqual(response.data['user']['first_name'], 'Alice')

    def test_login_invalid_email(self):
        """Test login with non-existent email."""
        payload = {
            'email': 'nonexistent@example.com',
            'password': 'SecurePass123!',
        }
        response = self.client.post('/api/auth/login/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_login_invalid_password(self):
        """Test login with wrong password."""
        payload = {
            'email': 'alice@example.com',
            'password': 'WrongPassword123!',
        }
        response = self.client.post('/api/auth/login/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)

    def test_login_missing_fields(self):
        """Test login with missing fields."""
        payload = {
            'email': 'alice@example.com',
            # missing password
        }
        response = self.client.post('/api/auth/login/', payload, format='json')

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)


class MeTests(APITestCase):
    """Test GET /me endpoint."""

    def setUp(self):
        """Create test user and authenticate."""
        self.user = User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='SecurePass123!',
            language='fr',
            timezone='Europe/Paris',
        )

    def test_me_authenticated(self):
        """Test /me with valid token."""
        # Login to get token
        login_response = self.client.post('/api/auth/login/', {
            'email': 'alice@example.com',
            'password': 'SecurePass123!',
        }, format='json')

        token = login_response.data['access']

        # Call /me with token
        response = self.client.get(
            '/api/auth/me/',
            HTTP_AUTHORIZATION=f'Bearer {token}'
        )

        # Check response
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('user', response.data)
        self.assertEqual(response.data['user']['email'], 'alice@example.com')
        self.assertEqual(response.data['user']['language'], 'fr')

    def test_me_unauthenticated(self):
        """Test /me without token."""
        response = self.client.get('/api/auth/me/')

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)

    def test_me_invalid_token(self):
        """Test /me with invalid token."""
        response = self.client.get(
            '/api/auth/me/',
            HTTP_AUTHORIZATION='Bearer invalid_token'
        )

        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)


class TokenTests(APITestCase):
    """Test JWT token endpoints (provided by SimpleJWT)."""

    def setUp(self):
        """Create test user."""
        self.user = User.objects.create_user(
            username='alice',
            email='alice@example.com',
            password='SecurePass123!',
        )

    def test_token_refresh(self):
        """Test refreshing access token with refresh token."""
        # Register to get tokens
        register_response = self.client.post('/api/auth/register/', {
            'username': 'bob',
            'email': 'bob@example.com',
            'password': 'SecurePass123!',
            'password_confirm': 'SecurePass123!',
        }, format='json')

        refresh_token = register_response.data['refresh']

        # Refresh
        response = self.client.post('/api/auth/refresh/', {
            'refresh': refresh_token,
        }, format='json')

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
