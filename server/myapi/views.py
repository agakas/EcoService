from django.shortcuts import render
from rest_framework import viewsets

from .serializers import MaterialSerializer, MarksSerializer, CompanySerializer, LinkSerializer, WareTypeSerializer, WareSerializer
from .models import Material, Marks, Company, Link, WareType, Ware

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

class WareTypeViewSet(viewsets.ModelViewSet):
    queryset = WareType.objects.all().order_by('ware_type')
    serializer_class = WareTypeSerializer

class WareViewSet(viewsets.ModelViewSet):
    queryset = Ware.objects.all().order_by('name_ware')
    serializer_class = WareSerializer
