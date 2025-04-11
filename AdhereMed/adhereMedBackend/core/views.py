from django.db import IntegrityError
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from .serializers import CustomUserSerializer, DoctorSerializer, PatientSerializer
from .models import CareGiver, Doctor, Patient
from pharmacies.models import Pharmacy
from django.db import IntegrityError, transaction
from django.conf import settings
from django.apps import apps

# Create your views here.
# Doctor API view




class UserRegistrationAPIView(APIView):
    def post(self, request, *args, **kwargs):
        serializer = CustomUserSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()

            # Check if the user is a doctor and automatically register them
            if user.user_type == 'doctor':
                # Check if the doctor profile already exists
                doctor, created = Doctor.objects.get_or_create(user_id=user)
                
                # If the doctor already exists, update the license number if provided
                if not created:
                    doctor.liscense_no = request.data.get('license_no', doctor.liscense_no)
                    doctor.save()
            elif user.user_type == 'patient':
                # Check if the doctor profile already exists
                patient, created = Patient.objects.get_or_create(user_id=user)
                
                # If the doctor already exists, update the license number if provided
                if not created:
                    patient.member_no = request.data.get('member_no', patient.member_no)
                    patient.save()

            elif user.user_type == 'caregiver':
                # Check if the doctor profile already exists
                caregiver, created = CareGiver.objects.get_or_create(user_id=user)
                
                # If the doctor already exists, update the license number if provided
                if not created:
                    caregiver.liscense_no = request.data.get('liscense_no', caregiver.liscense_no)
                    caregiver.save()
            
            elif user.user_type == 'pharmacy':
                # Check if the doctor profile already exists
                pharmacy, created = Pharmacy.objects.get_or_create(user_id=user)
                
                # If the doctor already exists, update the license number if provided
                if not created:
                    pharmacy.business_no = request.data.get('buiness_no', pharmacy.business_no)
                    pharmacy.save()

            return Response({'message': 'User registered successfully!'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class DoctorAPIView(APIView):

    def get(self, request, *args, **kwargs):
        # Get all doctors
        doctors = Doctor.objects.all()
        serializer = DoctorSerializer(doctors, many=True)
        return Response(serializer.data)

    
    def put(self, request, *args, **kwargs):
        # Update an existing doctor
        try:
            doctor = Doctor.objects.get(pk=kwargs['pk'])
        except Doctor.DoesNotExist:
            return Response({"detail": "Not found."}, status=status.HTTP_404_NOT_FOUND)

        serializer = DoctorSerializer(doctor, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class PatientAPIView(APIView):

    def get(self, request, *args, **kwargs):
        # Get all doctors
        patient = Patient.objects.all()
        serializer = PatientSerializer(patient, many=True)
        return Response(serializer.data)

class PatientUpdateAPIView(APIView):
    def patch(self, request, *args, **kwargs):
        # Try to fetch the patient based on the provided primary key
        try:
            patient = Patient.objects.get(pk=kwargs['pk'])
        except Patient.DoesNotExist:
            return Response({"detail": "Not found."}, status=status.HTTP_404_NOT_FOUND)

        # Use the appropriate serializer for the Patient model
        serializer = PatientSerializer(patient, data=request.data, partial=True)

        # Check if the serializer data is valid
        if serializer.is_valid():
            serializer.save()  # Save the updated patient record
            return Response(serializer.data)  # Return the updated patient data
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class DoctorUpdateAPIView(APIView):
    def patch(self, request, *args, **kwargs):
        # Try to fetch the patient based on the provided primary key
        try:
            doctor = Doctor.objects.get(pk=kwargs['pk'])
        except Doctor.DoesNotExist:
            return Response({"detail": "Not found."}, status=status.HTTP_404_NOT_FOUND)

        # Use the appropriate serializer for the Patient model
        serializer = DoctorSerializer(doctor, data=request.data, partial=True)

        # Check if the serializer data is valid
        if serializer.is_valid():
            serializer.save()  # Save the updated patient record
            return Response(serializer.data)  # Return the updated patient data
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
