# Quick Start — Lancer Phase 0–1 immédiatement

**Objectif :** Avoir Auth + Pairing fonctionnels en local en 48 heures  
**Pour :** Équipe backend + frontend prête à démarrer  
**Prérequis :** Python 3.9+, Flutter SDK, Git

---

## 🚀 Avant de commencer (15 min)

### Setup environnement local

```bash
# Cloner et initialiser backend
cd /Users/alexandre/Apps/couple-app-starter/backend
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Copier .env local
cp /path/to/.env.example .env
# Remplir:
# DJANGO_SECRET_KEY=<any random string for local>
# DEBUG=True
# DATABASE_URL=sqlite:///db.sqlite3 (local) or postgres://...

# Initialiser DB
python manage.py migrate

# Test run
python manage.py runserver
# Accès : http://127.0.0.1:8000/admin/
```

```bash
# Flutter setup
cd /Users/alexandre/Apps/couple-app-starter/frontend
flutter pub get
flutter run -d chrome
# Vérifier que l'app démarre (blanc/connexion esperée)
```

---

## 📋 Phase 0 — Auth API (Jour 1–2)

**Durée :** 2 jours | **Dev responsable :** Backend  
**Deliverable :** Endpoints `/register`, `/login`, `/me` fonctionnels

### Checklist

- [ ] **Django setup validé**
  - `python manage.py check` passe
  - Migrations appliquées (`python manage.py migrate`)
  - Admin accessible

- [ ] **Serializers**
  ```python
  # accounts/serializers.py
  # ├─ UserRegisterSerializer (email, password, password_confirm, display_name)
  # ├─ UserLoginSerializer (email, password)
  # └─ UserSerializer (id, email, display_name, created_at)
  ```
  
- [ ] **Views/Viewsets**
  ```python
  # accounts/views.py
  # ├─ RegisterView (POST /api/auth/register/)
  # ├─ LoginView (POST /api/auth/login/) → retourne token
  # └─ MeView (GET /api/auth/me/) → user courant
  ```

- [ ] **URLs**
  ```python
  # accounts/urls.py
  urlpatterns = [
      path('register/', RegisterView.as_view(), name='register'),
      path('login/', LoginView.as_view(), name='login'),
      path('me/', MeView.as_view(), name='me'),
  ]
  ```

- [ ] **Tests** (minimal pour MVP)
  ```python
  # tests/test_auth.py
  # ├─ test_register_success
  # ├─ test_register_duplicate_email
  # ├─ test_login_valid_credentials
  # ├─ test_login_invalid_password
  # └─ test_me_requires_auth
  ```

- [ ] **Validation** en local
  ```bash
  # Register
  curl -X POST http://127.0.0.1:8000/api/auth/register/ \
    -H "Content-Type: application/json" \
    -d '{
      "email": "alice@example.com",
      "password": "SecurePass123!",
      "password_confirm": "SecurePass123!",
      "display_name": "Alice"
    }'
  # Attendu: 201, {"id": "...", "email": "...", "token": "eyJ..."}

  # Login
  curl -X POST http://127.0.0.1:8000/api/auth/login/ \
    -H "Content-Type: application/json" \
    -d '{"email": "alice@example.com", "password": "SecurePass123!"}'
  # Attendu: 200, {"token": "eyJ..."}

  # Me (require Authorization header)
  curl -H "Authorization: Bearer eyJ..." http://127.0.0.1:8000/api/auth/me/
  # Attendu: 200, {"id": "...", "email": "alice@example.com", ...}
  ```

### Pièges communs
- **JWT secret key hardcodée** → utiliser env var `DJANGO_SECRET_KEY`
- **Pas de password hashing** → Django User model le fait auto via `set_password()`
- **CORS errors** → verify `CORS_ALLOWED_ORIGINS` en settings
- **SimpleJWT config missing** → ajouter settings `SIMPLE_JWT` avec expiration times

---

## 📋 Phase 1 — Pairing API (Jour 2–4)

**Durée :** 2–3 jours | **Dev responsable :** Backend  
**Dépendance :** Phase 0 (Auth)  
**Deliverable :** 2 users can pair via `/couple/create` + `/couple/invite` + `/couple/join`

### Checklist

- [ ] **Models review** (devrait être fait)
  ```python
  # couples/models.py
  # ├─ Couple (partner_a, partner_b FK User, created_at, updated_at)
  # └─ PairingInvite (couple FK, code str, expires_at, used_at, created_at)
  ```

- [ ] **Serializers**
  ```python
  # couples/serializers.py
  # ├─ CoupleSerializer (id, partner_a, partner_b, created_at, updated_at)
  # └─ PairingInviteSerializer (code, expires_at, created_at)
  ```

- [ ] **Views/Viewsets**
  ```python
  # couples/views.py
  # ├─ CoupleViewSet 
  # │  ├─ GET /api/couple/ → retourne couple courant
  # │  └─ POST /api/couple/create/ → crée couple vide
  # ├─ PairingInviteView
  # │  └─ POST /api/couple/invite/ → génère code (6 digits)
  # └─ JoinCoupleView
  #    └─ POST /api/couple/join/ (query ?code=123456) → joins couple
  ```

- [ ] **Logique métier**
  - Générer code: `random.randint(100000, 999999)`
  - Expiration: `now + timedelta(hours=24)`
  - Join validation:
    - Code existe et pas expiré
    - User n'est pas déjà dans un couple
    - Couple existe et partner_b est NULL
    - Atomic transaction pour update couple

- [ ] **Permissions**
  ```python
  # couples/permissions.py
  # ├─ IsAuthenticated (standard DRF)
  # ├─ IsCoupleMember (check user is in user.couple)
  # └─ IsSingleUser (check user not in any couple)
  ```

- [ ] **Tests** (minimal)
  ```python
  # tests/test_pairing.py
  # ├─ test_create_couple
  # ├─ test_invite_generates_code
  # ├─ test_join_valid_code
  # ├─ test_join_expired_code
  # ├─ test_join_already_paired
  # ├─ test_join_code_not_found
  # └─ test_concurrent_joins (transaction safety)
  ```

- [ ] **Validation** en local
  ```bash
  # User A: Create couple
  curl -X POST http://127.0.0.1:8000/api/couple/create/ \
    -H "Authorization: Bearer TOKEN_A" \
    -H "Content-Type: application/json" \
    -d '{}'
  # Attendu: 201, {"id": "uuid", "partner_a": {...}, "partner_b": null}

  # User A: Generate invite code
  curl -X POST http://127.0.0.1:8000/api/couple/invite/ \
    -H "Authorization: Bearer TOKEN_A"
  # Attendu: 200, {"code": "123456", "expires_at": "2026-01-17T..."}

  # User B: Join couple
  curl -X POST "http://127.0.0.1:8000/api/couple/join/?code=123456" \
    -H "Authorization: Bearer TOKEN_B" \
    -H "Content-Type: application/json" \
    -d '{}'
  # Attendu: 200, {"id": "uuid", "partner_a": {...}, "partner_b": {...}}

  # Both: Get couple
  curl -H "Authorization: Bearer TOKEN_A" \
    http://127.0.0.1:8000/api/couple/
  curl -H "Authorization: Bearer TOKEN_B" \
    http://127.0.0.1:8000/api/couple/
  # Attendu: 200, same couple for both
  ```

### Pièges communs
- **Concurrence :** 2× POST `/join` simultanément → utiliser `select_for_update()`
- **Code prédictibilité :** pas grave pour MVP avec rate-limiting
- **Timezone:** stocker `expires_at` en UTC
- **FK constraints:** `partner_b` nullable jusqu'à join

---

## 🌐 Phase 5 — Frontend Auth Screens (Jour 3–5)

**Durée :** 2–3 jours | **Dev responsable :** Frontend  
**Dépendance :** Phase 0 (Auth API)  
**Deliverable :** Login + Register screens, JWT stored locally, navigation protected

### Checklist

- [ ] **Project structure**
  ```
  frontend/lib/
  ├─ features/
  │  └─ auth/
  │     ├─ data/
  │     │  ├─ api_client.dart (Dio + auth methods)
  │     │  └─ models.dart (UserDto, LoginResponse)
  │     ├─ domain/
  │     │  └─ user.dart (User model)
  │     ├─ ui/
  │     │  ├─ login_screen.dart
  │     │  └─ register_screen.dart
  │     └─ providers.dart (Riverpod auth providers)
  ├─ core/
  │  ├─ config.dart (API_BASE_URL)
  │  └─ services/
  │     └─ secure_storage.dart (flutter_secure_storage)
  └─ router.dart (GoRouter setup)
  ```

- [ ] **Dependencies added** (pubspec.yaml)
  ```yaml
  dependencies:
    flutter:
      sdk: flutter
    dio: ^5.0.0
    riverpod: ^2.0.0
    riverpod_generator: ^2.0.0
    flutter_secure_storage: ^9.0.0
    go_router: ^10.0.0
    # ... autres
  
  dev_dependencies:
    build_runner: ^2.4.0
    riverpod_generator: ^2.0.0
  ```

- [ ] **API Client**
  ```dart
  // features/auth/data/api_client.dart
  class AuthApiClient {
    final Dio _dio;
    
    AuthApiClient(this._dio);
    
    Future<LoginResponse> register(String email, String password, String displayName) async {
      final response = await _dio.post('/auth/register/', data: {...});
      return LoginResponse.fromJson(response.data);
    }
    
    Future<LoginResponse> login(String email, String password) async {
      final response = await _dio.post('/auth/login/', data: {...});
      return LoginResponse.fromJson(response.data);
    }
    
    Future<User> getMe(String token) async {
      _dio.options.headers['Authorization'] = 'Bearer $token';
      final response = await _dio.get('/auth/me/');
      return User.fromJson(response.data);
    }
  }
  ```

- [ ] **Secure Storage**
  ```dart
  // core/services/secure_storage.dart
  class SecureStorageService {
    final FlutterSecureStorage _storage = FlutterSecureStorage();
    
    Future<void> saveToken(String token) async {
      await _storage.write(key: 'jwt_token', value: token);
    }
    
    Future<String?> getToken() async {
      return await _storage.read(key: 'jwt_token');
    }
    
    Future<void> deleteToken() async {
      await _storage.delete(key: 'jwt_token');
    }
  }
  ```

- [ ] **Riverpod Providers**
  ```dart
  // features/auth/providers.dart
  final authApiClientProvider = Provider((ref) => AuthApiClient(dioClient));
  final storageProvider = Provider((ref) => SecureStorageService());
  
  final currentUserProvider = FutureProvider<User?>((ref) async {
    final storage = ref.watch(storageProvider);
    final token = await storage.getToken();
    if (token == null) return null;
    
    final api = ref.watch(authApiClientProvider);
    return api.getMe(token);
  });
  
  final isAuthenticatedProvider = FutureProvider<bool>((ref) async {
    final user = await ref.watch(currentUserProvider.future);
    return user != null;
  });
  
  final loginProvider = FutureProvider.family<LoginResponse, (String, String)>((ref, credentials) async {
    final (email, password) = credentials;
    final api = ref.watch(authApiClientProvider);
    return api.login(email, password);
  });
  ```

- [ ] **Login Screen**
  ```dart
  // features/auth/ui/login_screen.dart
  class LoginScreen extends ConsumerWidget {
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    
    @override
    Widget build(BuildContext context, WidgetRef ref) {
      return Scaffold(
        appBar: AppBar(title: Text('Login')),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(controller: emailCtrl, decoration: InputDecoration(label: Text('Email'))),
              TextField(controller: passwordCtrl, obscureText: true, decoration: InputDecoration(label: Text('Password'))),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  try {
                    final response = await ref.read(loginProvider((emailCtrl.text, passwordCtrl.text)).future);
                    final storage = ref.read(storageProvider);
                    await storage.saveToken(response.token);
                    // Navigate to home or pairing screen
                    if (context.mounted) context.go('/couple');
                  } catch (e) {
                    // Show error snackbar
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed: $e')));
                  }
                },
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () => context.go('/register'),
                child: Text("Don't have an account? Register"),
              ),
            ],
          ),
        ),
      );
    }
  }
  ```

- [ ] **Router setup**
  ```dart
  // router.dart
  final appRouter = GoRouter(
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      GoRoute(
        path: '/couple',
        builder: (context, state) => PairingScreen(),
        redirect: (context, state) async {
          // Check if authenticated
          final isAuth = await checkAuth();
          if (!isAuth) return '/login';
          return null;
        },
      ),
    ],
    redirect: (context, state) async {
      final isAuth = await checkAuth();
      if (!isAuth && !state.location.startsWith('/login') && !state.location.startsWith('/register')) {
        return '/login';
      }
      return null;
    },
  );
  ```

- [ ] **Tests** (minimal)
  ```dart
  // tests/auth_test.dart
  group('Auth', () {
    test('login with valid credentials returns token', () async {
      // Mock API response
      // Call login()
      // Verify token stored in secure storage
    });
    
    test('register with valid data creates user', () async {
      // Mock API response
      // Call register()
      // Verify token stored
    });
    
    test('getMe requires valid token', () async {
      // Mock 401 response
      // Verify error handling
    });
  });
  ```

### Pièges communs
- **Dio interceptors :** Ajouter JWT automatiquement à tous les headers
- **Token refresh :** MVP simple (24h expiration, manuel re-login)
- **Secure storage permissions :** iOS/Android require proper capabilities
- **Hot reload issues :** Riverpod providers sometimes cache; use `.invalidate()`

---

## ✅ Definition of Done (Fin J4)

```
Phase 0 + 1 + 5 complètes ⟺

✅ Backend:
  - Auth endpoints (register, login, me) fonctionnels
  - Pairing endpoints (create, invite, join) fonctionnels
  - JWT working + expiration set
  - Tests passing (auth + pairing)
  - API responds on localhost:8000

✅ Frontend:
  - Login + Register screens visible
  - JWT stored in secure storage
  - Navigation protected (redirect to /login if not auth)
  - Riverpod providers for auth state
  - Can login and access /couple screen

✅ Integration:
  - User can register via frontend → JWT saved → logged in
  - User can login via frontend → fetches /me → shows display_name
  - Switching between Login/Register screens works
  - Error handling on invalid credentials shows error message

✅ Ready for Phase 2–6 (Sync, Feature APIs, Pairing screens)
```

---

## 🚀 Pour lancer

**Setup (5 min)**
```bash
cd backend && source .venv/bin/activate && python manage.py runserver
# Terminal 2:
cd frontend && flutter run -d chrome
```

**Check progress every day:**
```bash
cd backend && python manage.py test accounts
cd frontend && flutter test
```

**Document progress:**
- Every endpoint tested → add to `tests/`
- Every screen designed → screenshot to docs
- Blockers → escalate immediately

---

**Bon courage ! 🚀**

**Questions rapides ?** Check `docs/03-Design-Rules.md` (product) ou `backend/README.md` (setup)

---

**Version :** 1.0  
**Date :** 16 janvier 2026
