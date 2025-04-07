from django.urls import path
from .views import DoctorAPIView

urlpatterns = [
    path('doctor/', DoctorAPIView.as_view(), name='doctor-list'),  # List and create
    path('doctor/<int:pk>/', DoctorAPIView.as_view(), name='doctor-detail'),  # Update and delete
]
