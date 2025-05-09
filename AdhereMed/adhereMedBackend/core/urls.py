from django.urls import path
from .views import DiseasePredictionView, DoctorAPIView, DoctorUpdateAPIView, PatientUpdateAPIView, ProfileUpdateView, SymptomAPIView, UserRegistrationAPIView, PatientAPIView, AppointmentAPIView

urlpatterns = [
    path('doctor/', DoctorAPIView.as_view(), name='doctor-list'),  # List and create
    path('patient/', PatientAPIView.as_view(), name='patient-list'),  # List and create
    path('patients/<int:pk>/', PatientUpdateAPIView.as_view(), name='patient-update'),
     path('doctors/<int:pk>/', DoctorUpdateAPIView.as_view(), name='doctor-update'),
    path('doctor/<int:pk>/', DoctorAPIView.as_view(), name='doctor-detail'),  # Update and delete
    path('register/', UserRegistrationAPIView.as_view(), name='register'),
    path('symptoms/', SymptomAPIView.as_view(), name='symptoms'),
    path('appointment/', AppointmentAPIView.as_view(), name='appointments'),
     path('profile/', ProfileUpdateView.as_view(), name='profile'),
      path('predict/', DiseasePredictionView.as_view(), name='predict_disease'),

]
