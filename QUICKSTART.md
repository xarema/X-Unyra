# ⚡ Quick Start - 5 minutes

Tester Couple App en 5 minutes!

## 📋 Prérequis

- Python 3.9+ installé
- Terminal/Console accessible

## 🚀 Démarrage

### 1️⃣ Cloner & Installer Backend (2 min)

```bash
git clone https://github.com/yourusername/couple-app.git
cd couple-app/backend

# Créer environnement virtuel
python3 -m venv .venv
source .venv/bin/activate  # Mac/Linux
# .venv\Scripts\activate  # Windows

# Installer dépendances
pip install -r requirements.txt

# Migrations
python manage.py migrate

# Créer le couple de test
python force_create_couple.py
```

### 2️⃣ Lancer le Backend (1 min)

```bash
python manage.py runserver 0.0.0.0:8000
```

Vous devriez voir:
```
Starting development server at http://0.0.0.0:8000/
```

✅ Backend prêt!

### 3️⃣ Tester l'API (2 min)

Ouvrez un NOUVEAU terminal:

```bash
cd couple-app
bash test_api_complete.sh
```

Vous verrez:
- ✅ Login Alice réussi
- ✅ Alice voit son couple avec Bob
- ✅ Login Bob réussi
- ✅ Bob voit son couple avec Alice

## 🎉 C'est fait!

L'API Couple App est **totalement fonctionnelle**!

## 📱 Tester le Frontend (Optionnel)

```bash
cd couple-app/frontend
flutter pub get
flutter run -d chrome
```

Identifiants de test:
- **Email**: alice@example.com
- **Password**: testpass123

## 📝 Points Clés

| Endpoint | URL | Résultat |
|----------|-----|---------|
| API Racine | http://localhost:8000 | Message de bienvenue JSON |
| Login | POST /api/auth/login | Tokens JWT |
| Couple | GET /api/couple | Infos du couple |

## ❓ Problèmes?

### Port 8000 déjà utilisé?
```bash
pkill -f "python.*runserver"
python manage.py runserver 0.0.0.0:8000
```

### Pas de dépendances?
```bash
pip install -r requirements.txt
```

### Erreur "db.sqlite3"?
```bash
python manage.py migrate
```

## 🔗 Documentation Complète

Voir [README.md](README.md) pour la documentation complète!

---

**Vous êtes prêt! Commencez à développer! 🚀**
