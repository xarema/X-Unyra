from django.contrib import admin

from .models import CheckIn


@admin.register(CheckIn)
class CheckInAdmin(admin.ModelAdmin):
    list_display = ('id', 'couple', 'user', 'date', 'mood', 'stress', 'energy', 'updated_at')
