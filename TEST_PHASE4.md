# QUICK START — Test Phase 4 Frontend

**Objective**: Tester l'authentification et l'appairage du couple en Flutter  
**Time**: 10 minutes  
**Difficulty**: Easy  

---

## ✅ Prerequisites

- Backend Django en cours d'exécution (`http://localhost:8000`)
- Flutter SDK installé
- Chrome ou Android emulator disponible

---

## 🚀 Step 1: Démarrer le Backend

**Terminal 1:**
```bash
cd /Users/alexandre/Apps/couple-app-starter/backend
python3 manage.py runserver 0.0.0.0:8000
```

**Expected Output:**
```
Watching for file changes with StatReloader
Performing system checks...
System check identified no issues (0 silenced).
Starting development server at http://127.0.0.1:8000/
Quit the server with CONTROL-C.
```

---

## 📱 Step 2: Démarrer le Frontend

**Terminal 2:**
```bash
cd /Users/alexandre/Apps/couple-app-starter/frontend
flutter run -d chrome
```

**Expected Output:**
```
Launching lib/main.dart on Chrome in debug mode...
...
Application finished.
The web app is now available at http://localhost:PORT (check console)
```

Le navigateur devrait s'ouvrir automatiquement. Si non, ouvrez: **http://localhost:8000** (port peut varier)

---

## 🧪 Test Scenario 1: Login Existing User

### 1. Vous êtes sur LoginScreen

```
┌──────────────────────┐
│   Couple App         │
│                      │
│ Email: [________]    │
│ Password: [_______]  │
│                      │
│ [ Se connecter ]     │
│ Pas encore compte?   │
└──────────────────────┘
```

### 2. Entrez Alice's credentials:
- Email: `alice@example.com`
- Password: `TestPass123!`

### 3. Cliquez "Se connecter"

**Expected**: 
- ✅ Loading spinner apparaît
- ✅ Aucune erreur affichée
- ✅ Redirect automatique → PairingScreen
- ✅ Affichage: "Pas encore appairé" ou "Afficher le couple"

---

## 🧪 Test Scenario 2: Register New User

### 1. Sur LoginScreen, cliquez "Pas encore de compte? S'inscrire"

### 2. RegisterScreen apparaît:

```
┌──────────────────────────┐
│    Créer un compte       │
│                          │
│ Nom d'utilisateur: [__] │
│ Email: [____________]   │
│ Mot de passe: [_______] │
│ Confirmer: [__________] │
│                          │
│ [ S'inscrire ]           │
│ Déjà inscrit? Login      │
└──────────────────────────┘
```

### 3. Remplissez:
- Username: `testuser2`
- Email: `testuser2@example.com`
- Password: `TestPass123!`
- Confirm: `TestPass123!`

### 4. Cliquez "S'inscrire"

**Expected**:
- ✅ User créé dans la base de données
- ✅ Tokens sauvegardés (SecureStorage)
- ✅ Redirect → PairingScreen

---

## 👥 Test Scenario 3: Create Couple (Partner A)

### 1. Alice est connectée → PairingScreen

```
┌────────────────────────────┐
│      Appairage             │
│                            │
│   Créer un couple          │
│ [ Créer un nouveau couple] │
│                            │
│   ─────────────────────   │
│                            │
│   Rejoindre un couple      │
│ Code: [____________]       │
│ [ Rejoindre le couple ]    │
└────────────────────────────┘
```

### 2. Alice clique "Créer un nouveau couple"

**Expected**:
- ✅ Couple créé (partner_a = alice)
- ✅ Success message: "Couple créé avec succès!"
- ✅ PairingScreen mise à jour
- ✅ "Générer un code d'invitation" button apparaît

### 3. Alice clique "Générer un code d'invitation"

**Expected**:
- ✅ Code 6-chiffres généré (ex: `567234`)
- ✅ Code affiché en gros:

```
┌─────────────────────────┐
│ Code d'invitation       │
│                         │
│  567234                 │
│                         │
│ Partagez ce code avec   │
│ votre partenaire        │
└─────────────────────────┘
```

### 4. Copier le code: `567234`

---

## 👥 Test Scenario 4: Join Couple (Partner B)

### 1. Ouvrir une NOUVELLE fenêtre incognito (ou autre navigateur)

### 2. Aller à: `http://localhost:8000` (ou le port du frontend)

### 3. LoginScreen → Login avec Bob:
- Email: `bob@example.com`
- Password: `TestPass123!`

**Expected**: Bob est connecté → PairingScreen

### 4. Bob entre le code d'Alice: `567234`

```
┌────────────────────────────┐
│      Appairage             │
│                            │
│   Rejoindre un couple      │
│ Code: [567234_______]      │
│ [ Rejoindre le couple ]    │
└────────────────────────────┘
```

### 5. Bob clique "Rejoindre le couple"

**Expected**:
- ✅ Success message: "Vous avez rejoint le couple!"
- ✅ Redirect → /home
- ✅ Alice + Bob sont maintenant appairés! 🎉

---

## ✅ Verification Checklist

- [ ] Alice peut se connecter
- [ ] Alice peut créer un couple
- [ ] Alice peut générer un code d'invitation
- [ ] Bob peut se connecter
- [ ] Bob peut rejoindre avec le code
- [ ] Pas d'erreurs console
- [ ] Pas d'erreurs API (check network tab)
- [ ] Tokens sont stockés (check storage tab)

---

## 🐛 Troubleshooting

### "Failed to connect to API"
- [ ] Backend est démarré sur `http://localhost:8000`?
- [ ] Firewall bloque les connexions?
- [ ] Port 8000 est bien libre?

**Fix:**
```bash
lsof -i :8000
# Si occupé, kill le processus et redémarrer
```

### "Invalid email or password"
- [ ] Email existe?
- [ ] Password est correct?
- [ ] Base de données a les migrations appliquées?

**Fix:**
```bash
python3 manage.py migrate
python3 manage.py shell
# Vérifier que alice@example.com existe
```

### "Token refresh failed"
- [ ] Backend JWT settings OK?
- [ ] SecureStorage fonctionne (sur web = localStorage)?

**Fix:** Vérifier logs backend

### "Code invalid"
- [ ] Code a expiré? (60 min par défaut)
- [ ] Code mal copié/collé?
- [ ] Couple déjà a 2 partners?

**Fix:** Générer un nouveau code

---

## 📊 Expected Network Requests

**Login:**
```
POST /api/auth/login/
Response: {access, refresh, user}
```

**Create Couple:**
```
POST /api/couple/create/
Response: {couple}
```

**Generate Invite:**
```
POST /api/couple/invite/
Response: {invite: {code, expires_at}}
```

**Join Couple:**
```
POST /api/couple/join/
Body: {code: "567234"}
Response: {couple}
```

---

## 🎉 Success!

Si tout fonctionne:
- ✅ Phase 4 Frontend est prêt
- ✅ Authentication works end-to-end
- ✅ Pairing logic is correct
- ✅ Ready for Phase 5 (Q&A, Goals, etc.)

**Next**: Continuer avec Phase 5 — Feature Screens!

---

## 📞 Issues?

Si quelque chose ne fonctionne pas:
1. Vérifier les logs du backend (Terminal 1)
2. Vérifier la console du navigateur (F12)
3. Vérifier l'onglet Network (requests/responses)
4. Relire cette documentation

Bon testing! 🚀
