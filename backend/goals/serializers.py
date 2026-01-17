from rest_framework import serializers

from .models import Goal, GoalAction


class GoalActionSerializer(serializers.ModelSerializer):
    class Meta:
        model = GoalAction
        fields = ['id', 'text', 'done', 'created_at', 'updated_at']


class GoalSerializer(serializers.ModelSerializer):
    actions = GoalActionSerializer(many=True, read_only=True)

    class Meta:
        model = Goal
        fields = ['id', 'title', 'why_for_us', 'owner', 'status', 'target_date', 'created_at', 'updated_at', 'actions']
