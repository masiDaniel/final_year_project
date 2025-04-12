from rest_framework import serializers
from .models import Medication,  PrescriptionMedication

class MedicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medication
        fields = '__all__'  
    



class PrescriptionMedicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = PrescriptionMedication
        fields = '__all__'
