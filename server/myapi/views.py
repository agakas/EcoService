from django.shortcuts import render
from rest_framework import viewsets

from .serializers import MaterialSerializer, MarksSerializer, CompanySerializer, LinkSerializer, WareSerializer
from .models import Material, Marks, Company, Link, Ware

class MaterialViewSet(viewsets.ModelViewSet):
    queryset = Material.objects.all().order_by('material_name')
    serializer_class = MaterialSerializer

class MarksViewSet(viewsets.ModelViewSet):
    queryset = Marks.objects.all().order_by('mark_name')
    serializer_class = MarksSerializer

class CompanyViewSet(viewsets.ModelViewSet):
    queryset = Company.objects.all().order_by('company_name')
    serializer_class = CompanySerializer

class LinkViewSet(viewsets.ModelViewSet):
    queryset = Link.objects.all().order_by('id_material')
    serializer_class = LinkSerializer