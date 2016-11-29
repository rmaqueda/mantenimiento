from django.contrib.auth.models import User
from django.test import TestCase
from django.core.urlresolvers import reverse
from django.conf import settings
from rest_framework import status
from rest_framework.test import APIClient, APIRequestFactory, force_authenticate
from GoGarage.Vehicle.api import VehiclesViewSet
from GoGarage.Vehicle.models import Vehicle


class TestVehicle(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.factory = APIRequestFactory()
        self.user = User.objects.create_user(username='test', password='pass')

        self.vehicle = Vehicle.objects.create(nick='nick',
                                              brand='brand',
                                              model='model',
                                              chassisNumber='1234',
                                              registrationNumber='1234CTL',
                                              color='Gray',
                                              manufacturedDate='2013-10-05',
                                              description='description',
                                              created_by=self.user)

        self.vehicleData = {"nick": "nicknew",
                            "brand": "brandnew",
                            "model": "modelnew",
                            "chassisNumber": "chassisNumbernew",
                            "registrationNumber": "registrationNumbernew",
                            "color": "colornew",
                            "manufacturedDate": "2015-12-25",
                            "description": "descriptionnew"}

    def test_Vehicle_Relationship_User(self):
        newuser = User.objects.create_user(username='newUser', password='pass')
        newvehicle = Vehicle.objects.create(created_by=newuser,
                                            nick='nick',
                                            brand='brand',
                                            model='model',
                                            color='color',
                                            registrationNumber='registrationNumber')
        newvehicle.save()
        vehicles = Vehicle.objects.filter(created_by=newuser)
        self.assertEqual(vehicles.count(), 1)

        newuser.delete()
        vehicles = Vehicle.objects.filter(created_by=newuser)
        self.assertEqual(vehicles.count(), 0)

    def test_vehicle_list_noAuth(self):
        response = self.client.get(reverse('vehicle-list'))

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_vehicle_list(self):
        self.client.login(username='test', password='pass')
        response = self.client.get(reverse('vehicle-list'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        results = response.data.get('results')
        self.assertTrue(cmp(self.vehicleData, results[0]))

    def test_vehicle_details_noAuth(self):
        request = self.factory.get(reverse('vehicle-detail', args=(self.vehicle.pk,)), format='json')
        view = VehiclesViewSet.as_view({'get': 'list'})
        response = view(request, pk=self.vehicle.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {u'detail': u'Authentication credentials were not provided.'})

    def test_vehicle_details(self):
        request = self.factory.get(reverse('vehicle-detail', args=(self.vehicle.pk,)), format='json')
        view = VehiclesViewSet.as_view({'get': 'list'})
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.vehicle.pk)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(cmp(self.vehicleData, response.data))

    def test_vehicle_create_noAuth(self):
        view = VehiclesViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('vehicle-list'), self.vehicleData)
        response = view(request, pk=self.vehicle.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_vehicle_create(self):
        view = VehiclesViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('vehicle-list'), self.vehicleData)
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.vehicle.pk)

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIsNotNone(response.data)
        self.assertTrue(cmp(self.vehicleData, response.data))

    def test_vehicle_create_badRequest(self):
        newData = self.vehicleData
        del newData['brand']

        view = VehiclesViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('vehicle-list'), newData)
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.vehicle.pk)

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data, {"brand": ["This field is required."]})

    def test_vehicle_update_noAuth(self):
        view = VehiclesViewSet.as_view({'put': 'update'})
        request = self.factory.put(reverse('vehicle-detail', args=(self.vehicle.pk,)), self.vehicleData, format='json')
        response = view(request, pk=self.vehicle.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_vehicle_update(self):
        view = VehiclesViewSet.as_view({'put': 'update'})
        request = self.factory.put(reverse('vehicle-detail', args=(self.vehicle.pk,)), self.vehicleData, format='json')
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.vehicle.pk)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsNotNone(response.data)
        self.assertTrue(cmp(self.vehicleData, response.data))

    def test_vehicle_delete_noAuth(self):
        response = self.client.delete(reverse('vehicle-detail', args=(self.vehicle.pk,)), format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)

    def test_vehicle_delete(self):
        self.client.login(username='test', password='pass')
        response = self.client.delete(reverse('vehicle-detail', args=(self.vehicle.pk,)), format='json')
        vehicles = Vehicle.objects.all()

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(vehicles.count(), 0)

    def test_vehicle_paggination(self):
        vehicles = 300
        for x in range(0, vehicles):
            vehicle = Vehicle.objects.create(nick='nick',
                                             brand='brand',
                                             model='model',
                                             chassisNumber='1234',
                                             registrationNumber='1234CTL',
                                             color='Gray',
                                             manufacturedDate='2013-10-05',
                                             description='description',
                                             created_by=self.user)

        self.client.login(username='test', password='pass')
        response = self.client.get(reverse('vehicle-list'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)

        # Numbers of new created vehicles plus vehicle created in setup
        self.assertEqual(response.data.get('count'), vehicles + 1)
        self.assertEqual(response.data.get('next'), 'http://testserver/api/1.0/vehicle/?page=2')
        results = response.data.get('results')
        restSettings = getattr(settings, "REST_FRAMEWORK", None)
        self.assertEqual(len(results), restSettings.get('PAGE_SIZE'))
