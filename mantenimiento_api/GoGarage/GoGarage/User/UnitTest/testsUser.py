from django.test import TestCase
from django.contrib.auth.models import User
from django.core.urlresolvers import reverse
from rest_framework import status
from rest_framework.test import APIClient, APIRequestFactory, force_authenticate

from GoGarage.User.api import UsersViewSet


class TestUserAPI(TestCase):

    def setUp(self):
        self.client = APIClient()
        self.factory = APIRequestFactory()

        self.superuser = User.objects.create_user(username='root',
                                                  password='pass',
                                                  first_name = 'Ricardo',
                                                  last_name = 'Maqueda Martinez',
                                                  email = 'ricardo.maqueda@molestudio.es',
                                                  is_superuser=True,
                                                  is_staff=True)

        self.user = User.objects.create_user(username='test',
                                             password='pass',
                                             first_name = 'Ricardo',
                                             last_name = 'Maqueda Martinez',
                                             email = 'ricardo.maqueda@molestudio.es',
                                             is_superuser=False,
                                             is_staff=True)

        self.userData = {'username': u'testnew',
                         'first_name': u'Ricardonew',
                         'last_name': u'Maqueda Martinez new',
                         'email': u'ricardo.maqueda.new@molestudio.es',
                         'password': u'12345'}

    def test_user_list_No_Auth(self):
        response = self.client.get(reverse('user-list'))

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {u'detail': u'Authentication credentials were not provided.'})

    def test_user_list_superuser(self):
        request = self.factory.get(reverse('user-list'), format='json')
        view = UsersViewSet.as_view({'get': 'list'})
        force_authenticate(request, user=self.superuser)
        response = view(request)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertTrue(cmp(response.data[0], self.superuser))
        self.assertTrue(cmp(response.data[1], self.user))

    def test_user_list_user(self):
        request = self.factory.get(reverse('user-list'), format='json')
        view = UsersViewSet.as_view({'get': 'list'})
        force_authenticate(request, user=self.user)
        response = view(request)

        self.assertEqual(response.status_code, status.HTTP_403_FORBIDDEN)
        self.assertEqual(response.data, {u'detail': u'You do not have permission to perform this action.'})

    def test_create_user(self):
        view = UsersViewSet.as_view({'post': 'create'})
        request = self.factory.post(reverse('user-list'), self.userData)
        response = view(request)

        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertIsNotNone(response.data)

    def test_update_user(self):
        view = UsersViewSet.as_view({'put': 'update'})
        request = self.factory.put(reverse('user-detail', args=(self.user.pk,)), self.userData, format='json')
        force_authenticate(request, user=self.user)
        response = view(request, pk=self.user.pk)

        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsNotNone(response.data)