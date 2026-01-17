from rest_framework import permissions

from .utils import get_user_couple


class IsCoupleMember(permissions.BasePermission):
    """Allow access if user belongs to the couple related to the object."""

    def has_object_permission(self, request, view, obj):
        couple = get_user_couple(request.user)
        if couple is None:
            return False
        obj_couple = getattr(obj, 'couple', None)
        if obj_couple is None:
            # If obj itself is a Couple
            return obj == couple
        return obj_couple == couple
