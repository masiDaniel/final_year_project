import re
from django.db import models
from prescriptions.models import Prescription
from datetime import  datetime, timedelta, timezone
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

    def __str__(self):
        return f"{self.name}"




class PrescriptionMedication(models.Model):
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE, related_name='medication_items')
    medication = models.ForeignKey(Medication, on_delete=models.CASCADE)
    dosage = models.CharField(max_length=100)
    frequency = models.CharField(max_length=100)
    duration = models.CharField(max_length=100)
    instructions = models.TextField(blank=True, null=True)
    morning = models.BooleanField(default=False)
    afternoon = models.BooleanField(default=False)
    evening = models.BooleanField(default=False)
    
    created_at = models.DateTimeField(auto_now_add=True)

    @property
    def is_active(self):
        end_date = self.get_end_date()
        if end_date is None:
            return True  # If duration is invalid or missing, assume it's active
        return datetime.now().date() <= end_date

    def get_end_date(self):
        """
        Extracts end date from duration.
        Supports "X days", "X weeks", and "X months" (approx 30 days/month).
        have it support inters in days 
        """
        match = re.match(r'(\d+)\s*(day|week|month)s?', self.duration)
        if not match:
            return None
        num, unit = int(match.group(1)), match.group(2)
 
        if unit == 'day':
            delta = timedelta(days=num)
        elif unit == 'week':
            delta = timedelta(weeks=num)
        elif unit == 'month':
            delta = timedelta(days=30 * num)  # approximate
        else:
            return None
 
        return (self.created_at + delta).date()
    
    def __str__(self):
        return f"{self.dosage}"
 


class MedicationAdherence(models.Model):
    medication = models.ForeignKey(PrescriptionMedication, on_delete=models.CASCADE)
    date = models.DateTimeField(auto_now_add=True)
    is_taken = models.BooleanField(default=False)

    def __str__(self):
        return f"Adherence for {self.medication} on {self.date}"