from rest_framework import serializers
from GoGarage.Local.models import Local


class LocalSerializer(serializers.ModelSerializer):

    class Meta:
        model = Local
        exclude = ('created_by', )