from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.utils import timezone
from datetime import timedelta
from .models import Prescription
from medications.models import PrescriptionMedication

@receiver([post_save, post_delete], sender=PrescriptionMedication)
def update_prescription_completion(sender, instance, **kwargs):
    prescription = instance.prescription
    today = timezone.now().date()

    all_completed = True
    for med in prescription.medication_items.all():  # using the related_name
        end_date = med.created_at.date() + timedelta(days=med.duration)
        if today < end_date:
            all_completed = False
            break

    prescription.is_completed = all_completed
    prescription.save()