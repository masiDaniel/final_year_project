from rest_framework import serializers
from .models import Medication, MedicationAdherence,  PrescriptionMedication

class MedicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medication
        fields = '__all__'  
    



class PrescriptionMedicationSerializer(serializers.ModelSerializer):
    is_active = serializers.SerializerMethodField()

    class Meta:
        model = PrescriptionMedication
        fields =  [
            'id', 'prescription', 'medication', 'dosage', 'frequency', 'duration',
            'instructions', 'morning', 'afternoon', 'evening', 'created_at', 'is_active'
        ]
    
    def get_is_active(self, obj):
        return obj.is_active


class MedicationAdherenceSerializer(serializers.ModelSerializer):
    class Meta:
        model = MedicationAdherence
        fields = ['id', 'medication', 'date', 'is_taken']