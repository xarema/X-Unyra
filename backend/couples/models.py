import secrets
import uuid

from django.conf import settings
from django.db import models
from datetime import timedelta

from django.utils import timezone


class Couple(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    partner_a = models.ForeignKey(settings.AUTH_USER_MODEL, related_name='couples_as_a', on_delete=models.CASCADE)
    partner_b = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        related_name='couples_as_b',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True, db_index=True)

    def __str__(self) -> str:
        return f"Couple({self.partner_a_id},{self.partner_b_id})"


class PairingInvite(models.Model):
    couple = models.ForeignKey(Couple, related_name='invites', on_delete=models.CASCADE)
    code = models.CharField(max_length=12, db_index=True)
    expires_at = models.DateTimeField()
    used_at = models.DateTimeField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)

    @classmethod
    def create_for_couple(cls, couple: Couple, ttl_minutes: int = 60) -> 'PairingInvite':
        code = f"{secrets.randbelow(10**6):06d}"  # 6 digits
        expires_at = timezone.now() + timedelta(minutes=ttl_minutes)
        return cls.objects.create(couple=couple, code=code, expires_at=expires_at)

    @property
    def is_valid(self) -> bool:
        if self.used_at is not None:
            return False
        return timezone.now() < self.expires_at

    def mark_used(self):
        self.used_at = timezone.now()
        self.save(update_fields=['used_at'])
