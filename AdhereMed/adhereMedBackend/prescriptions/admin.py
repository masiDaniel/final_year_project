from django.contrib import admin
from .models import Diagnosis, Prescription
# Register your models here.
admin.site.register(Diagnosis)
admin.site.register(Prescription)