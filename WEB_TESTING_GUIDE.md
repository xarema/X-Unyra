# 🌐 Couple App Web — Guide de Test

**Status:** Web version complète et prête à tester  
**Date:** 16 janvier 2026

---

## 🚀 Démarrer le Test

### 1. **Démarrer le Backend Django**

```bash
cd backend
python manage.py runserver
```

Le backend tournera sur `http://127.0.0.1:8000`

### 2. **Démarrer le Serveur Web**

Dans un autre terminal:

```bash
# Rendre le script exécutable
chmod +x start_web.sh

# Démarrer le serveur web
./start_web.sh
```

Le serveur tournera sur `http://127.0.0.1:8080` (ou le prochain port disponible)

### 3. **Ouvrir dans le Navigateur**

```
http://127.0.0.1:8080
```

---

## 📝 Test Complet (Scénario)

### Étape 1: S'inscrire (User A)
1. Cliquer "S'inscrire"
2. Remplir le formulaire:
   - Username: `alice`
   - Email: `alice@example.com`
   - Password: `TestPass123!`
3. Cliquer "S'inscrire"
4. ✅ Vous êtes redirigé vers "Formation du couple"

### Étape 2: Créer un Couple (User A)
1. Cliquer "Créer un couple"
2. ✅ Un code 6 chiffres est généré (ex: `123456`)
3. Copier/noter le code

### Étape 3: S'inscrire (User B)
1. Cliquer "Se déconnecter" (avatar en haut à droite)
2. Cliquer "S'inscrire"
3. Remplir le formulaire:
   - Username: `bob`
   - Email: `bob@example.com`
   - Password: `TestPass123!`
4. Cliquer "S'inscrire"

### Étape 4: Rejoindre le Couple (User B)
1. Cliquer "Rejoindre un couple"
2. Cliquer "Rejoindre un couple" (le formulaire apparaît)
3. Entrer le code généré (ex: `123456`)
4. Cliquer "Rejoindre"
5. ✅ Vous êtes maintenant appairés!

### Étape 5: Tester les Features

#### 🔷 Q&A (Questions & Réponses)
1. Cliquer sur l'onglet "❓ Q&A"
2. Cliquer "+ Nouvelle question"
3. Entrer une question (ex: "Do you love me?")
4. ✅ La question apparaît dans la liste

#### 🎯 Objectifs
1. Cliquer sur l'onglet "🎯 Objectifs"
2. Cliquer "+ Nouvel objectif"
3. Entrer un titre (ex: "Buy a house")
4. ✅ L'objectif apparaît avec status ACTIVE

#### 💚 Check-ins
1. Cliquer sur l'onglet "💚 Check-in"
2. Cliquer "+ Nouveau check-in"
3. Entrer les valeurs:
   - Mood: 7
   - Stress: 4
   - Energy: 8
4. ✅ Le check-in apparaît avec les stats

#### 💌 Lettres
1. Cliquer sur l'onglet "💌 Lettres"
2. Cliquer "+ Nouvelle lettre"
3. Entrer une réflexion (ex: "This month was amazing!")
4. ✅ La lettre apparaît

---

## 🔐 Authentification

### Comptes de Test

**User A:**
- Email: `alice@example.com`
- Password: `TestPass123!`

**User B:**
- Email: `bob@example.com`
- Password: `TestPass123!`

### Fonctionnement

- Les tokens JWT sont stockés dans `localStorage`
- Les requêtes incluent `Authorization: Bearer <token>`
- Les tokens expirent après 60 minutes
- Un refresh token permet de récupérer un nouveau token

---

## 📊 Architecture Web

```html
┌─────────────────────────────────────┐
│        HTML/CSS/JavaScript          │
│  (Single Page App — index.html)     │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│      API Calls (Fetch API)          │
│  ├─ Auth endpoints                  │
│  ├─ Couple endpoints                │
│  └─ Feature endpoints               │
└──────────────┬──────────────────────┘
               │
┌──────────────▼──────────────────────┐
│   Django Backend (API REST)         │
│  ├─ JWT Authentication              │
│  ├─ Couple Scoping                  │
│  └─ Data Persistence                │
└─────────────────────────────────────┘
```

---

## 🐛 Troubleshooting

### "CORS Error" ou "No 'Access-Control-Allow-Origin'"

**Solution:** Assurez-vous que CORS est configuré dans `backend/couple_backend/settings.py`:

```python
CORS_ALLOWED_ORIGINS = [
    'http://localhost:8080',
    'http://127.0.0.1:8080',
]
```

Puis redémarrez le backend Django.

### "Cannot connect to backend"

**Solution:** 
1. Vérifiez que le backend tourne sur `http://127.0.0.1:8000`
2. Vérifiez que le port 8000 n'est pas bloqué
3. Vérifiez la console du navigateur (F12 → Network) pour les erreurs

### "Invalid token" ou "401 Unauthorized"

**Solution:**
1. Effacer le localStorage: `localStorage.clear()` dans console (F12)
2. Rafraîchir la page (Ctrl+R)
3. Se reconnecter

---

## 🧪 Test API Direct (cURL)

### Register
```bash
curl -X POST http://127.0.0.1:8000/api/auth/register/ \
  -H 'Content-Type: application/json' \
  -d '{
    "username": "alice",
    "email": "alice@example.com",
    "password": "TestPass123!",
    "password_confirm": "TestPass123!"
  }'
```

### Login
```bash
curl -X POST http://127.0.0.1:8000/api/auth/login/ \
  -H 'Content-Type: application/json' \
  -d '{
    "email": "alice@example.com",
    "password": "TestPass123!"
  }'
```

### Create Couple
```bash
curl -X POST http://127.0.0.1:8000/api/couple/create/ \
  -H 'Authorization: Bearer <TOKEN>'
```

---

## 📱 Responsive Design

La web app est responsive et fonctionne sur:
- ✅ Desktop (1920x1080)
- ✅ Tablet (768x1024)
- ✅ Mobile (375x667)

Testez avec F12 → Toggle device toolbar

---

## ✨ Fonctionnalités Implémentées

- ✅ User Registration
- ✅ User Login
- ✅ Couple Creation
- ✅ Couple Pairing (via code)
- ✅ Q&A (Create & List)
- ✅ Goals (Create & List)
- ✅ Check-ins (Create & List with stats)
- ✅ Letters (Create & List)
- ✅ User Profile (avatar + logout)
- ✅ Navigation Tabs
- ✅ Error Handling
- ✅ Responsive UI

---

## 🚀 Déploiement

### Local Testing
```bash
./start_web.sh
# Ouvrir http://127.0.0.1:8080
```

### Production (cPanel)
1. Uploader `web/index.html` dans le dossier public_html
2. Configurer CORS pour le domaine en prod
3. Tester avec le domaine de prod

---

## 📞 Support

Si vous rencontrez des problèmes:
1. Vérifiez les erreurs dans F12 (Console)
2. Vérifiez les logs du backend: `python manage.py runserver`
3. Vérifiez que les deux services (backend + frontend) tournent

---

**Version Web MVP — Prête à Tester!** ✅

