from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Appointment, Doctor, Patient, CareGiver, Symptom
from pharmacies.models import Pharmacy


class CustomUserSerializer(serializers.ModelSerializer):
    liscense_no = serializers.CharField(required=False, allow_blank=True)
    member_no = serializers.CharField(required=False, allow_blank=True)
    business_no = serializers.CharField(required=False, allow_blank=True)


    class Meta:
        model = get_user_model()
        fields = '__all__'

    def create(self, validated_data):
        # Create the user
        user = get_user_model().objects.create_user(
            username=validated_data['username'],
            email=validated_data['email'],
            password=validated_data['password'],
            user_type=validated_data['user_type']
        )

        # Automatically register as a doctor or patient if the user is a doctor or patient
        if validated_data['user_type'] == 'doctor':
            # Check if the user already has a doctor profile
            doctor, created = Doctor.objects.get_or_create(user_id=user)
            
            # If created is False, it means the doctor already exists, so we update the license_no if needed
            if not created:
                doctor.liscense_no = validated_data.get('license_no', doctor.liscense_no)
                doctor.save()

        elif validated_data['user_type'] == 'patient':
            # Check if the user already has a patient record
            if Patient.objects.filter(user_id=user).exists():
                raise serializers.ValidationError("This user already has a patient profile.")
            
            # Create the patient record, including member_no
            patient = Patient.objects.create(
                user_id=user,
                member_no=validated_data.get('member_no', '')  # Set the member number here
            )

        elif validated_data['user_type'] == 'caregiver':
            # Check if the user already has a patient record
            if CareGiver.objects.filter(user_id=user).exists():
                raise serializers.ValidationError("This user already has a patient profile.")
            
            # Create the patient record, including member_no
            Caregiver = CareGiver.objects.create(
                user_id=user,
                liscense_no=validated_data.get('liscense_no', '')  # Set the member number here
            )

        elif validated_data['user_type'] == 'pharmacy':
            if Pharmacy.objects.filter(user_id=user).exists():
                raise serializers.ValidationError("This user already has a patient profile.")
            
            # Create the patient record, including member_no
            pharmacy = Pharmacy.objects.create(
                user_id=user,
                business_no=validated_data.get('business_no', '')  # Set the member number here
            )

        return user
    def update(self, instance, validated_data):
        # Update CustomUser fields
        for attr, value in validated_data.items():
            if hasattr(instance, attr):
                setattr(instance, attr, value)
        instance.save()

        # Update related profile model based on user_type
        user_type = instance.user_type

        try:
            if user_type == 'doctor':
                license_no = validated_data.get('license_no')
                if license_no:
                    doctor = Doctor.objects.get(user_id=instance)
                    doctor.liscense_no = license_no
                    doctor.save()

            elif user_type == 'patient':
                member_no = validated_data.get('member_no')
                if member_no:
                    patient = Patient.objects.get(user_id=instance)
                    patient.member_no = member_no
                    patient.save()

            elif user_type == 'caregiver':
                license_no = validated_data.get('license_no')
                if license_no:
                    caregiver = CareGiver.objects.get(user_id=instance)
                    caregiver.liscense_no = license_no
                    caregiver.save()

            elif user_type == 'pharmacy':
                business_no = validated_data.get('business_no')
                if business_no:
                    pharmacy = Pharmacy.objects.get(user_id=instance)
                    pharmacy.business_no = business_no
                    pharmacy.save()
        except Exception as e:
            raise serializers.ValidationError(f"Error updating profile: {e}")

        return instance

class DoctorSerializer(serializers.ModelSerializer):
    user_details = serializers.SerializerMethodField()  

    class Meta:
        model = Doctor
        fields = "__all__" 

    def get_user_details(self, obj):
       
        user = obj.user_id
        return CustomUserSerializer(user).data  

class PatientSerializer(serializers.ModelSerializer):
    user_details = serializers.SerializerMethodField()  
    class Meta:
        model = Patient
        fields = "__all__"

    def get_user_details(self, obj):
       
        user = obj.user_id
        return CustomUserSerializer(user).data 
class CareGiverSerializer(serializers.ModelSerializer):
    class Meta:
        model = CareGiver
        fields = "__all__"

class PharmacySerializer(serializers.ModelSerializer):
    class Meta:
        model = Pharmacy
        fields = "__all__"


class SymptomSerializer(serializers.ModelSerializer):
    class Meta:
        model = Symptom
        fields = "__all__"

class AppointmentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Appointment
        fields = '__all__'

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer


class MyTokenObtainPairSerializer(TokenObtainPairSerializer):

    
    def validate(self, attrs):
        data = super().validate(attrs)
        user_data = CustomUserSerializer(self.user).data
        data.update(user_data)

        profile = {}

        try:
            if self.user.user_type == 'doctor':
                profile = {
                    'license_no': self.user.doctor.liscense_no
                }

            elif self.user.user_type == 'patient':
                profile = {
                    'member_no': self.user.patient.member_no
                }

            elif self.user.user_type == 'caregiver':
                profile = {
                    'license_no': self.user.caregiver.license_no
                }

            elif self.user.user_type == 'pharmacy':
                profile = {
                    'business_no': self.user.pharmacy.business_no
                }

        except (Doctor.DoesNotExist, Patient.DoesNotExist, CareGiver.DoesNotExist, Pharmacy.DoesNotExist):
            profile = {}

        data['profile'] = profile
        return data