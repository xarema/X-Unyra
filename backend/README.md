# Backend (Django + DRF) — Couple App

## Quick start (local)

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
cp .env.example .env
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

API base: `http://127.0.0.1:8000/api/`
Admin: `http://127.0.0.1:8000/admin/`

## Auth
- Register: `POST /api/auth/register/`
- Login (JWT): `POST /api/auth/login/` (SimpleJWT)
- Me: `GET /api/auth/me/`

## Smart polling
- Changes feed: `GET /api/sync/changes?since=2026-01-16T10:30:00Z`

## Notes for cPanel deployment
- Use cPanel **Setup Python App** (WSGI)
- Set env vars:
  - `DJANGO_SECRET_KEY`, `DJANGO_DEBUG=0`, `DJANGO_ALLOWED_HOSTS`, `DATABASE_URL`
  - `CORS_ALLOWED_ORIGINS`, `CSRF_TRUSTED_ORIGINS`
- Run migrations via cPanel terminal (if available) or a one-time management command.
