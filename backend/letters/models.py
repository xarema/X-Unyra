from django.db import models

from couples.models import Couple


class Letter(models.Model):
    couple = models.ForeignKey(Couple, related_name='letters', on_delete=models.CASCADE)
    month = models.CharField(max_length=7)  # YYYY-MM
    content = models.TextField(blank=True, default='')
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True, db_index=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['couple', 'month'], name='uniq_letter_per_month')
        ]
        ordering = ['-month']
