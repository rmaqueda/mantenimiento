import os
from urlparse import urlparse
from django.contrib.auth.models import User
from django.core.exceptions import ObjectDoesNotExist
from rest_framework import status
from rest_framework.reverse import reverse
from rest_framework.test import APIClient, APITestCase, APIRequestFactory, force_authenticate
from GoGarage import settings
from GoGarage.Vehicle.models import VehicleImage


class VehicleImageUploadTests(APITestCase):

    def setUp(self):
        self.client = APIClient()
        self.factory = APIRequestFactory()
        self.user = User.objects.create_user('test', password='test', email='test@test.test')

    def tearDown(self):
        try:
            user = User.objects.get_by_natural_key('test')
            user.delete()
        except ObjectDoesNotExist:
            pass
        VehicleImage.objects.all().delete()

    def _create_test_file(self, path):
        file = open(path, 'w')
        file.write('test123\n')
        file.close()
        file = open(path, 'rb')
        return {'datafile': file}

    def test_upload_noAuth(self):
        self.client.logout()
        data = self._create_test_file('test_upload')
        response = self.client.post(reverse('vehicleimage-list'), data, format='multipart')
        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    #TODO: fix test, it is necesary send vehicle and image with parameters
    def fix_test_upload_file(self):
        data = self._create_test_file('/tmp/test_upload')
        self.client.login(username='test', password='test')
        response = self.client.post(reverse('vehicleimage-list'), data, format='multipart')
        force_authenticate(response, user=self.user)

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertTrue(urlparse(response.data['image']).path.startswith(settings.MEDIA_URL))
