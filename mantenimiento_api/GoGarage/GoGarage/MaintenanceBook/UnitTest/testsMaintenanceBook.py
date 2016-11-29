from django.contrib.auth.models import User
from django.db import IntegrityError
from django.test import TestCase
from rest_framework.test import APIClient, APIRequestFactory
from GoGarage.Local.models import Local
from GoGarage.MaintenanceBook.models import MaintenanceBook
from GoGarage.Service.models import Service
from GoGarage.Vehicle.models import Vehicle


# TODO: add API Tests
class TestMaintenance(TestCase):
    def setUp(self):
        self.client = APIClient()
        self.factory = APIRequestFactory()

        self.user = User.objects.create_user(username='test', password='pass')

        self.vehicle = Vehicle.objects.create(created_by=self.user,
                                              nick='nick',
                                              brand='brand',
                                              model='model',
                                              color='color',
                                              registrationNumber='registrationNumber')

        self.local = Local.objects.create(name='name',
                                         contact='contact',
                                         telephone='telephone',
                                         created_by=self.user)

        self.service = Service.objects.create(type='type',
                                              description='description',
                                              created_by=self.user)

        self.maintenanceEntry = MaintenanceBook.objects.create(vehicle=self.vehicle,
                                                               local=self.local,
                                                               service=self.service,
                                                               date='2015-12-25',
                                                               price=200,
                                                               kilometers=100,
                                                               created_by=self.user)

        self.maintenanceData = {
            'vehicle': self.vehicle.pk,
            'service': self.service.pk,
            'local': self.local.pk,
            'date': '2015-12-31',
            'price': '120',
            'kilometers': '120000'
        }

    #TODO: Check this tests! If you config Date field who not null, the test not fail.
    def test_Date_MandatoryFields(self):
        with self.assertRaises(IntegrityError):
            MaintenanceBook.objects.create(vehicle=self.vehicle, price=100, kilometers=100)

    def test_Price_MandatoryFields(self):
        with self.assertRaises(IntegrityError):
            MaintenanceBook.objects.create(vehicle=self.vehicle, date='2015-12-25', kilometers=100)

    def test_Kilometers_MandatoryFields(self):
        with self.assertRaises(IntegrityError):
            MaintenanceBook.objects.create(vehicle=self.vehicle, date='2015-12-25', price=100)

    def test_Relationship_User_Maintenance(self):
        self.user.delete()
        vehicles = Vehicle.objects.filter(created_by=self.user)
        services = Service.objects.filter(created_by=self.user)
        maintenances = MaintenanceBook.objects.filter(created_by=self.user)
        locals = Local.objects.filter(created_by=self.user)

        self.assertEqual(locals.count(), 0)
        self.assertEqual(vehicles.count(), 0)
        self.assertEqual(services.count(), 0)
        self.assertEqual(maintenances.count(), 0)

    def test_Relationship_Vehicle_Maintenance(self):
        self.vehicle.delete()
        vehicles = Vehicle.objects.filter(created_by=self.user)
        services = Service.objects.filter(created_by=self.user)
        maintenances = MaintenanceBook.objects.filter(created_by=self.user)
        locals = Local.objects.filter(created_by=self.user)

        self.assertEqual(locals.count(), 1)
        self.assertEqual(vehicles.count(), 0)
        self.assertEqual(services.count(), 1)
        self.assertEqual(maintenances.count(), 0)

    def test_Relationship_Local_Maintenance(self):
        self.local.delete()

        vehicles = Vehicle.objects.filter(created_by=self.user)
        services = Service.objects.filter(created_by=self.user)
        maintenances = MaintenanceBook.objects.filter(created_by=self.user)
        locals = Local.objects.filter(created_by=self.user)

        self.assertEqual(locals.count(), 0)
        self.assertEqual(vehicles.count(), 1)
        self.assertEqual(services.count(), 1)
        self.assertEqual(maintenances.count(), 1)
