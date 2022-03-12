from rest_framework import serializers

from .models import Material, Marks, Company

class MaterialSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Material
        fields = ('material_name', 'image_url')

class MarksSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Marks
        fields = ('material_id', 'mark_name', 'image_url', 'text')

class CompanySerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Company
        fields = ('company_name', 'phone', 'web_link', 'eco', 'materials', 'adress', 'longitude', 'latitude', 'hours')