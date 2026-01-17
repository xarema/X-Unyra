from django.contrib.auth import get_user_model
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from rest_framework import serializers

User = get_user_model()


class UserSerializer(serializers.ModelSerializer):
    """Read-only user info (for GET /me, responses)."""

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name', 'language', 'timezone']
        read_only_fields = ['id']


class RegisterSerializer(serializers.ModelSerializer):
    """User registration (POST /auth/register/)."""

    password = serializers.CharField(write_only=True, min_length=4)
    password_confirm = serializers.CharField(write_only=True, min_length=4, required=False)
    email = serializers.EmailField(required=False, allow_blank=True, allow_null=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'password', 'password_confirm', 'first_name', 'last_name', 'language', 'timezone']

    def validate_username(self, value: str) -> str:
        """Check if username is already taken."""
        if User.objects.filter(username=value).exists():
            raise serializers.ValidationError("Username already taken.")
        return value

    def validate_email(self, value: str) -> str:
        """Check if email is already taken."""
        if value and User.objects.filter(email=value).exists():
            raise serializers.ValidationError("Email already registered.")
        return value

    def validate_password(self, value: str) -> str:
        """Validate password strength."""
        try:
            validate_password(value)
        except ValidationError as e:
            raise serializers.ValidationError(e.messages)
        return value

    def validate(self, attrs: dict) -> dict:
        """Check passwords match (if password_confirm is provided)."""
        password = attrs.get('password')
        password_confirm = attrs.pop('password_confirm', None)

        if password_confirm is not None and password != password_confirm:
            raise serializers.ValidationError({"password": "Passwords do not match."})

        return attrs

    def create(self, validated_data):
        """Create user with hashed password."""
        # Ensure optional fields are not None
        email = validated_data.get('email') or ''
        first_name = validated_data.get('first_name') or ''
        last_name = validated_data.get('last_name') or ''
        language = validated_data.get('language') or 'fr'
        timezone = validated_data.get('timezone') or 'UTC'

        user = User(
            username=validated_data['username'],
            email=email,
            first_name=first_name,
            last_name=last_name,
            language=language,
            timezone=timezone,
        )
        user.set_password(validated_data['password'])
        user.save()
        return user


class LoginSerializer(serializers.Serializer):
    """User login input validation (POST /auth/login/)."""

    username = serializers.CharField(required=False)
    email = serializers.CharField(required=False)
    password = serializers.CharField(write_only=True)

    def validate(self, attrs: dict) -> dict:
        """Authenticate user by email or username + password."""

        username = attrs.get('username')
        email = attrs.get('email')
        password = attrs.get('password')

        if not username and not email:
            raise serializers.ValidationError("Email or username is required.")

        try:
            if email:
                # Try finding by email first
                user = User.objects.filter(email=email).first()
                if not user:
                    # If not found by email, try finding by username
                    user = User.objects.filter(username=email).first()
            elif username:
                user = User.objects.filter(username=username).first()
            else:
                user = None

            if not user:
                raise User.DoesNotExist
        except User.DoesNotExist:
            raise serializers.ValidationError("Invalid email or password.")

        if not password or not user.check_password(password):
            raise serializers.ValidationError("Invalid email or password.")

        attrs['user'] = user
        return attrs


class LoginResponseSerializer(serializers.Serializer):
    """Response to login (contains tokens + user info)."""

    user = UserSerializer(read_only=True)
    access = serializers.CharField()
    refresh = serializers.CharField()


