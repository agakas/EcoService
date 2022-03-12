from django.shortcuts import render
from rest_framework import viewsets

from .serializers import MaterialSerializer
from .models import Material

class MaterialViewSet(viewsets.ModelViewSet):
    queryset = Material.objects.all().order_by('material_name')
    serializer_class = MaterialSerializer

# Create your views here.
