from django.contrib import admin
from .models import CareGiver, Doctor, Patient, Symptom, CustomUser

# Register your models here.
admin.site.register(CareGiver)
admin.site.register(Doctor)
admin.site.register(Patient)
admin.site.register(Symptom)
admin.site.register(CustomUser)
