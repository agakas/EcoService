import requests

from rest_framework import serializers

from .models import Material, Marks, Company, Link, WareType, Ware

class MaterialSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Material
        fields = '__all__'

class MarksSerializer(serializers.HyperlinkedModelSerializer):
    material_id = MaterialSerializer(many=False)
    class Meta:
        model = Marks
        fields = '__all__'

class CompanySerializer(serializers.HyperlinkedModelSerializer):
    materials = MaterialSerializer(many=True)
    class Meta:
        model = Company
        fields = ('company_name', 'phone', 'web_link', 'eco', 'materials', 'adress', 'longitude', 'latitude', 'hours')

class LinkSerializer(serializers.HyperlinkedModelSerializer):
    id_company = CompanySerializer(many=False)
    id_material = MaterialSerializer(many=False)
    class Meta:
        model = Link
        fields = ('id_company','id_material')

class WareTypeSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = WareType
        fields = '__all__'

class WareSerializer(serializers.HyperlinkedModelSerializer):
    ware_type = WareTypeSerializer(many=False)
    material = MaterialSerializer(many=False)
    mark = MarksSerializer(many=False)
    class Meta:
        model = Ware
        fields = ('barcode', 'ware_type', 'ware_type', 'consist', 'eco', 'material','mark')