import requests

from rest_framework import serializers

from .models import Material, Marks, Company

class MaterialSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Material
        fields = ('material_name', 'image_url')

class MarksSerializer(serializers.HyperlinkedModelSerializer):
    material_id = MaterialSerializer(many=False)
    class Meta:
        model = Marks
        fields = ('material_id', 'mark_name', 'image_url', 'text')

class CompanySerializer(serializers.HyperlinkedModelSerializer):
    materials = MaterialSerializer(many=True)
    class Meta:
        model = Company
        fields = ('company_name', 'phone', 'web_link', 'eco', 'materials', 'adress', 'longitude', 'latitude', 'hours')