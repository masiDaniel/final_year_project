from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db.models import Q
from .models import Medication, MedicationAdherence, PrescriptionMedication
from .serializers import MedicationAdherenceSerializer, MedicationSerializer, PrescriptionMedicationSerializer
from rest_framework.generics import get_object_or_404

class MedicationAPIView(APIView):
    def get(self, request):
        queryset = Medication.objects.all()

        # Optional filtering
        name = request.query_params.get('name')
        dosage = request.query_params.get('dosage')
        search = request.query_params.get('search')

        if name:
            queryset = queryset.filter(name=name)
        if dosage:
            queryset = queryset.filter(dosage=dosage)
        if search:
            queryset = queryset.filter(
                Q(name__icontains=search) | Q(description__icontains=search)
            )

        serializer = MedicationSerializer(queryset, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = MedicationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class MedicationDetailAPIView(APIView):
    def get_object(self, pk):
        return get_object_or_404(Medication, pk=pk)

    def get(self, request, pk):
        medication = self.get_object(pk)
        serializer = MedicationSerializer(medication)
        return Response(serializer.data)

    def patch(self, request, pk):
        medication = self.get_object(pk)
        serializer = MedicationSerializer(medication, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        medication = self.get_object(pk)
        medication.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)



class PrescriptionMedicationAPIView(APIView):
    def get(self, request):
        queryset = PrescriptionMedication.objects.all()
        serializer = PrescriptionMedicationSerializer(queryset, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = PrescriptionMedicationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class MedicationAdherenceAPIView(APIView):

    # Mark medication as taken
    def post(self, request, medication_id=None):
        try:
            # Get the medication object
            medication = Medication.objects.get(id=medication_id)
            
            # Create an adherence record
            adherence = MedicationAdherence.objects.create(
                medication=medication,
                is_taken=True  # Mark as taken
            )

            # Return the created adherence record in the response
            return Response(MedicationAdherenceSerializer(adherence).data, status=status.HTTP_201_CREATED)
        
        except Medication.DoesNotExist:
            return Response({"error": "Medication not found"}, status=status.HTTP_404_NOT_FOUND)

    # Calculate medication adherence percentage
    def get(self, request, medication_id=None):
        try:
            # Get the medication object
            medication = Medication.objects.get(id=medication_id)

            # Calculate total doses and doses taken
            total_doses = MedicationAdherence.objects.filter(medication=medication).count()
            doses_taken = MedicationAdherence.objects.filter(medication=medication, is_taken=True).count()

            # Calculate adherence percentage
            adherence_percentage = (doses_taken / total_doses) * 100 if total_doses else 0

            # Return adherence percentage in the response
            return Response({'adherence_percentage': adherence_percentage}, status=status.HTTP_200_OK)
        
        except Medication.DoesNotExist:
            return Response({"error": "Medication not found"}, status=status.HTTP_404_NOT_FOUND)