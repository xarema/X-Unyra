# Déploiement cPanel (Option A)

> Objectif: déployer vite sans infra “always-on”. Backend Django en WSGI + frontend Flutter Web en fichiers statiques.

## 1) Backend Django (Python / WSGI)

### 1.1 Préparer la DB
- Crée une base **PostgreSQL** ou **MySQL** via cPanel.
- Récupère user / password / host / port.

### 1.2 Déployer le code
- Pousse ce repo sur ton Git (GitHub/GitLab) ou utilise l’outil **Git Version Control** de cPanel.
- Place le backend dans un dossier (ex: `couple-app/backend`).

### 1.3 Setup Python App
- cPanel → **Setup Python App**
- Choisis Python 3.x
- Application root: le dossier `backend/`
- Application start file: `passenger_wsgi.py` (cPanel le génère)

### 1.4 Dépendances
Dans l’environnement Python (venv cPanel), installe:
```bash
pip install -r requirements.txt
```

### 1.5 Variables d’environnement (prod)
À configurer dans cPanel (ou dans `passenger_wsgi.py` si nécessaire):
- `DJANGO_SECRET_KEY` (long)
- `DJANGO_DEBUG=0`
- `DJANGO_ALLOWED_HOSTS=ton-domaine.com`
- `DATABASE_URL=postgres://...` (ou mysql://...)
- `CORS_ALLOWED_ORIGINS=https://ton-domaine.com`
- `CSRF_TRUSTED_ORIGINS=https://ton-domaine.com`

### 1.6 Migrations
```bash
python manage.py migrate
python manage.py createsuperuser
```

### 1.7 Test
- `https://ton-domaine.com/api/auth/me/` (avec token)
- `https://ton-domaine.com/admin/`

## 2) Frontend Flutter Web (fichiers statiques)

### 2.1 Build
```bash
flutter build web
```

### 2.2 Upload
- Uploade le contenu de `build/web/` dans `public_html/` (ou un sous-domaine).

### 2.3 Config URL API
- Mets à jour `frontend/lib/core/config.dart` → `apiBaseUrl=https://ton-domaine.com/api`
- Rebuild web et re-upload.

## 3) Smart polling
- Le frontend appelle `GET /api/sync/changes?since=...`.
- Si trop de charge, augmente l’intervalle à 10–15s.
