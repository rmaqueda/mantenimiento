from __future__ import unicode_literals
from django.db import models
from GoGarage.Local.models import Local
from GoGarage.Service.models import Service
from GoGarage.Vehicle.models import Vehicle
from GoGarage.base_model import BaseModel, user_directory_path


class MaintenanceBook(BaseModel):
    vehicle = models.ForeignKey(Vehicle, on_delete=models.CASCADE)
    local = models.ForeignKey(Local, null=True, on_delete=models.PROTECT)
    service = models.ForeignKey(Service, null=True, on_delete=models.PROTECT)
    date = models.DateField()
    price = models.FloatField()
    kilometers = models.IntegerField()

    def __unicode__(self):
        return u'%s: %s in %s' % (self.vehicle.nick, self.service.description, self.local.name)


class MaintenanceBookImage(BaseModel):
    maintenance = models.ForeignKey(MaintenanceBook, on_delete=models.CASCADE, related_name='images')
    datafile = models.FileField(upload_to=user_directory_path)

    def __unicode__(self):
        return self.datafile.url
