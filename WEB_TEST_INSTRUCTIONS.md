# 🧪 Web Test Instructions

## ✅ Prerequisites

### 1. Backend Django Actif
```bash
# Terminal 1 - Lancez le backend
cd /Users/alexandre/Apps/couple-app-starter/backend
python3 manage.py runserver 0.0.0.0:8000
```

**Status:** Django doit tourner sur `http://localhost:8000`

### 2. Test de l'API Backend

```bash
# Tester le login
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"alice12345"}'

# Réponse attendue:
# {
#   "user": {...},
#   "access": "eyJ...",
#   "refresh": "eyJ..."
# }
```

---

## 🚀 Lancer l'App Web Flutter

### Terminal 2 - Frontend Web
```bash
cd /Users/alexandre/Apps/couple-app-starter/frontend

# Option 1: Chrome
flutter run -d chrome

# Option 2: Safari
flutter run -d safari

# Option 3: Firefox
flutter run -d firefox
```

---

## 🧬 Test Scénarios

### Scenario 1: Connexion - Alice
**Email:** `alice@example.com`
**Password:** `alice12345`

**Actions:**
1. Ouvrir l'app
2. Vous devez être sur la page Login
3. Entrez alice@example.com et alice12345
4. Cliquez "Se connecter"

**Résultat attendu:**
- ✅ Pas de message d'erreur
- ✅ Redirection vers la page Couple/Pairing
- ✅ L'app affiche les options pour créer/rejoindre un couple

---

### Scenario 2: Inscription - Test User
**Username:** `test_new_user`
**Email:** `test_new@example.com`
**Password:** `TestPass123`

**Actions:**
1. Cliquez sur "Pas encore de compte? S'inscrire"
2. Remplissez le formulaire
3. Cliquez "S'inscrire"

**Résultat attendu:**
- ✅ Pas de message d'erreur
- ✅ Nouvel utilisateur créé
- ✅ Redirection vers Couple page

---

### Scenario 3: Créer un Couple
**À partir du compte Alice**

**Actions:**
1. Connectez-vous avec Alice
2. Sur la page Couple, cliquez "Créer un couple"

**Résultat attendu:**
- ✅ Couple créé
- ✅ Code d'invitation généré
- ✅ Affichage du code à partager

---

### Scenario 4: Rejoindre un Couple
**Avec Bob en utilisant le code d'Alice**

**Actions:**
1. Connectez-vous avec Bob
2. Cliquez "Rejoindre un couple"
3. Entrez le code d'Alice
4. Cliquez "Rejoindre"

**Résultat attendu:**
- ✅ Bob et Alice appairés
- ✅ Affichage du couple
- ✅ Accès aux features (Q&A, Goals, etc.)

---

## 🐛 Debugging

### Voir les logs Dart
```bash
# Dans le terminal où flutter run tourne:
# Appuyez sur 'w' pour afficher les logs
```

### Vérifier la console du navigateur
```bash
# Chrome/Safari/Firefox
# Appuyez sur F12 ou Cmd+Option+I
# Allez dans l'onglet "Console"
```

### Vérifier les requêtes API
```bash
# Chrome/Safari DevTools
# Network tab → Filtrer par "api"
# Voir les requêtes vers http://localhost:8000/api/...
```

---

## 📋 Identifiants Prédéfinis

| Username | Email | Password | Rôle |
|----------|-------|----------|------|
| alice | alice@example.com | alice12345 | Test User 1 |
| bob | bob@example.com | bob12345 | Test User 2 |

---

## ✨ Indicateurs de Succès

- ✅ Login fonctionne sans erreur 400
- ✅ Inscription fonctionne
- ✅ Redirection vers /couple après auth
- ✅ Création de couple réussie
- ✅ Code d'invitation généré
- ✅ Rejoindre couple fonctionne

---

## 🎯 Prochaines Étapes

Si tout fonctionne:
1. Testez les features Q&A
2. Testez les Goals
3. Testez les Check-ins
4. Testez les Letters

Si quelque chose ne fonctionne pas:
1. Vérifiez que le backend Django tourne
2. Vérifiez les logs du terminal Flutter
3. Vérifiez la console du navigateur (F12)
4. Vérifiez les requêtes API (Network tab)

---

## 📞 Support

Si vous rencontrez des problèmes:
1. Vérifiez la console du navigateur (F12)
2. Vérifiez les logs Flutter
3. Vérifiez que le backend Django est actif sur :8000
4. Vérifiez que les identifiants de test existent
