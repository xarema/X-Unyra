from rest_framework import serializers

from .models import CheckIn


class CheckInSerializer(serializers.ModelSerializer):
    class Meta:
        model = CheckIn
        fields = ['id', 'date', 'mood', 'stress', 'energy', 'note', 'created_at', 'updated_at']
