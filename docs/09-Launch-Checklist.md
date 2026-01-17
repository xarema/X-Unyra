# 🚀 Launch Checklist — Couple App MVP

**Checkpoints avant de démarrer le développement**

---

## ✅ Pré-launch (avant Jour 1)

### Équipe & Organisation
- [ ] **Backend developer assigné** → Démarre Phase 0 immédiatement
- [ ] **Frontend developer assigné** → Setup Flutter, attend Phase 2 stabilisé
- [ ] **Tech lead / PM assigné** → Reviews hebdomadaires
- [ ] **DevOps assigné** (optional) → Prep cPanel Week 1
- [ ] **Communication setup** (Slack, GitHub, Daily standup)
- [ ] **Commit message convention** definie (ex: `feat: auth login endpoint`)

### Infrastructure & Accounts
- [ ] **Git repository initialized** → `couple-app-starter` cloned, .gitignore OK
- [ ] **cPanel account ready** → Python 3.9+, PostgreSQL/MySQL available
- [ ] **Local dev environment verified** (both devs)
  - [ ] Python 3.9+ installed (`python --version`)
  - [ ] Flutter SDK installed (`flutter doctor` OK)
  - [ ] PostgreSQL or MySQL available locally (or use SQLite for Phase 0–4)
- [ ] **IDE setup** → PyCharm / VS Code configured with linters

### Documentation Review
- [ ] **Roadmap approved** → All stakeholders sign-off (see Executive Summary)
- [ ] **Scope confirmed** → PM confirms MVP features (6 must-haves in scope)
- [ ] **Design rules reviewed** → Team agrees on UX principles (Design Rules doc)
- [ ] **Security checklist acknowledged** → Backend dev reviews security minimums

### Kickoff Meeting
- [ ] **Roadmap walkthrough** (30 min)
  - Phase 0–1 in detail, rest in summary
  - Timeline expectations
  - Risk identification
- [ ] **Tech stack confirmed** (15 min)
  - Django version, DRF, Flutter SDK
  - Any tool preferences (testing, API docs, etc.)
- [ ] **Q&A session** (15 min)
  - Clarify scope, timeline, risks
  - Assign escalation path

---

## 🔍 Phase 0 (Auth API) — Checkpoint (End Day 5–7)

### Code
- [ ] **Django settings.py validated** (SECRET_KEY, ALLOWED_HOSTS, CORS, JWT config)
- [ ] **accounts/serializers.py complete** (RegisterSerializer, LoginSerializer, UserSerializer)
- [ ] **accounts/views.py complete** (/register, /login, /me endpoints)
- [ ] **accounts/urls.py routed** → URLs accessible
- [ ] **JWT authentication working** (SimpleJWT correctly configured)

### Testing
- [ ] **Unit tests pass** (`pytest tests/test_auth.py`)
  - Register happy path ✓
  - Register duplicate email ✗
  - Login valid credentials ✓
  - Login invalid password ✗
  - /me requires auth ✗ (401 without token)
- [ ] **Manual testing via cURL** (see Quick Start doc)
  - POST /api/auth/register/ → 201 + token
  - POST /api/auth/login/ → 200 + token
  - GET /api/auth/me/ → 200 + user data
  - GET /api/auth/me/ (no token) → 401

### Security
- [ ] **SECRET_KEY not hardcoded** (in .env)
- [ ] **Passwords hashed** (Django User.set_password() used)
- [ ] **No PII in logs** (verify logging config)

### Documentation
- [ ] **API endpoints documented** (docstrings or Swagger)
- [ ] **.env.example updated** with all required vars
- [ ] **Error codes documented** (400, 401, 409, etc.)

### **Go/No-Go Decision**
```
☐ All tests pass locally
☐ cURL requests work
☐ JWT decodes correctly
☐ CORS not blocking requests

→ YES, proceed to Phase 1 (Pairing API)
```

---

## 🤝 Phase 1 (Pairing API) — Checkpoint (End Day 10–14)

### Code
- [ ] **couples/serializers.py complete** (CoupleSerializer, PairingInviteSerializer)
- [ ] **couples/views.py complete** (/couple/create, /couple/invite, /couple/join)
- [ ] **couples/permissions.py** (IsCoupleMember, IsSingleUser)
- [ ] **Couple/PairingInvite models verified** (fields, unique constraints)
- [ ] **URL routing correct** → /api/couple/* accessible

### Testing
- [ ] **Unit tests pass** (`pytest tests/test_pairing.py`)
  - Create couple ✓
  - Generate invite code ✓
  - Join with valid code ✓
  - Join with expired code ✗
  - Join when already paired ✗
  - Concurrent joins (atomicity) ✓
- [ ] **Manual testing** (create User A, User B; pair via code)
  - User A: POST /couple/create/ → couple created
  - User A: POST /couple/invite/ → code generated
  - User B: POST /couple/join/?code=123456 → couple.partner_b updated
  - Both: GET /couple/ → same couple returned

### Security & Data
- [ ] **Code expiration enforced** (24h default)
- [ ] **Couple scope verified** (users in same couple can access)
- [ ] **No cross-couple leaks** (User A can't access User B's couple if not paired)
- [ ] **Unique constraints enforced** (one couple per user)

### Performance
- [ ] **Invite code generation fast** (<100ms)
- [ ] **Join endpoint <200ms** (even with DB query)

### **Go/No-Go Decision**
```
☐ All pairing tests pass
☐ 2 users can successfully pair
☐ Code expires correctly
☐ Couple scope enforced

→ YES, proceed to Phase 2 (Sync API) + Phase 3 (Feature APIs)
```

---

## 🔄 Phase 2 (Sync / Changes Feed) — Checkpoint (End Day 14–17)

### Code
- [ ] **sync/views.py complete** (/api/sync/changes?since=...)
- [ ] **DB indexes added** (couple_id, updated_at) on all feature tables
- [ ] **Change detection logic** filters by updated_at > since, couple-scoped

### Testing
- [ ] **Unit tests pass**
  - Return 0 changes if nothing modified since timestamp ✓
  - Return changed IDs if modified ✓
  - Return only couple-scoped changes ✓
- [ ] **Performance tests**
  - <300ms for 100 changes ✓
  - Scalable to 1000 changes ✓

### Response Format
- [ ] **Correct JSON structure**
  ```json
  {
    "server_time": "2026-01-16T15:30:45Z",
    "changes": {
      "qna": ["uuid1"],
      "goals": ["uuid2"],
      "checkins": [],
      "letters": []
    }
  }
  ```

### **Go/No-Go Decision**
```
☐ /sync/changes endpoint working
☐ Changes detected correctly
☐ Performance acceptable (<300ms)
☐ Couple-scoped

→ YES, proceed to Phase 3 (Feature APIs)
```

---

## 🎯 Phase 3A–D (Feature APIs) — Checkpoint (End Day 21–24)

### Code — Q&A, Goals, Check-ins, Letters
- [ ] **All serializers complete** (nested, with validations)
- [ ] **All viewsets complete** (GET list/detail, POST create, PUT update)
- [ ] **All models validated** (updated_at field present)
- [ ] **All URLs routed** (/qna/questions, /goals, /checkins, /letters)

### Testing
- [ ] **CRUD tests pass for each feature**
  - Create ✓
  - Read ✓
  - Update ✓
  - Delete / status change ✓
- [ ] **Couple scoping verified** for all features
- [ ] **Sync integration works** (changed items appear in /sync/changes)

### Error Handling
- [ ] **Permission errors clear** (401, 403)
- [ ] **Validation errors clear** (400 with details)
- [ ] **Not found errors** (404)

### **Go/No-Go Decision**
```
☐ All 4 feature APIs working (Q&A, Goals, Checkins, Letters)
☐ CRUD operations verified
☐ Sync detects changes
☐ Tests passing

→ YES, proceed to Phase 4 (Backend quality) + Phase 5 (Frontend auth)
```

---

## 🧪 Phase 4 (Backend Quality) — Checkpoint (End Day 28–31)

### Testing & Coverage
- [ ] **Test coverage ≥70%** (backend)
  - Unit tests for all serializers
  - Unit tests for all views
  - Integration tests for full workflows
- [ ] **Error paths tested** (not just happy path)
- [ ] **Edge cases tested** (concurrent edits, expiration, etc.)

### API Documentation
- [ ] **Swagger / docstrings added** for all endpoints
- [ ] **Error codes documented** (400, 401, 403, 404, 409, 500)
- [ ] **Rate-limiting documented** (login endpoint: 10 req/min/IP)

### Security Review
- [ ] **All endpoints have permission checks**
- [ ] **No hardcoded secrets**
- [ ] **CORS configured correctly** (whitelist, not `*`)
- [ ] **CSRF protection in place** (if forms)

### Performance Review
- [ ] **Slow queries identified** (use Django Debug Toolbar)
- [ ] **N+1 problems fixed** (use select_related, prefetch_related)
- [ ] **DB indexes in place**

### **Go/No-Go Decision**
```
☐ Test coverage ≥70%
☐ API documented
☐ Security review passed
☐ Performance acceptable

→ YES, ready for production deployment
```

---

## 🎨 Phase 5 (Frontend Auth) — Checkpoint (End Day 21–24)

### Setup
- [ ] **Flutter pubspec.yaml updated** (Dio, Riverpod, GoRouter, secure_storage)
- [ ] **API base URL configured** (points to backend localhost:8000 for dev)

### Code
- [ ] **AuthService/ApiClient complete** (register, login, getMe)
- [ ] **SecureStorage service** implemented (JWT persistent)
- [ ] **Riverpod providers** for auth state (currentUser, isAuthenticated)
- [ ] **Login screen** implemented (email, password, error handling)
- [ ] **Register screen** implemented (email, password, display_name, TOS)
- [ ] **Router configured** (GoRouter redirects non-auth to /login)

### Testing
- [ ] **Auth tests pass** (unit + widget)
  - Register flow ✓
  - Login flow ✓
  - JWT storage ✓
  - Logout ✓
  - Token refresh / expiration ✓

### **Go/No-Go Decision**
```
☐ Login screen working locally
☐ Register screen working locally
☐ JWT stored in secure storage
☐ Navigation protected (redirects to login)

→ YES, proceed to Phase 6 (Pairing screens)
```

---

## 🤝 Phase 6 (Frontend Pairing) — Checkpoint (End Day 28–31)

### Code
- [ ] **CreateCouple screen** (button, copy code, error handling)
- [ ] **JoinWithCode screen** (text input, join button)
- [ ] **Couple provider** (Riverpod: fetch couple, check if paired)
- [ ] **Navigation logic** (if couple exists → main tabs; else → pairing screens)

### Testing
- [ ] **Pairing flow tests pass**
  - Create couple ✓
  - Generate code ✓
  - Join couple ✓
  - Error handling (code expired, already paired) ✓

### **Go/No-Go Decision**
```
☐ CreateCouple screen working
☐ JoinWithCode screen working
☐ 2 users can pair via app
☐ Navigation switches to tabs

→ YES, proceed to Phase 7 (Polling)
```

---

## 🔄 Phase 7 (Smart Polling Manager) — Checkpoint (End Day 35–38)

### Code
- [ ] **PollingManager service** implemented
  - Calls /sync/changes periodically
  - Adjusts intervals (5s active, 30s idle, stop background)
  - Invalidates Riverpod providers on changes
- [ ] **Route observer** (detects active route → polling interval)
- [ ] **Offline detection** (graceful fail if no network)

### Testing
- [ ] **Polling intervals correct**
  - Active: 5s ✓
  - Idle: 30s ✓
  - Background: stopped ✓
- [ ] **Provider invalidation triggers refresh** ✓
- [ ] **Offline handling** (no crash, retry when online) ✓

### **Go/No-Go Decision**
```
☐ PollingManager running
☐ Intervals correct
☐ Provider invalidation working
☐ Offline graceful

→ YES, proceed to Phase 8 (Feature screens)
```

---

## 🎬 Phase 8 (Feature Screens) — Checkpoint (End Day 42–49)

### Code
- [ ] **Q&A list screen** (questions, answers, status)
- [ ] **Q&A detail screen** (answer form, 3 statuses)
- [ ] **Goals list screen** (goals, status, action count)
- [ ] **Goals detail screen** (actions, toggle done, edit status)
- [ ] **Check-in screen** (daily form, history)
- [ ] **Letter screen** (monthly editor, read prev)
- [ ] **Riverpod providers** for all features

### Testing
- [ ] **Feature screens load** (data fetches, displays)
- [ ] **CRUD operations work** (create, edit, delete)
- [ ] **Polling refreshes data** (create in backend, see update on app)
- [ ] **Error states display** (loading, error, empty)

### **Go/No-Go Decision**
```
☐ All 4 feature screens implemented
☐ CRUD operations working
☐ Polling integration working
☐ Tests passing

→ YES, proceed to Phase 9 (Polish)
```

---

## ✨ Phase 9 (Polish & UX) — Checkpoint (End Day 49–56)

### UX Completeness
- [ ] **Loading states** on all screens
- [ ] **Error messages** clear and actionable
- [ ] **Form validations** (client-side)
- [ ] **Optimistic updates** (UI updates before server if safe)
- [ ] **Offline banner** (visible when no network)
- [ ] **Design rules enforced** (no guilt language, intercultural safe)

### Accessibility
- [ ] **Text contrast** sufficient
- [ ] **Font sizes** readable
- [ ] **Buttons** large enough (48px min)
- [ ] **Labels** present on all inputs

### **Go/No-Go Decision**
```
☐ UX complete (loading, errors, validations)
☐ Design rules followed
☐ Accessible
☐ User-friendly

→ YES, proceed to Phase 10 (E2E testing)
```

---

## 🧪 Phase 10 (Integration & E2E) — Checkpoint (End Day 56–63)

### Full Workflows
- [ ] **Full end-to-end test passes**
  1. Register User A ✓
  2. Create couple ✓
  3. Generate code ✓
  4. Register User B ✓
  5. Join couple ✓
  6. Create Q&A question (A) ✓
  7. Answer question (B) ✓
  8. Check for update on A's app ✓
  9. Create goal ✓
  10. Toggle action done ✓
  11. Daily check-in ✓
  12. Write letter ✓

### Cross-Device Sync
- [ ] **Change on Device A appears on Device B <5s** ✓
- [ ] **Multiple simultaneous users** (10 users polling) ✓
- [ ] **Concurrent edits** handled (last-write-wins) ✓

### Performance
- [ ] **No UI freezes** during polling
- [ ] **Polling not overloading server** (10 users × 5s = manageable)
- [ ] **Memory usage stable** (no leaks)

### **Go/No-Go Decision**
```
☐ Full workflow tests pass
☐ Sync working <5s cross-device
☐ 10 concurrent users OK
☐ Performance acceptable

→ YES, proceed to Phase 11 (Deployment)
```

---

## 🚀 Phase 11 (Deployment on cPanel) — Checkpoint (End Day 63–70)

### Backend Deployment
- [ ] **cPanel Python app created** (Python 3.9+)
- [ ] **requirements.txt installed** (pip install -r requirements.txt)
- [ ] **Gunicorn configured** (workers = 4 * CPU)
- [ ] **Database created** (PostgreSQL or MySQL)
- [ ] **Migrations run** (python manage.py migrate)
- [ ] **Environment variables set** (DJANGO_SECRET_KEY, DATABASE_URL, CORS_ORIGINS, etc.)
- [ ] **Static files collected** (python manage.py collectstatic)
- [ ] **WhiteNoise configured** (serving static files)
- [ ] **HTTPS enabled** (SSL certificate auto-renewed)
- [ ] **Gunicorn restarted** (via cPanel)

### Frontend Deployment
- [ ] **Flutter web built** (`flutter build web --release`)
- [ ] **Web files uploaded** to public_html (or subdomain)
- [ ] **API base URL configured** (points to backend production)
- [ ] **Android APK built** (`flutter build apk --release`)
- [ ] **Android signed** (keystore, key.properties)
- [ ] **APK available for download** (or Play Store listing started)

### Testing in Production
- [ ] **Smoke test: register** (via web)
- [ ] **Smoke test: login** (JWT works)
- [ ] **Smoke test: pairing** (create couple, join)
- [ ] **Smoke test: Q&A** (create, answer)
- [ ] **Smoke test: sync** (/sync/changes returns correct data)
- [ ] **HTTPS enforced** (no mixed content)
- [ ] **CORS errors** none

### Operations & Monitoring
- [ ] **Error logging set up** (Sentry or cPanel logs)
- [ ] **Database backup automated** (cPanel backup or script)
- [ ] **Monitoring setup** (basic uptime check)
- [ ] **Support docs prepared** (FAQs, troubleshooting)
- [ ] **Privacy policy published** (GDPR, cookies, etc.)

### **Launch Go/No-Go Decision**
```
☐ Backend live and accessible
☐ Frontend web live
☐ Android APK available
☐ Smoke tests pass
☐ Monitoring OK
☐ Support docs ready

→ YES, LAUNCH TO PRODUCTION ✅
```

---

## 🎉 Post-Launch (Week 8+)

### Day 1–7 (Monitoring)
- [ ] **Monitor error logs** (daily)
- [ ] **Monitor uptime** (24/7)
- [ ] **User feedback collection** (support email, bug reports)
- [ ] **Quick fixes** for critical bugs (if any)

### Week 2 (Post-Launch Review)
- [ ] **Retrospective** (what went well, what didn't)
- [ ] **Plan Release 1.1** (PDF export, repair flow, pause feature)
- [ ] **Prioritize feedback** (user-requested features)

---

## 📊 Final Checklist Summary

```
✅ Kickoff & Setup (Day 1)
✅ Phase 0 (Auth) — Day 7
✅ Phase 1 (Pairing) — Day 14
✅ Phase 2 (Sync) — Day 17
✅ Phase 3 (Features) — Day 24
✅ Phase 4 (Backend Quality) — Day 31
✅ Phase 5–6 (Frontend Auth/Pairing) — Day 31
✅ Phase 7 (Polling) — Day 38
✅ Phase 8 (Feature Screens) — Day 49
✅ Phase 9 (Polish) — Day 56
✅ Phase 10 (E2E) — Day 63
✅ Phase 11 (Deploy) — Day 70
✅ LIVE! 🎉

Total: 8 weeks, 70 working days
```

---

**Good luck! 🚀**

Review this checklist weekly. Any ❌ = escalate immediately.

---

**Version :** 1.0  
**Date :** January 16, 2026  
**Next Review :** End of Week 1
