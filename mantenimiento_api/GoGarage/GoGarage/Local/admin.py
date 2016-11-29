from django.contrib import admin
from GoGarage.Local.models import Local
from GoGarage.base_admin import BaseAdmin


class LocalAdmin(BaseAdmin):
    list_display = ('name', 'contact', 'telephone', 'address', 'latitude', 'longitude', 'description')
    list_filter = ('name', 'contact')

    fieldsets = (
        (None, {
            'fields': ('name',
                       'contact',
                       'telephone',
                       'address',
                       'latitude',
                       'longitude',
                       'description'),
            'classes': ('wide', )
        }),
    )


admin.site.register(Local, LocalAdmin)
