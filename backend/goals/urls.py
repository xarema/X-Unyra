from rest_framework.routers import DefaultRouter

from .views import GoalViewSet, GoalActionViewSet

router = DefaultRouter()
router.register(r'goals', GoalViewSet, basename='goals')
router.register(r'goals/actions', GoalActionViewSet, basename='goal-actions')

urlpatterns = router.urls
