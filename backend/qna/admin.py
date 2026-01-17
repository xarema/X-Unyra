from django.contrib import admin

from .models import Question, Answer


@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'couple', 'theme', 'created_by', 'created_at')
    search_fields = ('text',)


@admin.register(Answer)
class AnswerAdmin(admin.ModelAdmin):
    list_display = ('id', 'question', 'user', 'status', 'updated_at')
