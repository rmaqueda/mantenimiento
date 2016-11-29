from rest_framework import serializers
from rest_framework.relations import PrimaryKeyRelatedField
from GoGarage.Local.models import Local
from GoGarage.Local.serializers import LocalSerializer
from GoGarage.Service.models import Service
from GoGarage.MaintenanceBook.models import MaintenanceBook
from GoGarage.Service.serializers import ServiceSerializer
from GoGarage.Vehicle.models import Vehicle
from GoGarage.Vehicle.serializers import VehicleSerializerList


class MaintenanceBookSerializerList(serializers.ModelSerializer):
    vehicle = PrimaryKeyRelatedField(queryset=Vehicle.objects.all())
    local = PrimaryKeyRelatedField(queryset=Local.objects.all())
    service = PrimaryKeyRelatedField(queryset=Service.objects.all())
    date = serializers.DateField()
    price = serializers.FloatField()
    kilometers = serializers.IntegerField()

    class Meta:
        model = MaintenanceBook
        exclude = ('created_by', )
        ordering = ('date',)

    def create(self, validated_data):
        vehicle = validated_data.get('vehicle')
        local = validated_data.get('local')
        service = validated_data.get('service')
        maintenance = MaintenanceBook.objects.create(vehicle=vehicle,
                                                   local=local,
                                                   service=service,
                                                   date=validated_data.pop('date'),
                                                   price=validated_data.pop('price'),
                                                   kilometers=validated_data.pop('kilometers'),
                                                   created_by=self.context['request'].user)
        return maintenance

    def update(self, instance, validated_data):
        vehicle = validated_data.pop('vehicle')
        local = validated_data.get('local')
        service = validated_data.get('service')

        instance.vehicle = vehicle
        instance.local = local
        instance.service = service
        instance.date = validated_data.get('date')
        instance.price = validated_data.get('price')
        instance.kilometers = validated_data.get('kilometers')
        instance.save()

        return instance

    def validate_kilometers(self, data):
        return data
    #     if self.instance:
    #         date = self.instance.date
    #         kilometers = self.instance.kilometers
    #     else:
    #         date = self.initial_data.get('date')
    #         kilometers = self.initial_data.get('kilometers')
    #
    #     entries = MaintenanceBook.objects.all()
    #     if len(entries) > 1:
    #         latestentry = MaintenanceBook.objects.order_by('-date')[0]
    #         newestentries = MaintenanceBook.objects.order_by('-date').filter(date__gt = date)
    #
    #         if len(newestentries):
    #             newestentry = newestentries[0]
    #
    #             if kilometers >= newestentry.kilometers:
    #                 raise serializers.ValidationError("Kilometers field cannot be more than a latest entry, Date: {}, Kilometer: {}".format(newestentry.date, newestentry.kilometers))
    #
    #         if kilometers < latestentry.kilometers:
    #             raise serializers.ValidationError("Kilometers field cannot be less than a previous entry, Date: {}, Kilometer: {}".format(latestentry.date, latestentry.kilometers))
    #
    #     return data


class MaintenanceBookSerializerDetail(serializers.ModelSerializer):
    vehicle = VehicleSerializerList(read_only=True)
    local = LocalSerializer(read_only=True)
    service = ServiceSerializer(read_only=True)


    class Meta:
        model = MaintenanceBook