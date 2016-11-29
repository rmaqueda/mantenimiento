from rest_framework import filters
from rest_framework.permissions import IsAuthenticated
from rest_framework.viewsets import ModelViewSet
from GoGarage.MaintenanceBook.models import MaintenanceBook
from GoGarage.MaintenanceBook.serializers import MaintenanceBookSerializerList, MaintenanceBookSerializerDetail
from GoGarage.base_model import DefaultPagination


class MaintenanceBookViewSet(ModelViewSet):
    serializer_class = MaintenanceBookSerializerList
    permission_classes = (IsAuthenticated,)
    filter_backends = (filters.DjangoFilterBackend,)
    filter_fields = ('vehicle', 'price')
    ordering_fields = ('date', 'created_at', 'kilometers')
    ordering = ('date',)
    pagination_class = DefaultPagination

    def get_queryset(self):
        if self.request.user.is_authenticated():
            return MaintenanceBook.objects.filter(created_by=self.request.user)

    def get_serializer_class(self):

        if self.action == 'list':
            return MaintenanceBookSerializerList

        if self.action == 'retrieve':
            return MaintenanceBookSerializerDetail

        if self.action == 'update':
            return MaintenanceBookSerializerList

        return MaintenanceBookSerializerList
