from django.contrib.auth.models import User
from django.test import TestCase
from django.core.urlresolvers import reverse
from rest_framework import status
from rest_framework.test import APIClient, APIRequestFactory, force_authenticate
from GoGarage.Service.api import ServiceViewSet
from GoGarage.Service.models import Service


class TestServiceAPI(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.factory = APIRequestFactory()
        self.user = User.objects.create_user(username='test', password='pass')

        self.service = Service.objects.create(type='servicetypename',
                                              description='servicedecription',
                                              created_by=self.user)

        self.serviceData = {'type': 'serviceTypeNew',
                            'description': 'serviceDescriptionNew'}

    def test_service_list_noAuth(self):
        response = self.client.get(reverse('service-list'))

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {u'detail': u'Authentication credentials were not provided.'})

    def test_service_list(self):
        self.client.login(username='test', password='pass')
        response = self.client.get(reverse('service-list'))

        results = response.data.get('results')
        self.compareObjectWithService(results[0])

    def test_service_details_noAuth(self):
        request = self.factory.get(reverse('service-detail', args=(self.service.pk,)), format='json')
        view = ServiceViewSet.as_view({'get': 'list'})
        response = view(request, pk=self.service.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {u'detail': u'Authentication credentials were not provided.'})

    def test_service_details(self):
        request = self.factory.get(reverse('service-detail', args=(self.service.pk,)), format='json')
        view = ServiceViewSet.as_view({'get': 'list'})
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.service.pk)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsNotNone(response.data)
        results = response.data.get('results')
        self.compareObjectWithService(results[0])

    def test_service_create_noAuth(self):
        view = ServiceViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('service-list'), self.serviceData)
        response = view(request, pk=self.service.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_service_create(self):
        view = ServiceViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('service-list'), self.serviceData)
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.service.pk)

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIsNotNone(response.data)
        self.compareObjectWithServiceData(response.data)

    def test_service_create_badRequest(self):
        newData = self.serviceData
        del newData['type']
        view = ServiceViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('service-list'), newData)
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.service.pk)

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data, {"type": ["This field is required."]})

    def test_service_update_noAuth(self):
        view = ServiceViewSet.as_view({'put': 'update'})
        request = self.factory.put(reverse('service-detail', args=(self.service.pk,)), self.serviceData, format='json')
        response = view(request, pk=self.service.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_service_update(self):
        view = ServiceViewSet.as_view({'put': 'update'})
        request = self.factory.put(reverse('service-detail', args=(self.service.pk,)), self.serviceData, format='json')
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.service.pk)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsNotNone(response.data)
        self.compareObjectWithServiceData(response.data)

    def test_service_delete_noAuth(self):
        response = self.client.delete(reverse('service-detail', args=(self.service.pk,)), format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_service_delete(self):
        self.client.login(username='test', password='pass')
        response = self.client.delete(reverse('service-detail', args=(self.service.pk,)), format='json')
        services = Service.objects.all()

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(services.count(), 0)

    # Utils Methods
    def compareObjectWithServiceData(self, object_to_compare):
        self.assertEqual(object_to_compare.get('type'), self.serviceData.get('type'))
        self.assertEqual(object_to_compare.get('description'), self.serviceData.get('description'))

    def compareObjectWithService(self, object_to_compare):
        self.assertEqual(object_to_compare.get('type'), self.service.type)
        self.assertEqual(object_to_compare.get('description'), self.service.description)
