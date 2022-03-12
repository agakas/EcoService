from rest_framework import serializers

from .models import Material

class MaterialSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Material
        fields = ('material_name', 'image_url')