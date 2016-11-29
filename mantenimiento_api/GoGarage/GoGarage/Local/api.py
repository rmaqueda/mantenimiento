from rest_framework.permissions import IsAuthenticated
from rest_framework.viewsets import ModelViewSet
from GoGarage.Local.models import Local
from GoGarage.Local.serializers import LocalSerializer
from GoGarage.base_model import DefaultPagination


class LocalViewSet(ModelViewSet):
    serializer_class = LocalSerializer
    permission_classes = (IsAuthenticated, )
    pagination_class = DefaultPagination

    def get_queryset(self):
        if self.request.user.is_authenticated():
            return Local.objects.filter(created_by=self.request.user)

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)
