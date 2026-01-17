from datetime import date, timedelta

from django.utils.dateparse import parse_date
from rest_framework import permissions, viewsets

from couples.utils import get_user_couple

from .models import CheckIn
from .serializers import CheckInSerializer


class CheckInViewSet(viewsets.ModelViewSet):
    serializer_class = CheckInSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        couple = get_user_couple(self.request.user)
        if not couple:
            return CheckIn.objects.none()

        qs = CheckIn.objects.filter(couple=couple, user=self.request.user)

        from_s = self.request.query_params.get('from')
        to_s = self.request.query_params.get('to')
        if from_s or to_s:
            from_d = parse_date(from_s) if from_s else None
            to_d = parse_date(to_s) if to_s else None
            if from_d:
                qs = qs.filter(date__gte=from_d)
            if to_d:
                qs = qs.filter(date__lte=to_d)
        else:
            # default: last 7 days
            qs = qs.filter(date__gte=date.today() - timedelta(days=7))

        return qs.order_by('-date')

    def perform_create(self, serializer):
        couple = get_user_couple(self.request.user)
        if not couple:
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'detail': 'No couple found.'})
        serializer.save(couple=couple, user=self.request.user)
