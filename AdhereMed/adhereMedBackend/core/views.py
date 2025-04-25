from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status

from AImodel.predictor import predict_disease
from .serializers import AppointmentSerializer, CustomUserSerializer, DoctorSerializer, MyTokenObtainPairSerializer, PatientSerializer, SymptomSerializer
from .models import Appointment, CareGiver, Doctor, Patient, Symptom
from pharmacies.models import Pharmacy
from django.conf import settings
from django.apps import apps
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.tokens import RefreshToken

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


class ProfileUpdateView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        serializer = CustomUserSerializer(user)
        return Response(serializer.data)

    def put(self, request):
        user = request.user
        serializer = CustomUserSerializer(user, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request):
        user = request.user
        serializer = CustomUserSerializer(user, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# class UserLoginAPIView(APIView):
#     def post(self, request, *args, **kwargs):
#         email = request.data.get('email')
#         password = request.data.get('password')

#         if email is None or password is None:
#             return Response({'error': 'Please provide both email and password'},
#                             status=status.HTTP_400_BAD_REQUEST)

#         user = authenticate(request, email=email, password=password)

#         if not user:
#             return Response({'error': 'Invalid Credentials'},
#                             status=status.HTTP_401_UNAUTHORIZED)

#         token, created = Token.objects.get_or_create(user=user)

#         return Response({
#             'token': token.key,
#             'user_id': user.id,
#             'user_type': user.user_type,
#             'message': 'Login successful!'
#         }, status=status.HTTP_200_OK)

class MyTokenObtainPairView(TokenObtainPairView):
    serializer_class = MyTokenObtainPairSerializer


class DoctorAPIView(APIView):
    permission_classes = [IsAuthenticated] 

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
    permission_classes = [IsAuthenticated] 

    def get(self, request, *args, **kwargs):
        # Get all doctors
        patient = Patient.objects.all()
        serializer = PatientSerializer(patient, many=True)
        return Response(serializer.data)

class PatientUpdateAPIView(APIView):
    permission_classes = [IsAuthenticated] 
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
    permission_classes = [IsAuthenticated] 
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



class SymptomAPIView(APIView):
    permission_classes = [IsAuthenticated] 

    def get(self, request):
        # symptoms = Symptom.objects.filter(user=request.user).order_by('-created_at')
        symptoms = Symptom.objects.all()
        serializer = SymptomSerializer(symptoms, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = SymptomSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # attach current user refactor on this
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class AppointmentAPIView(APIView):
    permission_classes = [IsAuthenticated] 

    def get(self, request):
        # symptoms = Symptom.objects.filter(user=request.user).order_by('-created_at')
        appointment = Appointment.objects.all()
        serializer = AppointmentSerializer(appointment, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    def post(self, request):
        serializer = AppointmentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()  # attach current user refactor on this
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data["refresh"]
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response(status=status.HTTP_205_RESET_CONTENT)
        except Exception as e:
            return Response(status=status.HTTP_400_BAD_REQUEST)



class DiseasePredictionView(APIView):
    def post(self, request):
        try:
            symptoms_raw = request.data.get('symptoms')  # This could be a list of strings or a string with commas
            non_text = request.data.get('non_text_data')  # List of non-text arrays

            if not symptoms_raw or not non_text:
                return Response({'error': 'symptoms and non_text_data are required'}, status=status.HTTP_400_BAD_REQUEST)

            # Clean and normalize symptoms
            cleaned_symptoms = []
            
            if isinstance(symptoms_raw, str):
                # If it's a single string like "cough, headache", split it
                cleaned_symptoms = [s.strip().lower() for s in symptoms_raw.split(",") if s.strip()]
            elif isinstance(symptoms_raw, list):
                for item in symptoms_raw:
                    if isinstance(item, str):
                        cleaned_symptoms.extend([s.strip().lower() for s in item.split(",") if s.strip()])
            else:
                return Response({'error': 'Invalid symptoms format'}, status=status.HTTP_400_BAD_REQUEST)

            # Now send cleaned symptoms to your prediction function
            predictions = predict_disease(cleaned_symptoms, non_text)
            return Response(predictions, status=status.HTTP_200_OK)

        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
