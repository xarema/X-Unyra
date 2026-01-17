from typing import Optional

from django.db.models import Q

from .models import Couple


def get_user_couple(user) -> Optional[Couple]:
    """MVP assumption: each user belongs to 0 or 1 active couple."""
    return Couple.objects.filter(Q(partner_a=user) | Q(partner_b=user)).first()
