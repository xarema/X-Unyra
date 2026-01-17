from django.conf import settings
from django.db import models

from couples.models import Couple


class Question(models.Model):
    couple = models.ForeignKey(Couple, related_name='questions', on_delete=models.CASCADE)
    theme = models.CharField(max_length=64, blank=True, default='')
    text = models.TextField()
    created_by = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='created_questions', on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True, db_index=True)

    def __str__(self):
        return f"Q({self.id})"


class Answer(models.Model):
    STATUS_ANSWERED = 'ANSWERED'
    STATUS_NEEDS_TIME = 'NEEDS_TIME'
    STATUS_CLARIFY = 'CLARIFY'

    STATUS_CHOICES = [
        (STATUS_ANSWERED, 'Answered'),
        (STATUS_NEEDS_TIME, 'Needs time'),
        (STATUS_CLARIFY, 'Clarify'),
    ]

    question = models.ForeignKey(Question, related_name='answers', on_delete=models.CASCADE)
    user = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='answers', on_delete=models.CASCADE)
    status = models.CharField(max_length=16, choices=STATUS_CHOICES, default=STATUS_ANSWERED)
    text = models.TextField(blank=True, default='')
    updated_at = models.DateTimeField(auto_now=True, db_index=True)

    class Meta:
        constraints = [
            models.UniqueConstraint(fields=['question', 'user'], name='uniq_answer_per_user_per_question')
        ]

    def __str__(self):
        return f"A({self.question_id},{self.user_id})"
