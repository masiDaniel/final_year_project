from django.urls import path
from .views import  MedicationAPIView, MedicationDetailAPIView,MedicationAdherenceAPIView, PrescriptionMedicationAPIView

urlpatterns = [
     path('medications/', MedicationAPIView.as_view(), name='medication-list-create'),
    path('medications/<int:pk>/', MedicationDetailAPIView.as_view(), name='medication-detail'),
     path('prescriptions/', PrescriptionMedicationAPIView.as_view(), name='prescription-list-create'),
      path('medication/<int:medication_id>/mark_as_taken/', MedicationAdherenceAPIView.as_view(), name='mark_medication_taken'),
    path('medication/<int:medication_id>/calculate_adherence/', MedicationAdherenceAPIView.as_view(), name='calculate_adherence'),
]