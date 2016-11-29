from rest_framework import serializers
from GoGarage.Service.models import Service


class ServiceSerializer(serializers.ModelSerializer):

    class Meta:
        model = Service
        exclude = ('created_by', )
