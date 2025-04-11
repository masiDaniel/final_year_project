from django.db import models
from core.models import CustomUser
# Create your models here.
class Medication(models.Model):
    name = models.CharField(max_length=100)  # e.g., Paracetamol
    generic_name = models.CharField(max_length=100, blank=True, null=True)  # e.g., Acetaminophen
    brand_name = models.CharField(max_length=100, blank=True, null=True)  # e.g., Tylenol
    description = models.TextField(blank=True, null=True)

    dosage_form = models.CharField(max_length=50)  # e.g., tablet, capsule, syrup
    strength = models.CharField(max_length=50)  # e.g., 500 mg
    route_of_administration = models.CharField(max_length=50)  # e.g., oral, intravenous

    side_effects = models.TextField(blank=True, null=True)
    interactions = models.TextField(blank=True, null=True)
    contraindications = models.TextField(blank=True, null=True)

    manufacturer = models.CharField(max_length=100, blank=True, null=True)
    approval_date = models.DateField(blank=True, null=True)
    expiry_date = models.DateField(blank=True, null=True)

    requires_prescription = models.BooleanField(default=True)
    stock_quantity = models.IntegerField(default=0)
    price = models.DecimalField(max_digits=10, decimal_places=2)

    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Diagnosis(models.Model):
    patient = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='diagnoses')  # assuming User is a patient
    doctor = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='diagnosed_cases')  # assuming User is a doctor
    title = models.CharField(max_length=255)  # e.g., "Malaria", "Hypertension"
    description = models.TextField(blank=True, null=True)
    date_diagnosed = models.DateTimeField(auto_now_add=True)

    # optional
    severity = models.CharField(max_length=50, blank=True, null=True)  # e.g., mild, moderate, severe
    follow_up_required = models.BooleanField(default=False)
    notes = models.TextField(blank=True, null=True)

    def __str__(self):
        return f"{self.title} - {self.patient}"

class Prescription(models.Model):
    diagnosis = models.ForeignKey(Diagnosis, on_delete=models.CASCADE, related_name='prescriptions')
    prescribed_by = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='prescriptions_given')  # doctor
    prescribed_to = models.ForeignKey(CustomUser, on_delete=models.CASCADE, related_name='prescriptions_received')  # patient

    date_prescribed = models.DateTimeField(auto_now_add=True)
    instructions = models.TextField(blank=True, null=True)  # general instructions

    def __str__(self):
        return f"Prescription for {self.prescribed_to} on {self.date_prescribed.strftime('%Y-%m-%d')}"


class PrescriptionMedication(models.Model):
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE, related_name='medication_items')
    medication = models.ForeignKey(Medication, on_delete=models.CASCADE)
    dosage = models.CharField(max_length=100)
    frequency = models.CharField(max_length=100)
    duration = models.CharField(max_length=100)
    instructions = models.TextField(blank=True, null=True)