from django.contrib import admin

class BaseAdmin(admin.ModelAdmin):

    def save_model(self, request, obj, form, change):
            obj.created_by = request.user
            obj.save()
