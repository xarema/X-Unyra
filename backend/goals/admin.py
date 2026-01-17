from django.contrib import admin

from .models import Goal, GoalAction


@admin.register(Goal)
class GoalAdmin(admin.ModelAdmin):
    list_display = ('id', 'couple', 'title', 'status', 'target_date', 'updated_at')


@admin.register(GoalAction)
class GoalActionAdmin(admin.ModelAdmin):
    list_display = ('id', 'goal', 'text', 'done', 'updated_at')
