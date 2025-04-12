from django.urls import path
from .views import DiagnosisAPIView, PrescriptionAPIView

urlpatterns = [
     path('diagnosis/', DiagnosisAPIView.as_view(), name='diagnosis-all'),
     path('prescription/', PrescriptionAPIView.as_view(), name='prescription-details'),
    # path('medications/<int:pk>/', MedicationDetailAPIView.as_view(), name='medication-detail'),
]