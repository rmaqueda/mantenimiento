from django.conf.urls import url, include
from django.contrib import admin
from rest_framework.routers import DefaultRouter
from GoGarage.Local.api import LocalViewSet
from GoGarage.MaintenanceBook.api import MaintenanceBookViewSet
from GoGarage.User.api import UsersViewSet
from GoGarage.Service.api import ServiceViewSet
from GoGarage.Vehicle.api import VehiclesViewSet, VehicleImageViewSet
from rest_framework.authtoken import views

router = DefaultRouter()
router.register(r'user', UsersViewSet, base_name='user')

router.register(r'maintenancebook', MaintenanceBookViewSet, base_name='maintenancebook')
router.register(r'local', LocalViewSet, base_name='local')
router.register(r'service', ServiceViewSet, base_name='service')

router.register(r'vehicle', VehiclesViewSet, base_name='vehicle')
router.register(r'vehicleimage', VehicleImageViewSet, base_name='vehicleimage')

urlpatterns = [
    url(r'^admin/', admin.site.urls),
    url(r'^api/1.0/', include(router.urls)),
    url(r'^rest-auth/', include('rest_auth.urls')),
    url(r'^rest-auth/registration/', include('rest_auth.registration.urls')),
    #url(r'^accounts/', include('allauth.urls')),
    url(r'^api-token-auth/', views.obtain_auth_token)
]
