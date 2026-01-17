from django.shortcuts import get_object_or_404
from rest_framework import permissions, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from couples.utils import get_user_couple

from .models import Goal, GoalAction
from .serializers import GoalSerializer, GoalActionSerializer


class GoalViewSet(viewsets.ModelViewSet):
    serializer_class = GoalSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        couple = get_user_couple(self.request.user)
        if not couple:
            return Goal.objects.none()
        return Goal.objects.filter(couple=couple).order_by('-updated_at')

    def perform_create(self, serializer):
        couple = get_user_couple(self.request.user)
        if not couple:
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'detail': 'No couple found.'})
        serializer.save(couple=couple)

    @action(detail=True, methods=['POST'])
    def actions(self, request, pk=None):
        couple = get_user_couple(request.user)
        goal = get_object_or_404(Goal, pk=pk, couple=couple)
        ser = GoalActionSerializer(data=request.data)
        ser.is_valid(raise_exception=True)
        action_obj = GoalAction.objects.create(goal=goal, **ser.validated_data)
        return Response({'action': GoalActionSerializer(action_obj).data}, status=status.HTTP_201_CREATED)


class GoalActionViewSet(viewsets.ModelViewSet):
    serializer_class = GoalActionSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        couple = get_user_couple(self.request.user)
        if not couple:
            return GoalAction.objects.none()
        return GoalAction.objects.filter(goal__couple=couple).order_by('-updated_at')
