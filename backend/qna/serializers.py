from django.contrib.auth import get_user_model
from rest_framework import serializers

from .models import Question, Answer

User = get_user_model()


class AnswerSerializer(serializers.ModelSerializer):
    """Answer to a question."""

    user_id = serializers.IntegerField(source='user.id', read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)

    class Meta:
        model = Answer
        fields = ['id', 'user_id', 'username', 'status', 'text', 'updated_at']
        read_only_fields = ['id', 'user_id', 'username', 'updated_at']


class QuestionDetailSerializer(serializers.ModelSerializer):
    """Question with full details including answers."""

    created_by_id = serializers.IntegerField(source='created_by.id', read_only=True)
    created_by_username = serializers.CharField(source='created_by.username', read_only=True)
    answers = AnswerSerializer(many=True, read_only=True)

    class Meta:
        model = Question
        fields = ['id', 'theme', 'text', 'created_by_id', 'created_by_username', 'created_at', 'updated_at', 'answers']
        read_only_fields = ['id', 'created_by_id', 'created_by_username', 'created_at', 'updated_at']


class QuestionListSerializer(serializers.ModelSerializer):
    """Question for list view (minimal)."""

    created_by_username = serializers.CharField(source='created_by.username', read_only=True)

    class Meta:
        model = Question
        fields = ['id', 'theme', 'text', 'created_by_username', 'created_at', 'updated_at']
        read_only_fields = ['id', 'created_by_username', 'created_at', 'updated_at']


class CreateQuestionSerializer(serializers.ModelSerializer):
    """Serializer for creating questions."""

    class Meta:
        model = Question
        fields = ['theme', 'text']

    def create(self, validated_data):
        """Set couple and created_by from request."""
        request = self.context.get('request')
        couple = request.user.couples_as_a.first() or request.user.couples_as_b.first()
        if not couple:
            raise serializers.ValidationError("User not in a couple")

        validated_data['couple'] = couple
        validated_data['created_by'] = request.user
        return super().create(validated_data)


class UpdateAnswerSerializer(serializers.ModelSerializer):
    """Serializer for updating answers."""

    class Meta:
        model = Answer
        fields = ['status', 'text']
