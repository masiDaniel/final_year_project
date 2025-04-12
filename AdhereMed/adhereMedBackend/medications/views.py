from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db.models import Q
from .models import Medication, PrescriptionMedication
from .serializers import MedicationSerializer, PrescriptionMedicationSerializer
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