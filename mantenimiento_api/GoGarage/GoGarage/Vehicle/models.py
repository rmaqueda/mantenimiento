from __future__ import unicode_literals
from django.contrib.auth.models import User
from django.db import models
from GoGarage.base_model import BaseModel, vehicle_directory_path


class Vehicle(BaseModel):
    nick = models.CharField(max_length=150)
    brand = models.CharField(max_length=150)
    model = models.CharField(max_length=150)
    color = models.CharField(max_length=150)
    registrationNumber = models.CharField(max_length=150)
    chassisNumber = models.CharField(blank=True, null=True, max_length=150)
    manufacturedDate = models.DateField(blank = True, null = True)
    description = models.TextField(blank=True, null=True, default="")


    def __unicode__(self):
        return unicode(self.nick)


class VehicleImage(BaseModel):
    vehicle = models.ForeignKey(Vehicle, on_delete=models.CASCADE, related_name='images')
    image = models.ImageField(upload_to=vehicle_directory_path)

    class Meta:
        unique_together = ('vehicle', 'image')

    def __unicode__(self):
        return self.image.url
