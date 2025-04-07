from django.db import models
from django.contrib.auth import get_user_model

# Create your models here.
class Doctor(models.Model):
    user = models.OneToOneField(get_user_model(), on_delete=models.CASCADE)
    license = models.CharField()

    def __str__(self):
        return f"Dr. {self.user.get_full_name()}"