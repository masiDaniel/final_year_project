from django.db import IntegrityError
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from django.contrib.auth.models import User
from .serializers import DoctorSerializer
from .models import Doctor
from django.contrib.auth import get_user_model
from django.db import IntegrityError, transaction

# Create your views here.
# Doctor API view
class DoctorAPIView(APIView):
  

    def get(self, request, *args, **kwargs):
        # Get all doctors
        doctors = Doctor.objects.all()
        serializer = DoctorSerializer(doctors, many=True)
        return Response(serializer.data)

    def post(self, request, *args, **kwargs):
        """
        Create a new doctor by creating a user and linking it to the doctor.
        """
        data = request.data

        # Ensure 'username' and 'password' are provided for creating a user
        if 'username' not in data or 'password' not in data:
            return Response({"detail": "Username and password are required to create a user."}, status=status.HTTP_400_BAD_REQUEST)

        # Create the user
        try:
            # Begin a transaction block
            with transaction.atomic():
                # Create the user
                user = User.objects.create_user(
                    username=data['username'],
                    password=data['password'],
                )

                # Now that the user is created, add the doctor
                data['user'] = user.id  # Link the doctor to the newly created user
                serializer = DoctorSerializer(data=data)

                if serializer.is_valid():
                    serializer.save()  # Save the doctor
                    return Response(serializer.data, status=status.HTTP_201_CREATED)
                else:
                    # If doctor creation fails, the transaction will be rolled back
                    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        except IntegrityError:
            # This will be raised if there is any issue with the database (e.g., unique constraint violation)
            return Response({"detail": "A user with this username already exists."}, status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            # Catch any other exceptions and rollback the transaction
            return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    
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

    def delete(self, request, *args, **kwargs):
        # Delete a doctor
        try:
            doctor = Doctor.objects.get(pk=kwargs['pk'])
            doctor.delete()
            return Response({"detail": "Deleted successfully."}, status=status.HTTP_204_NO_CONTENT)
        except Doctor.DoesNotExist:
            return Response({"detail": "Not found."}, status=status.HTTP_404_NOT_FOUND)