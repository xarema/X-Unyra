from django.contrib.auth.models import AbstractUser
from django.db import models


class User(AbstractUser):
    """Custom user (minimal for MVP)."""

    LANGUAGE_CHOICES = [
        ('fr', 'Français'),
        ('en', 'English'),
        ('ko', '한국어'),
    ]

    language = models.CharField(max_length=8, choices=LANGUAGE_CHOICES, default='fr')
    timezone = models.CharField(max_length=64, default='UTC')

    updated_at = models.DateTimeField(auto_now=True)
