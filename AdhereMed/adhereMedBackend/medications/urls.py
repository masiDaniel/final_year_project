from django.urls import path
from .views import  MedicationAPIView, MedicationDetailAPIView,PrescriptionMedicationAPIView

urlpatterns = [
     path('medications/', MedicationAPIView.as_view(), name='medication-list-create'),
    path('medications/<int:pk>/', MedicationDetailAPIView.as_view(), name='medication-detail'),
     path('prescriptions/', PrescriptionMedicationAPIView.as_view(), name='prescription-list-create'),
]