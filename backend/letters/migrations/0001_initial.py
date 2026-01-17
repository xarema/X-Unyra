from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('couples', '0001_initial'),
    ]

    operations = [
        migrations.CreateModel(
            name='Letter',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('month', models.CharField(max_length=7)),
                ('content', models.TextField(blank=True, default='')),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('updated_at', models.DateTimeField(auto_now=True, db_index=True)),
                ('couple', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='letters', to='couples.couple')),
            ],
            options={
                'ordering': ['-month'],
            },
        ),
        migrations.AddConstraint(
            model_name='letter',
            constraint=models.UniqueConstraint(fields=('couple', 'month'), name='uniq_letter_per_month'),
        ),
    ]
