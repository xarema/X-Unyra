from rest_framework import permissions, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from couples.utils import get_user_couple

from .models import Letter
from .serializers import LetterSerializer


class LetterViewSet(viewsets.ModelViewSet):
    serializer_class = LetterSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        couple = get_user_couple(self.request.user)
        if not couple:
            return Letter.objects.none()
        qs = Letter.objects.filter(couple=couple)
        month = self.request.query_params.get('month')
        if month:
            qs = qs.filter(month=month)
        return qs

    def create(self, request, *args, **kwargs):
        couple = get_user_couple(request.user)
        if not couple:
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'detail': 'No couple found.'})

        ser = self.get_serializer(data=request.data)
        ser.is_valid(raise_exception=True)
        month = ser.validated_data['month']
        content = ser.validated_data.get('content', '')

        obj, created = Letter.objects.get_or_create(couple=couple, month=month)
        obj.content = content
        obj.save()

        out = self.get_serializer(obj)
        return Response({'letter': out.data}, status=status.HTTP_201_CREATED if created else status.HTTP_200_OK)

    @action(detail=True, methods=['GET'])
    def pdf(self, request, pk=None):
        # Placeholder for future PDF export (backend generation recommended)
        return Response({'detail': 'PDF export not implemented yet.'}, status=status.HTTP_501_NOT_IMPLEMENTED)
