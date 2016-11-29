from django.contrib import admin
from GoGarage.MaintenanceBook.models import MaintenanceBook
from GoGarage.base_admin import BaseAdmin


class MaintenanceBookAdmin(BaseAdmin):
    list_display = ('vehicle', 'local', 'service', 'date', 'price', 'kilometers')
    list_filter = ('vehicle', 'local')

    fieldsets = (
        (None, {
            'fields': ('vehicle',
                       'local',
                       'service',
                       'date',
                       'price',
                       'kilometers'),
            'classes': ('wide', )
        }),
    )


admin.site.register(MaintenanceBook, MaintenanceBookAdmin)
