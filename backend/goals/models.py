from django.conf import settings
from django.db import models

from couples.models import Couple


class Goal(models.Model):
    STATUS_ACTIVE = 'ACTIVE'
    STATUS_DONE = 'DONE'
    STATUS_PAUSED = 'PAUSED'

    STATUS_CHOICES = [
        (STATUS_ACTIVE, 'Active'),
        (STATUS_DONE, 'Done'),
        (STATUS_PAUSED, 'Paused'),
    ]

    couple = models.ForeignKey(Couple, related_name='goals', on_delete=models.CASCADE)
    title = models.CharField(max_length=255)
    why_for_us = models.TextField(blank=True, default='')
    owner = models.ForeignKey(settings.AUTH_USER_MODEL, null=True, blank=True, on_delete=models.SET_NULL)
    status = models.CharField(max_length=16, choices=STATUS_CHOICES, default=STATUS_ACTIVE)
    target_date = models.DateField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True, db_index=True)


class GoalAction(models.Model):
    goal = models.ForeignKey(Goal, related_name='actions', on_delete=models.CASCADE)
    text = models.CharField(max_length=255)
    done = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True, db_index=True)
