from django.urls import include, path, re_path
from rest_framework import routers
from . import views

router = routers.DefaultRouter()
router.register(r'material', views.MaterialViewSet)
router.register(r'marks', views.MarksViewSet)
router.register(r'company', views.CompanyViewSet)
router.register(r'link', views.LinkViewSet)
router.register(r'ware_type', views.WareTypeViewSet)
router.register(r'ware', views.WareViewSet)

# Wire up our API using automatic URL routing.
# Additionally, we include login URLs for the browsable API.
urlpatterns = [
    path('', include(router.urls)),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
]