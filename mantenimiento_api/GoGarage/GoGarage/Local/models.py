from __future__ import unicode_literals
from django.db import models
from GoGarage.base_model import BaseModel


class Local(BaseModel):
    name = models.CharField(max_length=150)
    contact = models.CharField(max_length=150)
    telephone = models.CharField(max_length=150)
    address = models.CharField(blank=True, null=True, max_length=150)
    latitude = models.DecimalField(blank=True, null=True, max_digits=9, decimal_places=6)
    longitude = models.DecimalField(blank=True, null=True, max_digits=9, decimal_places=6)
    description = models.TextField(blank=True, null=True, default='')

    def __unicode__(self):
        return unicode(self.name)
