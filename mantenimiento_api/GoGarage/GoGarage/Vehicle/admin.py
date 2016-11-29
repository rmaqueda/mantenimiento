from django.contrib import admin
from GoGarage.Vehicle.models import Vehicle, VehicleImage
from GoGarage.base_admin import BaseAdmin


class VehicleAdmin(BaseAdmin):
    list_display = ('nick', 'brand', 'model', 'color', 'registrationNumber')
    list_filter = ('nick', 'brand')

    fieldsets = (
        (None, {
            'fields': ('nick',
                       'brand',
                       'model',
                       'color',
                       'registrationNumber',
                       'chassisNumber',
                       'manufacturedDate',
                       'description'),
            'classes': ('wide', )
        }),
    )


class VehicleImageAdmin(BaseAdmin):
    list_display = ('vehicle', 'image')

    fieldsets = (
        (None, {
            'fields': ('vehicle',
                       'image'),
            'classes': ('wide', )
        }),
    )

admin.site.register(Vehicle, VehicleAdmin)
admin.site.register(VehicleImage, VehicleImageAdmin)
