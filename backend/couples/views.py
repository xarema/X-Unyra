from django.utils import timezone
from rest_framework import permissions, status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.response import Response

from .models import Couple, PairingInvite
from .serializers import CoupleSerializer, PairingInviteSerializer, JoinCoupleSerializer
from .utils import get_user_couple


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def couple_create(request):
    """
    Create a new couple with current user as partner_a.

    POST /api/couple/create/

    Returns 201 Created if successful
    Returns 400 if user already in a couple
    """
    if get_user_couple(request.user):
        return Response(
            {'detail': 'User already in a couple.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    couple = Couple.objects.create(partner_a=request.user)
    return Response(
        {'couple': CoupleSerializer(couple).data},
        status=status.HTTP_201_CREATED
    )


@api_view(['GET'])
@permission_classes([permissions.IsAuthenticated])
def couple_get(request):
    """
    Get current user's couple.

    GET /api/couple/

    Returns 200 with couple data if user is in a couple
    Returns 404 if user is not in a couple
    """
    couple = get_user_couple(request.user)
    if not couple:
        return Response(
            {'detail': 'No couple found.'},
            status=status.HTTP_404_NOT_FOUND
        )
    return Response({'couple': CoupleSerializer(couple).data})


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def couple_invite(request):
    """
    Generate a pairing invitation code for the couple.

    POST /api/couple/invite/
    {
        "ttl_minutes": 60  (optional, default 60)
    }

    Returns 200 with invite code
    Returns 403 if user is not partner_a
    Returns 404 if user is not in a couple
    """
    couple = get_user_couple(request.user)
    if not couple:
        return Response(
            {'detail': 'No couple found.'},
            status=status.HTTP_404_NOT_FOUND
        )

    if couple.partner_a_id != request.user.id:
        return Response(
            {'detail': 'Only partner A can create invites.'},
            status=status.HTTP_403_FORBIDDEN
        )

    ttl = int(request.data.get('ttl_minutes', 60))
    if ttl < 1 or ttl > 10080:  # 1 min to 7 days
        return Response(
            {'detail': 'TTL must be between 1 and 10080 minutes.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    invite = PairingInvite.create_for_couple(couple, ttl_minutes=ttl)
    return Response({'invite': PairingInviteSerializer(invite).data})


@api_view(['POST'])
@permission_classes([permissions.IsAuthenticated])
def couple_join(request):
    """
    Join a couple using a pairing invitation code.

    POST /api/couple/join/
    {
        "code": "123456"
    }

    Returns 200 with couple data if successful
    Returns 400 if user already in a couple
    Returns 400 if code is invalid or expired
    Returns 400 if couple already has 2 partners
    """
    if get_user_couple(request.user):
        return Response(
            {'detail': 'User already in a couple.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    serializer = JoinCoupleSerializer(data=request.data)
    serializer.is_valid(raise_exception=True)
    code = serializer.validated_data['code']

    invite = PairingInvite.objects.filter(code=code).order_by('-created_at').first()
    if not invite or not invite.is_valid:
        return Response(
            {'detail': 'Invalid or expired code.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    couple = invite.couple
    if couple.partner_b_id is not None:
        return Response(
            {'detail': 'This couple is already paired.'},
            status=status.HTTP_400_BAD_REQUEST
        )

    # Atomically update couple
    couple.partner_b = request.user
    couple.updated_at = timezone.now()
    couple.save(update_fields=['partner_b', 'updated_at'])
    invite.mark_used()

    return Response({'couple': CoupleSerializer(couple).data})
