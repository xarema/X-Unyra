from django.contrib import admin

from .models import Couple, PairingInvite


@admin.register(Couple)
class CoupleAdmin(admin.ModelAdmin):
    list_display = ('id', 'partner_a', 'partner_b', 'created_at')
    search_fields = ('partner_a__username', 'partner_b__username')


@admin.register(PairingInvite)
class PairingInviteAdmin(admin.ModelAdmin):
    list_display = ('code', 'couple', 'expires_at', 'used_at', 'created_at')
    search_fields = ('code',)
