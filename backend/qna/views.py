from django.shortcuts import get_object_or_404
from rest_framework import permissions, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from couples.utils import get_user_couple

from .models import Question, Answer
from .serializers import QuestionDetailSerializer, QuestionListSerializer, AnswerSerializer


class QuestionViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        couple = get_user_couple(self.request.user)
        if not couple:
            return Question.objects.none()
        return Question.objects.filter(couple=couple).order_by('-updated_at')

    def get_serializer_class(self):
        """Use list serializer for list, detail for retrieve/update."""
        if self.action == 'list':
            return QuestionListSerializer
        return QuestionDetailSerializer

    def perform_create(self, serializer):
        couple = get_user_couple(self.request.user)
        if not couple:
            from rest_framework.exceptions import ValidationError
            raise ValidationError({'detail': 'No couple found.'})
        serializer.save(couple=couple, created_by=self.request.user)

    def update(self, request, *args, **kwargs):
        question = self.get_object()
        if question.created_by_id != request.user.id:
            return Response({'detail': 'Only creator can edit the question.'}, status=status.HTTP_403_FORBIDDEN)
        return super().update(request, *args, **kwargs)

    @action(detail=True, methods=['POST'])
    def answer(self, request, pk=None):
        couple = get_user_couple(request.user)
        if not couple:
            return Response({'detail': 'No couple found.'}, status=status.HTTP_404_NOT_FOUND)

        question = get_object_or_404(Question, pk=pk, couple=couple)
        status_value = request.data.get('status', Answer.STATUS_ANSWERED)
        text_value = request.data.get('text', '')

        answer_obj, created = Answer.objects.get_or_create(question=question, user=request.user)
        answer_obj.status = status_value
        answer_obj.text = text_value
        answer_obj.save()

        return Response({'answer': AnswerSerializer(answer_obj).data})
