from django.contrib import admin
from .models import  Medication,PrescriptionMedication

# Register your models here.
admin.site.register(Medication)
admin.site.register(PrescriptionMedication)