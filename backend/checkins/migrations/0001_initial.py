from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('couples', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.CreateModel(
            name='CheckIn',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('mood', models.IntegerField(default=5)),
                ('stress', models.IntegerField(default=5)),
                ('energy', models.IntegerField(default=5)),
                ('note', models.TextField(blank=True, default='')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True, db_index=True)),
                ('couple', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='checkins', to='couples.couple')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='checkins', to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'ordering': ['-date'],
            },
        ),
        migrations.AddConstraint(
            model_name='checkin',
            constraint=models.UniqueConstraint(fields=('couple', 'user', 'date'), name='uniq_checkin_per_day'),
        ),
    ]
