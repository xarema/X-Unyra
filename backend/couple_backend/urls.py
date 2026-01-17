from django.contrib import admin
from django.urls import path, include
from rest_framework_simplejwt.views import TokenRefreshView
from rest_framework.response import Response
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny

@api_view(['GET'])
@permission_classes([AllowAny])
def api_root(request):
    """Root API endpoint - welcome message"""
    return Response({
        'message': 'Welcome to Couple App API',
        'version': '1.0',
        'endpoints': {
            'auth': '/api/auth/',
            'couples': '/api/couples/',
            'checkins': '/api/checkins/',
            'qna': '/api/qna/',
            'goals': '/api/goals/',
            'letters': '/api/letters/',
            'sync': '/api/sync/',
        }
    })

urlpatterns = [
    path('', api_root, name='api-root'),
    path('admin/', admin.site.urls),

    # Auth (JWT) - Token refresh only
    path('api/auth/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    # Auth routes from accounts app (register, login, me)
    path('api/auth/', include('accounts.urls')),
    path('api/', include('couples.urls')),
    path('api/', include('qna.urls')),
    path('api/', include('goals.urls')),
    path('api/', include('checkins.urls')),
    path('api/', include('letters.urls')),
    path('api/', include('sync.urls')),
]
