from settings import *

# Secure proxy SSL
SECURE_PROXY_SSL_HEADER = ('HTTP_X_FORWARDED_PROTO', 'https')
SESSION_COOKIE_SECURE = True
CSRF_COOKIE_SECURE = True
SESSION_EXPIRE_AT_BROWSER_CLOSE = True
os.environ['wsgi.url_scheme'] = 'https'


DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'gogarage',
        'USER': 'gogarage',
        'PASSWORD': 'tt3133316r',
        'HOST': 'localhost',
        'PORT': '',
    }
}

STATIC_ROOT = '/Users/ricardomaqueda/Atlassian/ApplicationData/Bamboo/xml-data/build-dir/NODJ-GDM-JOB1/GoGarage/static/'
MEDIA_ROOT = '/Users/ricardomaqueda/Atlassian/ApplicationData/Bamboo/xml-data/build-dir/NODJ-GDM-JOB1/GoGarage/media/'
