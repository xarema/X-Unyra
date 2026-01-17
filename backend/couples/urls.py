from django.urls import path

from .views import couple_create, couple_get, couple_invite, couple_join

urlpatterns = [
    path('couple/create/', couple_create, name='couple_create'),
    path('couple/', couple_get, name='couple_get'),
    path('couple/invite/', couple_invite, name='couple_invite'),
    path('couple/join/', couple_join, name='couple_join'),
]
