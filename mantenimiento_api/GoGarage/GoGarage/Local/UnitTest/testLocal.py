from django.contrib.auth.models import User
from django.test import TestCase
from django.core.urlresolvers import reverse
from rest_framework import status
from rest_framework.test import APIClient, APIRequestFactory, force_authenticate

from GoGarage.Local.api import LocalViewSet
from GoGarage.Local.models import Local


class TestLocal(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.factory = APIRequestFactory()

        self.user = User.objects.create_user(username='test', password='pass')

        self.local = Local.objects.create(name='localname',
                                          address='address',
                                          telephone='telephone',
                                          contact='contact',
                                          created_by=self.user)

        self.localData = {"name": "localnew",
                         "address": "addressnew",
                         "telephone": "telephonenew",
                         "contact": "contactnew"}

    def test_local_list_noAuth(self):
        response = self.client.get(reverse('local-list'))

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_local_list(self):
        self.client.login(username='test', password='pass')
        response = self.client.get(reverse('local-list'))

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        results = response.data.get('results')
        self.compareObjectWithLocal(results[0])

    def test_local_details_noAuth(self):
        request = self.factory.get(reverse('local-detail', args=(self.local.pk,)), format='json')
        view = LocalViewSet.as_view({'get': 'list'})
        response = view(request, pk=self.local.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_local_details(self):
        request = self.factory.get(reverse('local-detail', args=(self.local.pk,)), format='json')
        view = LocalViewSet.as_view({'get': 'list'})
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.local.pk)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsNotNone(response.data)
        results = response.data.get('results')
        self.compareObjectWithLocal(results[0])

    def test_local_create_noAuth(self):
        view = LocalViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('local-list'), self.localData)
        response = view(request, pk=self.local.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_local_create(self):
        view = LocalViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('local-list'), self.localData)
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.local.pk)

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIsNotNone(response.data)
        self.compareObjectWithLocalData(response.data)

    def test_local_create_badRequest(self):
        newData = self.localData
        del newData['name']
        view = LocalViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('local-list'), newData)
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.local.pk)

        self.assertEqual(response.status_code, status.HTTP_400_BAD_REQUEST)
        self.assertEqual(response.data, {"name": ["This field is required."]})

    def test_local_update_noAuth(self):
        view = LocalViewSet.as_view({'put': 'update'})
        request = self.factory.put(reverse('local-detail', args=(self.local.pk,)), self.localData, format='json')
        response = view(request, pk=self.local.pk)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_local_update(self):
        view = LocalViewSet.as_view({'put': 'update'})
        request = self.factory.put(reverse('local-detail', args=(self.local.pk,)), self.localData, format='json')
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.local.pk)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsNotNone(response.data)
        self.compareObjectWithLocalData(response.data)

    def test_local_delete_noAuth(self):
        response = self.client.delete(reverse('local-detail', args=(self.local.pk,)), format='json')

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {'detail': 'Authentication credentials were not provided.'})

    def test_local_delete(self):
        self.client.login(username='test', password='pass')
        response = self.client.delete(reverse('local-detail', args=(self.local.pk,)), format='json')
        locals = Local.objects.all()

        self.assertEqual(response.status_code, status.HTTP_204_NO_CONTENT)
        self.assertEqual(locals.count(), 0)

    #TODO: Replace with cmp function
    # Utils Methods
    def compareObjectWithLocalData(self, object_to_compare):
        self.assertEqual(object_to_compare.get('name'), self.localData.get('name'))
        self.assertEqual(object_to_compare.get('address'), self.localData.get('address'))
        self.assertEqual(object_to_compare.get('telephone'), self.localData.get('telephone'))
        self.assertEqual(object_to_compare.get('contact'), self.localData.get('contact'))

    def compareObjectWithLocal(self, object_to_compare):
        self.assertEqual(object_to_compare.get('name'), self.local.name)
        self.assertEqual(object_to_compare.get('address'), self.local.address)
        self.assertEqual(object_to_compare.get('telephone'), self.local.telephone)
        self.assertEqual(object_to_compare.get('contact'), self.local.contact)
