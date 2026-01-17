# ⚡ DÉMARRAGE RAPIDE — 3 ÉTAPES

## 🖥️ SUR MACOS / LINUX

### Étape 1: Ouvrir Terminal
```bash
# Copier coller ceci dans Terminal:
cd /Users/alexandre/Apps/couple-app-starter
chmod +x run_tests.sh
./run_tests.sh
```

### Étape 2: Ouvrir Navigateur
```
http://localhost:8080
```

### Étape 3: Tester
```
S'inscrire avec:
Email: alice@example.com
Password: TestPass123!
```

✅ **Fin!**

---

## 🪟 SUR WINDOWS

### Étape 1: Double-cliquer
```
Double-cliquez sur: run_tests.bat
```

### Étape 2: Ouvrir Navigateur
```
http://localhost:8080
```

### Étape 3: Tester
```
S'inscrire avec:
Email: alice@example.com
Password: TestPass123!
```

✅ **Fin!**

---

## ❌ SI ÇA NE MARCHE PAS

**Message d'erreur: "Python not found"**
- Installez Python 3: https://python.org (Windows)
- Ou: `brew install python3` (macOS)

**Message d'erreur: "Port 8000 already in use"**
- Tuez le processus: 
  - macOS: `lsof -ti:8000 | xargs kill -9`
  - Windows: `netstat -ano | findstr :8000`

**Message d'erreur: "Cannot connect"**
- Vérifiez que les deux fenêtres de terminal tournent
- Attendez 3 secondes
- Actualiser le navigateur (F5)

---

## 🎯 C'EST TOUT!

Vous pouvez maintenant tester le MVP complet!

- ✅ S'inscrire
- ✅ Créer couple
- ✅ Rejoindre couple
- ✅ Créer questions
- ✅ Créer goals
- ✅ Créer check-ins
- ✅ Créer lettres

**Bon test!** 🚀
