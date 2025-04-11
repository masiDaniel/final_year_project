from django.db import models
from core.models import CustomUser

# Create your models here.

class Pharmacy(models.Model):
    """
    Stores Information about pharmacies
    """
    user_id = models.ForeignKey(CustomUser, null=True, on_delete=models.CASCADE)
    business_no = models.CharField(max_length=15, default='')

    

    def __str__(self) -> str:
        return self.user_id.get_full_name()