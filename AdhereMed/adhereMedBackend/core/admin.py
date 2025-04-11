from django.contrib import admin
from .models import CareGiver, Doctor, Patient

# Register your models here.
admin.site.register(CareGiver)
admin.site.register(Doctor)
admin.site.register(Patient)
