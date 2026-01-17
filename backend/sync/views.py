from datetime import timedelta

from django.utils import timezone
from django.utils.dateparse import parse_datetime
from rest_framework import permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from couples.utils import get_user_couple
from couples.models import Couple, PairingInvite
from qna.models import Question, Answer
from goals.models import Goal, GoalAction
from checkins.models import CheckIn
from letters.models import Letter


def _since_param(request):
    """Parse 'since' query parameter (ISO8601 datetime)."""
    since_s = request.query_params.get('since')
    if not since_s:
        # Default to last 24 hours if not provided
        return timezone.now() - timedelta(hours=24)

    dt = parse_datetime(since_s)
    if dt is None:
        return timezone.now() - timedelta(hours=24)

    if timezone.is_naive(dt):
        dt = timezone.make_aware(dt, timezone=timezone.get_current_timezone())

    return dt


def _pack_changes(queryset):
    """Convert queryset to list of {id, updated_at} dicts."""
    return [
        {'id': str(o['id']), 'updated_at': o['updated_at'].isoformat()}
        for o in queryset
    ]


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def changes(request):
    """
    Get changes since a given timestamp (smart polling endpoint).

    GET /api/sync/changes?since=2026-01-16T13:30:00Z

    Query params:
        since (optional): ISO8601 datetime. Defaults to 24h ago.

    Returns:
        {
            "server_time": "2026-01-16T14:30:00Z",
            "since": "2026-01-16T13:30:00Z",
            "changes": {
                "couple": [{"id": "uuid", "updated_at": "..."}],
                "qna_questions": [...],
                "qna_answers": [...],
                "goals": [...],
                "goal_actions": [...],
                "checkins": [...],
                "letters": [...]
            }
        }

    Returns 404 if user is not in a couple.
    """
    couple = get_user_couple(request.user)
    if not couple:
        return Response(
            {'detail': 'No couple found.'},
            status=status.HTTP_404_NOT_FOUND
        )

    since = _since_param(request)
    server_time = timezone.now()

    # Fetch changes for each resource type (couple-scoped)
    couple_changes = Couple.objects.filter(
        id=couple.id,
        updated_at__gt=since
    ).values('id', 'updated_at')

    qna_questions_changes = Question.objects.filter(
        couple=couple,
        updated_at__gt=since
    ).values('id', 'updated_at')

    qna_answers_changes = Answer.objects.filter(
        question__couple=couple,
        updated_at__gt=since
    ).values('id', 'updated_at')

    goals_changes = Goal.objects.filter(
        couple=couple,
        updated_at__gt=since
    ).values('id', 'updated_at')

    goal_actions_changes = GoalAction.objects.filter(
        goal__couple=couple,
        updated_at__gt=since
    ).values('id', 'updated_at')

    # Check-ins: user can only see their own + partner's
    checkins_changes = CheckIn.objects.filter(
        couple=couple,
        updated_at__gt=since
    ).values('id', 'updated_at')

    letters_changes = Letter.objects.filter(
        couple=couple,
        updated_at__gt=since
    ).values('id', 'updated_at')

    data = {
        'server_time': server_time.isoformat(),
        'since': since.isoformat(),
        'changes': {
            'couple': _pack_changes(couple_changes),
            'qna_questions': _pack_changes(qna_questions_changes),
            'qna_answers': _pack_changes(qna_answers_changes),
            'goals': _pack_changes(goals_changes),
            'goal_actions': _pack_changes(goal_actions_changes),
            'checkins': _pack_changes(checkins_changes),
            'letters': _pack_changes(letters_changes),
        },
    }

    return Response(data, status=status.HTTP_200_OK)
