# Generated by Django 4.0.3 on 2022-03-12 17:15

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('myapi', '0010_alter_ware_mark'),
    ]

    operations = [
        migrations.AddField(
            model_name='material',
            name='warning',
            field=models.CharField(default='hello', max_length=500),
        ),
    ]
