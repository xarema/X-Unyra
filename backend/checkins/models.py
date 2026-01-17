from django.conf import settings
from django.db import models

from couples.models import Couple


class CheckIn(models.Model):
    couple = models.ForeignKey(Couple, related_name='checkins', on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='checkins', on_delete=models.CASCADE)
    date = models.DateField()
    mood = models.IntegerField(default=5)
    stress = models.IntegerField(default=5)
    energy = models.IntegerField(default=5)
    note = models.TextField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True, db_index=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['couple', 'user', 'date'], name='uniq_checkin_per_day')
        ]
        ordering = ['-date']
