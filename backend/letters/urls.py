from rest_framework.routers import DefaultRouter

from .views import LetterViewSet

router = DefaultRouter()
router.register(r'letters', LetterViewSet, basename='letters')

urlpatterns = router.urls
