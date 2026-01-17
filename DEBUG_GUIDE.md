# 🔍 GUIDE DE DÉBOGAGE - LOGIN

## ÉTAPE 1: Redémarrer tout proprement

### Terminal 1 - Backend
```bash
cd /Users/alexandre/Apps/couple-app-starter/backend
source .venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

Attendez de voir:
```
Starting development server at http://0.0.0.0:8000/
```

### Terminal 2 - Frontend
```bash
cd /Users/alexandre/Apps/couple-app-starter/frontend
flutter run -d chrome
```

Attendez de voir Chrome s'ouvrir avec l'app.

## ÉTAPE 2: Ouvrir la Console Chrome

1. Dans Chrome, appuyez sur **F12** ou **Cmd+Option+I** (Mac)
2. Allez dans l'onglet **Console**
3. Vous devriez voir les logs Flutter

## ÉTAPE 3: Essayer de se connecter

Dans l'app, entrez:
- **Email**: alice@example.com
- **Password**: testpass123

Cliquez sur "Se connecter"

## ÉTAPE 4: Regarder les logs

### Dans la Console Chrome, vous devriez voir:

```
🚀 Login button pressed
   Email: alice@example.com
📞 Calling authProvider.login()
🔐 Login attempt for: alice@example.com
📤 POST /auth/login/
✅ Login response received: 200
📦 Response data: {user: {...}, access: "...", refresh: "..."}
💾 Saving tokens...
   Access token length: XXX
   Refresh token length: XXX
✅ Tokens saved to localStorage
✅ Verification: token exists = true
✅ Tokens saved successfully
🔍 Login result: true
✅ Login successful, loading couple data...
📞 Calling coupleProvider.getCouple()
🔄 Navigating to /couple
```

### Dans le Terminal Backend (Django), vous devriez voir:

```
[17/Jan/2026 XX:XX:XX] "OPTIONS /api/auth/login/ HTTP/1.1" 200 0
[17/Jan/2026 XX:XX:XX] "POST /api/auth/login/ HTTP/1.1" 200 624
[17/Jan/2026 XX:XX:XX] "GET /api/couple/ HTTP/1.1" 200 XXX
```

## ÉTAPE 5: Problèmes possibles

### Si vous voyez seulement OPTIONS sans POST:

**Problème**: Le frontend n'envoie pas la requête POST.

**Vérifiez**:
1. Dans Console Chrome, cherchez des erreurs rouges
2. Vérifiez que les logs Flutter apparaissent (🚀 Login button pressed)
3. Si pas de logs → Le bouton n'est pas connecté

### Si POST retourne 400 ou 401:

**Problème**: Credentials incorrects ou format de requête.

**Solution**:
```bash
# Testez directement avec curl
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"testpass123"}'
```

Si ça marche avec curl mais pas dans l'app → problème CORS ou format JSON.

### Si POST retourne 200 mais reste sur la page login:

**Problème**: Tokens ne sont pas sauvegardés ou navigation échoue.

**Vérifiez**:
1. Console Chrome → onglet **Application** → **Local Storage**
2. Cherchez `couple_app_access_token`
3. S'il existe → problème de navigation
4. S'il n'existe pas → problème de sauvegarde tokens

## ÉTAPE 6: Vérification manuelle localStorage

Dans Console Chrome, tapez:
```javascript
localStorage.getItem('couple_app_access_token')
```

Si ça retourne `null` → les tokens ne sont pas sauvegardés.

## 🆘 SI RIEN NE MARCHE

Prenez une capture d'écran de:
1. La Console Chrome (logs Flutter)
2. Le Terminal Django (logs serveur)
3. Onglet Network Chrome → Filter "login" → Montrer la requête

Et envoyez-moi ça!
