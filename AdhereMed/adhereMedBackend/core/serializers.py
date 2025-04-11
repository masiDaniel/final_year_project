from rest_framework import serializers
from django.contrib.auth import get_user_model
from .models import Doctor, Patient, CareGiver
from pharmacies.models import Pharmacy


class CustomUserSerializer(serializers.ModelSerializer):
    license_no = serializers.CharField(required=False, allow_blank=True)
    member_no = serializers.CharField(required=False, allow_blank=True)
    business_no = serializers.CharField(required=False, allow_blank=True)


    class Meta:
        model = get_user_model()
        fields = ['username', 'email', 'password', 'user_type', 'license_no', 'member_no', 'business_no']

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

class DoctorSerializer(serializers.ModelSerializer):
    class Meta:
        model = Doctor
        fields = "__all__"

class PatientSerializer(serializers.ModelSerializer):
    class Meta:
        model = Patient
        fields = "__all__"
class CareGiverSerializer(serializers.ModelSerializer):
    class Meta:
        model = CareGiver
        fields = "__all__"

class PharmacySerializer(serializers.ModelSerializer):
    class Meta:
        model = Pharmacy
        fields = "__all__"