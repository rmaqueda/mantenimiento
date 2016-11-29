import os
from django.http import Http404
from rest_framework import status
from rest_framework.filters import SearchFilter, OrderingFilter
from rest_framework.parsers import FormParser
from rest_framework.parsers import MultiPartParser
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.viewsets import ModelViewSet
from GoGarage.base_model import DefaultPagination
from models import Vehicle, VehicleImage
from serializers import VehicleSerializer, VehicleSerializerList, VehicleImageSerializer


class VehiclesViewSet(ModelViewSet):
    serializer_class = VehicleSerializerList
    filter_backends = (SearchFilter, OrderingFilter)
    search_fields = ('nick', 'brand')
    ordering_fileds = ('nick', 'brand')
    permission_classes = (IsAuthenticated,)
    pagination_class = DefaultPagination

    def get_serializer_class(self):
        if self.action == 'list':
            return VehicleSerializerList
        if self.action == 'retrieve':
            return VehicleSerializer
        if self.action == 'update':
            return VehicleSerializer
        return VehicleSerializer

    def get_queryset(self):
        if self.request.user.is_authenticated():
            return Vehicle.objects.filter(created_by=self.request.user)

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user)


class VehicleImageViewSet(ModelViewSet):
    queryset = VehicleImage.objects.all()
    serializer_class = VehicleImageSerializer
    parser_classes = (MultiPartParser, FormParser,)

    def perform_create(self, serializer):
        serializer.save(created_by=self.request.user, image=self.request.data.get('image'))

    def destroy(self, request, *args, **kwargs):
        try:
            instance = self.get_object()
            self.perform_destroy(instance)
            os.remove(instance.image.file.name)
        except Http404:
            pass
        return Response(status=status.HTTP_204_NO_CONTENT)
