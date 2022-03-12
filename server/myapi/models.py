from django.db import models

class Material(models.Model):
    material_name = models.CharField(max_length=30)
    image_url = models.CharField(max_length=250)

    def __str__(self):
        return self.material_name

class Marks(models.Model):
    #CASCADE когда удаленный объект ссылки удаляется, также удаляйте объекты, имеющие ссылки на него
    material_id = models.ForeignKey(Material, on_delete=models.CASCADE)
    mark_name = models.CharField(max_length=30)
    image_url = models.CharField(max_length=250)
    text = models.CharField(max_length=500)

    def __str__(self):
        return self.mark_name

class Company(models.Model):
    company_name =  models.CharField(max_length=30)
    phone =  models.CharField(max_length=30, default='8 800 555 35 35')
    web_link = models.URLField(default='example.com')
    eco =  models.BooleanField()
    materials = models.ManyToManyField(Material)
    adress = models.CharField(max_length=255)
    longitude = models.FloatField()
    latitude = models.FloatField()
    hours = models.CharField(max_length=255)

    def __str__(self):
        return self.company_name

class Link(models.Model):
    id_company = models.ForeignKey(Company, on_delete=models.CASCADE)
    id_material = models.ForeignKey(Material, on_delete=models.CASCADE)

class Ware(models.Model):
    material = models.ForeignKey(Material, on_delete=models.CASCADE)
    barcode = models.CharField(max_length=15)
    name = models.CharField(max_length=100)
    consist = models.CharField(max_length=500)
    notify = models.CharField(max_length=100)
    eco = eco =  models.BooleanField()