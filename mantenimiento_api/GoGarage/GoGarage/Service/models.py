from __future__ import unicode_literals
from django.contrib.auth.models import User
from django.db import models
from GoGarage.base_model import BaseModel


class Service(BaseModel):
    type = models.CharField(max_length=150)
    description = models.TextField(blank=True, null=True, default="")

    def __unicode__(self):
        return unicode(self.type)
