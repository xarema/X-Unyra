from django.contrib.auth import get_user_model
from rest_framework import serializers

from .models import Couple, PairingInvite

User = get_user_model()


class PublicUserSerializer(serializers.ModelSerializer):
    """User info for public display (minimal fields)."""

    class Meta:
        model = User
        fields = ['id', 'username', 'language', 'timezone']
        read_only_fields = ['id']


class CoupleSerializer(serializers.ModelSerializer):
    """Couple with partner info."""

    partner_a = PublicUserSerializer(read_only=True)
    # For partner_b, we need to handle NULL case properly
    partner_b = serializers.SerializerMethodField()

    class Meta:
        model = Couple
        fields = ['id', 'partner_a', 'partner_b', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_at', 'updated_at']

    def get_partner_b(self, obj):
        """Serialize partner_b if present, otherwise return None."""
        if obj.partner_b is None:
            return None
        return PublicUserSerializer(obj.partner_b).data


class PairingInviteSerializer(serializers.ModelSerializer):
    """Pairing invite with code and expiration."""

    class Meta:
        model = PairingInvite
        fields = ['code', 'expires_at', 'used_at', 'created_at']
        read_only_fields = ['code', 'expires_at', 'used_at', 'created_at']


class JoinCoupleSerializer(serializers.Serializer):
    """Input serializer for joining a couple with code."""

    code = serializers.CharField(max_length=12, required=True)

    def validate_code(self, value: str) -> str:
        """Validate code is 6 digits."""
        value = str(value).strip()
        if not value.isdigit() or len(value) != 6:
            raise serializers.ValidationError("Code must be 6 digits.")
        return value
