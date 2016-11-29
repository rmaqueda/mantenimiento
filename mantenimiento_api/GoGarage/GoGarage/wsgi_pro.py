import os, sys
from django.core.wsgi import get_wsgi_application

sys.path.append('/Users/ricardomaqueda/Atlassian/ApplicationData/Bamboo/xml-data/build-dir/NODJ-GDM-JOB1/GoGarage/GoGarage/')
sys.path.append('/Users/ricardomaqueda/Atlassian/ApplicationData/Bamboo/xml-data/build-dir/NODJ-GDM-JOB1/GoGarage/')

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "settings_pro")
os.environ['HTTPS'] = "on"

application = get_wsgi_application()