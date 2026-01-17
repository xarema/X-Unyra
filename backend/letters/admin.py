from django.contrib import admin

from .models import Letter


@admin.register(Letter)
class LetterAdmin(admin.ModelAdmin):
    list_display = ('id', 'couple', 'month', 'updated_at')
