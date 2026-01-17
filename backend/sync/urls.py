from django.urls import path

from .views import changes

urlpatterns = [
    path('sync/changes/', changes, name='sync_changes'),
]
