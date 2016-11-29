from __future__ import unicode_literals
import uuid
from django.contrib.auth.models import User
from django.db import models
from rest_framework.pagination import PageNumberPagination


def user_directory_path(instance, filename):
    return 'userID_{0}/{1}'.format(instance.created_by.id,  str(uuid.uuid4()))


def vehicle_directory_path(instance, filename):
    return 'vehicleID_{0}/{1}'.format(instance.vehicle.id,  str(uuid.uuid4()))


class DefaultPagination(PageNumberPagination):
    page_size_query_param = 'page_size'
    max_page_size = 100


class BaseModel(models.Model):
    created_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='+',)
    created_at = models.DateTimeField(u'Created at', auto_now_add=True)
    updated_at = models.DateTimeField(u'Updated at', auto_now=True)

    class Meta:
        abstract = True
