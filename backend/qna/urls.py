from rest_framework.routers import DefaultRouter

from .views import QuestionViewSet

router = DefaultRouter()
router.register(r'qna/questions', QuestionViewSet, basename='qna-questions')

urlpatterns = router.urls
