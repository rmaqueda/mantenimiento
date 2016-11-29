from django.contrib import admin
from GoGarage.Service.models import Service
from GoGarage.base_admin import BaseAdmin


class ServiceAdmin(BaseAdmin):
    list_display = ('type', 'description')
    list_filter = ('type',)

    fieldsets = (
        (None, {
            'fields': ('type',
                       'description'),
            'classes': ('wide', )
        }),
    )


admin.site.register(Service, ServiceAdmin)
