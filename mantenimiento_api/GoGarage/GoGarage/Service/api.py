from rest_framework.viewsets import ModelViewSet
from rest_framework.permissions import IsAuthenticated
from GoGarage.Service.models import Service
from GoGarage.Service.serializers import ServiceSerializer
from GoGarage.base_model import DefaultPagination


class ServiceViewSet(ModelViewSet):
    serializer_class = ServiceSerializer
    permission_classes = (IsAuthenticated, )
    pagination_class = DefaultPagination

    def get_queryset(self):
        if self.request.user.is_authenticated():
            return Service.objects.filter(created_by=self.request.user)

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)