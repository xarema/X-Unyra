from rest_framework.routers import DefaultRouter

from .views import CheckInViewSet

router = DefaultRouter()
router.register(r'checkins', CheckInViewSet, basename='checkins')

urlpatterns = router.urls
