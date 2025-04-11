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
    user_type = models.CharField(max_length=10, choices=USER_TYPES, default='tenant')


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
    
