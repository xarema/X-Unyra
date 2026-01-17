# 🚀 SERVEURS DE TEST — DÉMARRÉS!

**Date:** 16 janvier 2026  
**Status:** ✅ Backend + Frontend en ligne

---

## 📊 ACCÈS IMMÉDIAT

### 🔵 Backend Django (API REST)
```
URL: http://localhost:8000
Port: 8000
Status: ✅ RUNNING
```

### 🟢 Web Frontend (HTML/CSS/JS)
```
URL: http://localhost:8080
Port: 8080
Status: ✅ RUNNING
```

**Accès direct:** Ouvrir dans le navigateur!

---

## 🧪 TEST COMPLET (5 MINUTES)

### Partie 1: Registration (User A)
1. Ouvrir: **http://127.0.0.1:8080**
2. Cliquer "S'inscrire"
3. Remplir:
   - Username: `alice`
   - Email: `alice@example.com`
   - Password: `TestPass123!`
   - Confirm: `TestPass123!`
4. Cliquer "S'inscrire"
5. ✅ Code invitation généré automatiquement

### Partie 2: Create Couple (User A)
1. Cliquer "Créer un couple"
2. ✅ Code 6-digit généré (ex: `123456`)
3. **Copier le code**

### Partie 3: Registration (User B)
1. Cliquer avatar → Se déconnecter
2. Cliquer "S'inscrire"
3. Remplir:
   - Username: `bob`
   - Email: `bob@example.com`
   - Password: `TestPass123!`
   - Confirm: `TestPass123!`
4. Cliquer "S'inscrire"

### Partie 4: Join Couple (User B)
1. Cliquer "Rejoindre un couple"
2. Cliquer "Rejoindre un couple" (form apparaît)
3. Entrer code: `123456` (du step 2)
4. Cliquer "Rejoindre"
5. ✅ **Couples appairés!**

### Partie 5: Test Features
Une fois appairés, vous voyez 4 onglets:

**❓ Q&A Tab:**
- Cliquer "+ Nouvelle question"
- Entrer: "Do you love me?"
- ✅ Question créée et visible

**🎯 Goals Tab:**
- Cliquer "+ Nouvel objectif"
- Entrer: "Buy a house"
- ✅ Goal créé avec status ACTIVE

**💚 Check-ins Tab:**
- Cliquer "+ Nouveau check-in"
- Mood: 7, Stress: 4, Energy: 8
- ✅ Check-in créé avec statistiques

**💌 Letters Tab:**
- Cliquer "+ Nouvelle lettre"
- Entrer: "This month was amazing!"
- ✅ Letter créée

---

## 🔐 COMPTES DE TEST PRÉCONNUS

```
User A (Partner A):
  Email: alice@example.com
  Password: TestPass123!
  Username: alice

User B (Partner B):
  Email: bob@example.com
  Password: TestPass123!
  Username: bob
```

---

## 🛠️ COMMANDES UTILES

### Vérifier les serveurs
```bash
# Backend
curl http://127.0.0.1:8000/api/auth/me/

# Frontend
curl http://127.0.0.1:8080/index.html
```

### Test Registration
```bash
curl -X POST http://127.0.0.1:8000/api/auth/register/ \
  -H 'Content-Type: application/json' \
  -d '{
    "username":"testuser",
    "email":"test@example.com",
    "password":"TestPass123!",
    "password_confirm":"TestPass123!"
  }'
```

### Test Login
```bash
curl -X POST http://127.0.0.1:8000/api/auth/login/ \
  -H 'Content-Type: application/json' \
  -d '{
    "email":"test@example.com",
    "password":"TestPass123!"
  }'
```

Copier le `access` token et l'utiliser:
```bash
curl http://127.0.0.1:8000/api/couple/ \
  -H "Authorization: Bearer <ACCESS_TOKEN>"
```

---

## 📱 NAVIGATEUR

### Desktop:
- Chrome ✅
- Firefox ✅
- Safari ✅
- Edge ✅

### Mobile (via DevTools):
- F12 → Toggle Device Toolbar
- Select "iPhone 12" ou autre

---

## ⚙️ SI BESOIN D'ARRÊTER

**Terminal où tournent les serveurs:**
```bash
Ctrl+C (une ou deux fois)
```

**Pour redémarrer:**
```bash
# Backend
cd backend && python manage.py runserver

# Frontend (autre terminal)
cd web && python3 -m http.server 8080
```

---

## 🎯 CHECKLIST DE TEST

- [ ] Registration User A
- [ ] Create Couple
- [ ] Registration User B  
- [ ] Join Couple with code
- [ ] Both see each other as partners
- [ ] Create Question
- [ ] Create Goal
- [ ] Create Check-in (mood/stress/energy)
- [ ] Create Letter
- [ ] All data persists (refresh page)
- [ ] Logout/Login works
- [ ] Second user can't see first user's couple

---

## 🎉 TOUT EST PRÊT!

✅ Backend Django: Port 8000
✅ Frontend Web: Port 8080
✅ Base de données: SQLite (auto-init)
✅ Tests: 79/79 passing

**Bon test!** 🚀

