from django.contrib import admin
from .models import Material, Marks, Company, Link, WareType, Ware

# Register your models here.
admin.site.register(Material)
admin.site.register(Marks)
admin.site.register(Company)
admin.site.register(Link)
admin.site.register(WareType)
admin.site.register(Ware)