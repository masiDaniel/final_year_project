from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db.models import Q
from prescriptions.serializers import DiagnosisSerializer, PrescriptionSerializer
from .models import Diagnosis, Prescription
from rest_framework.permissions import IsAuthenticated

# Create your views here.

class DiagnosisAPIView(APIView):
    permission_classes = [IsAuthenticated] 
    def get(self, request):
        queryset = Diagnosis.objects.all()

        # # Optional filtering
        # name = request.query_params.get('name')
        # dosage = request.query_params.get('dosage')
        # search = request.query_params.get('search')

        # if name:
        #     queryset = queryset.filter(name=name)
        # if dosage:
        #     queryset = queryset.filter(dosage=dosage)
        # if search:
        #     queryset = queryset.filter(
        #         Q(name__icontains=search) | Q(description__icontains=search)
        #     )

        serializer = DiagnosisSerializer(queryset, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = DiagnosisSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class PrescriptionAPIView(APIView):
    permission_classes = [IsAuthenticated] 
    def get(self, request):
        queryset = Prescription.objects.all()

        # # Optional filtering
        # name = request.query_params.get('name')
        # dosage = request.query_params.get('dosage')
        # search = request.query_params.get('search')

        # if name:
        #     queryset = queryset.filter(name=name)
        # if dosage:
        #     queryset = queryset.filter(dosage=dosage)
        # if search:
        #     queryset = queryset.filter(
        #         Q(name__icontains=search) | Q(description__icontains=search)
        #     )

        serializer = PrescriptionSerializer(queryset, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = PrescriptionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)