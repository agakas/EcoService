import requests

from rest_framework import serializers

from .models import Material, Marks, Company, Link, WareType, Ware

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

class LinkSerializer(serializers.HyperlinkedModelSerializer):
    id_company = CompanySerializer(many=True)
    id_material = MaterialSerializer(many=True)
    class Meta:
        model = Link
        fields = ('id_company','id_material')

class WareTypeSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = WareType
        fields = ('ware_type')

class WareSerializer(serializers.HyperlinkedModelSerializer):
    ware_type = WareTypeSerializer(many=False)
    material = MaterialSerializer(many=False)
    mark = MarksSerializer(many=False)
    class Meta:
        model = Ware
        fields = ('barcode', 'name_ware', 'ware_type', 'consist', 'eco', 'material', 'mark')