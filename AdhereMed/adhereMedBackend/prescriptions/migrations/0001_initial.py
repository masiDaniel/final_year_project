# Generated by Django 5.2 on 2025-04-11 12:50

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='Diagnosis',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('title', models.CharField(max_length=255)),
                ('description', models.TextField(blank=True, null=True)),
                ('date_diagnosed', models.DateTimeField(auto_now_add=True)),
                ('severity', models.CharField(blank=True, max_length=50, null=True)),
                ('follow_up_required', models.BooleanField(default=False)),
                ('notes', models.TextField(blank=True, null=True)),
                ('doctor', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='diagnosed_cases', to=settings.AUTH_USER_MODEL)),
                ('patient', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='diagnoses', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='Prescription',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date_prescribed', models.DateTimeField(auto_now_add=True)),
                ('instructions', models.TextField(blank=True, null=True)),
                ('diagnosis', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='prescriptions', to='prescriptions.diagnosis')),
                ('prescribed_by', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='prescriptions_given', to=settings.AUTH_USER_MODEL)),
                ('prescribed_to', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='prescriptions_received', to=settings.AUTH_USER_MODEL)),
            ],
        ),
    ]
