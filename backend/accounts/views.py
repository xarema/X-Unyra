from django.contrib.auth import get_user_model
from rest_framework import permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken

from .serializers import RegisterSerializer, UserSerializer, LoginSerializer

User = get_user_model()


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def register(request):
    """
    Register a new user.

    POST /api/auth/register/
    {
        "username": "alice",
        "email": "alice@example.com",
        "password": "SecurePass123!",
        "password_confirm": "SecurePass123!",
        "first_name": "Alice",
        "last_name": "Wonder",
        "language": "en",
        "timezone": "Europe/Paris"
    }

    Response: 201 Created
    {
        "user": {...},
        "access": "eyJ...",
        "refresh": "eyJ..."
    }
    """
    serializer = RegisterSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    user = serializer.save()

    refresh = RefreshToken.for_user(user)
    return Response({
        'user': UserSerializer(user).data,
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }, status=status.HTTP_201_CREATED)


@api_view(['POST'])
@permission_classes([permissions.AllowAny])
def login(request):
    """
    Login with email + password.

    POST /api/auth/login/
    {
        "email": "alice@example.com",
        "password": "SecurePass123!"
    }

    Response: 200 OK
    {
        "user": {...},
        "access": "eyJ...",
        "refresh": "eyJ..."
    }
    """
    serializer = LoginSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    user = serializer.validated_data['user']

    refresh = RefreshToken.for_user(user)
    return Response({
        'user': UserSerializer(user).data,
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }, status=status.HTTP_200_OK)


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def me(request):
    """
    Get current user info.

    GET /api/auth/me/
    Header: Authorization: Bearer <access_token>

    Response: 200 OK
    {
        "user": {...}
    }
    """
    return Response({
        'user': UserSerializer(request.user).data
    }, status=status.HTTP_200_OK)
