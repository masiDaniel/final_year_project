from datetime import timedelta, timezone
from django.db import models
from core.models import CustomUser


# Create your models here.

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
    is_completed = models.BooleanField(default=False)
    def check_completion(self):
        # Check if all medications under this prescription are past their duration
        today = timezone.now().date()
        for med in self.medications.all():
            end_date = med.start_date + timedelta(days=med.duration)
            if today < end_date:
                return False
        return True

    def update_completion_status(self):
        self.is_completed = self.check_completion()
        self.save()



    def __str__(self):
        return f"Prescription for {self.prescribed_to} on {self.date_prescribed.strftime('%Y-%m-%d')}"
    

