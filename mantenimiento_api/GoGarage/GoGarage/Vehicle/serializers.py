from rest_framework import serializers
from models import Vehicle, VehicleImage


class VehicleImageSerializer(serializers.ModelSerializer):

    class Meta:
        model = VehicleImage
        exclude = ('created_by', )

    def create(self, validated_data):
        return VehicleImage.objects.create(**validated_data)


class VehicleSerializerList(serializers.ModelSerializer):
    images = VehicleImageSerializer(many=True, read_only=True)

    class Meta:
        model = Vehicle
        exclude = ('created_by',)


class VehicleSerializer(serializers.ModelSerializer):
    images = VehicleImageSerializer(many=True, read_only=True)

    class Meta:
        model = Vehicle
        exclude = ('created_by', )
