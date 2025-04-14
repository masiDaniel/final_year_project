from django.db import models
from django.contrib.auth.models import AbstractUser, AbstractBaseUser
from django.forms import ValidationError


# Create your models here.
class CustomUser(AbstractUser):
    email = models.EmailField(unique=True)
    id_number = models.IntegerField(default=0)
    phone_number = models.CharField(max_length=15, default='')
    profile_pic = models.ImageField(null=True)
    passport_pic = models.ImageField(null=True)
    id_scan = models.ImageField(null=True)
    USER_TYPES = (('doctor', 'Doctor'), ('patient', 'Patient'), ('caregiver', 'Caregiver'),  ('pharmacy', 'Pharmacy'))
    user_type = models.CharField(max_length=10, choices=USER_TYPES, default='patient')


    def __str__(self):
        return f"{self.username}"


class Doctor(models.Model):
    """
    Stores Information about doctors
    """
    user_id = models.OneToOneField(CustomUser, null=True, on_delete=models.CASCADE, unique=True)
    liscense_no = models.CharField(max_length=15, default='')

    def __str__(self) -> str:
        return self.user_id.get_full_name()
    

class Patient(models.Model):
    """
    Stores Information about patients
    """
    user_id = models.OneToOneField(CustomUser, null=True, on_delete=models.CASCADE, unique=True)
    member_no = models.CharField(max_length=15, default='')
    

    def __str__(self) -> str:
        return self.user_id.get_full_name()


class CareGiver(models.Model):
    """
    Stores Information about caregivers
    """
    user_id = models.ForeignKey(CustomUser, null=True, on_delete=models.CASCADE)
    liscense_no = models.CharField(max_length=15, default='')


    def __str__(self) -> str:
        return self.user_id.get_full_name()
    

class Symptom(models.Model):
    user = models.ForeignKey(CustomUser, null=True, on_delete=models.CASCADE)
    
    main_symptom = models.CharField(max_length=255)
    duration = models.CharField(max_length=100, help_text="e.g., 2 days, 1 week")
    severity = models.CharField(max_length=50, choices=[
        ('mild', 'Mild'),
        ('moderate', 'Moderate'),
        ('severe', 'Severe')
    ])
    allergies = models.TextField(blank=True, help_text="Any known allergies")
    travel_history = models.TextField(blank=True, help_text="Recent travel history if any")
    additional_description = models.TextField(blank=True)
    
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username}'s symptom - {self.main_symptom} ({self.created_at.date()})"


class Appointment(models.Model):
    STATUS_CHOICES = [
        ('pending', 'Pending'),
        ('confirmed', 'Confirmed'),
        ('cancelled', 'Cancelled'),
        ('completed', 'Completed'),
    ]
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    date = models.DateField()
    time = models.TimeField()
    reason = models.TextField(blank=True, null=True)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='pending')
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Appointment with Dr. {self.doctor} on {self.date} at {self.time}"