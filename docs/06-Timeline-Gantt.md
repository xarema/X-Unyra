# Timeline & Gantt — Couple App MVP

**Format :** Vue d'ensemble visuelle de la roadmap avec dépendances et parallélisation

---

## 📅 Timeline sur 8 semaines

```
SEMAINE 1          SEMAINE 2          SEMAINE 3          SEMAINE 4
│                  │                  │                  │
├─ P0 (Auth)       ├─ P2 (Sync)       ├─ P4 (Backend     ├─ P5–6 (Frontend
├─ P1 (Pairing)    ├─ P3A–D (APIs)    │   Quality)       │   Auth/Pairing)
│                  │                  │                  │
│                  ├─ P5 (FE Auth)    ├─ P5–6 (FE        ├─ P7 (Polling)
│                  │   starts          │   Pairing cont.)  │
│                  │                  │                  │

SEMAINE 5          SEMAINE 6          SEMAINE 7          SEMAINE 8
│                  │                  │                  │
├─ P7 (Polling)    ├─ P8 (Features)   ├─ P9–10 (Polish   ├─ P11 (Deploy)
├─ P8 (Features)   │   continue       │   & E2E)         │
│                  │                  │                  │
│                  ├─ P9 (Polish)     ├─ P11 (Deploy)    └─ ✅ LIVE!
│                  │   starts          │   starts          
│                  │                  │                  
```

---

## 📊 Gantt détaillée (par tâche clé)

### **Legend**
- `█` = Dev 1 (Backend)
- `▓` = Dev 2 (Frontend)  
- `▒` = Shared / Both
- `░` = Optional / P2+

---

### **Semaine 1 — Foundation**

```
Phase 0: Auth API
  ├─ Django config               █████ (2d)
  ├─ Auth serializers + views    █████ (1.5d)
  ├─ JWT + Permissions           ████  (1d)
  └─ Tests auth                  ██    (1d)
                                 ─────────── = 5.5 days (Dev 1)

Phase 1: Pairing API (start)
  ├─ Couple serializers          ████  (1d)
  ├─ Pairing invite logic        ████  (1d)
  ├─ Join endpoint + validation  ███   (0.5d)
  └─ Tests pairing               ██    (0.5d)
                                 ─────────── = 3 days (Dev 1)

Frontend Setup (parallel)
  ├─ Project setup               ▓▓▓▓  (1d)
  ├─ Router config               ▓▓▓   (0.5d)
  ├─ API client skeleton         ▓▓▓   (0.5d)
  └─ UI stubs (Login, Register)  ▓▓    (1d)
                                 ─────────── = 3 days (Dev 2)
```

### **Semaine 2 — Smart Polling & Feature APIs**

```
Phase 2: Sync / Changes Feed
  ├─ /sync/changes endpoint      ████  (1d)
  ├─ Change detection logic      ████  (1d)
  ├─ DB indexes                  ███   (0.5d)
  └─ Perf tests                  ███   (0.5d)
                                 ─────────── = 3 days (Dev 1)

Phase 3A–D: Feature APIs (Q&A, Goals, Checkins, Letters)
  ├─ Q&A viewsets + tests        ███   (1d)
  ├─ Goals viewsets + tests      ███   (1d)
  ├─ Checkins viewsets           ██    (0.5d)
  ├─ Letters viewsets            ██    (0.5d)
  └─ Integration tests           ███   (0.5d)
                                 ─────────── = 4 days (Dev 1)

Phase 5: Frontend Auth (parallel)
  ├─ AuthService (Dio)           ▓▓▓▓  (1d)
  ├─ Login screen                ▓▓▓   (1d)
  ├─ Register screen             ▓▓▓   (1d)
  ├─ JWT storage (secure)        ▓▓▓   (0.5d)
  ├─ Router redirects            ▓▓    (0.5d)
  └─ Auth tests                  ▓▓    (0.5d)
                                 ─────────── = 5 days (Dev 2)
```

### **Semaine 3–4 — Backend Quality & Frontend Auth/Pairing**

```
Phase 4: Backend Quality (week 3)
  ├─ Serializer validations      ████  (1d)
  ├─ Error standardization       ███   (0.5d)
  ├─ API docs (Swagger)          ███   (0.5d)
  ├─ Rate-limiting               ██    (0.5d)
  ├─ Tests coverage ≥70%         ████  (1d)
  └─ Security review             ███   (0.5d)
                                 ─────────── = 4 days (Dev 1)

Phase 6: Frontend Pairing (week 4)
  ├─ CreateCouple screen         ▓▓▓   (0.5d)
  ├─ JoinWithCode screen         ▓▓▓   (0.5d)
  ├─ Couple provider (Riverpod)  ▓▓▓▓  (1d)
  ├─ Navigation logic            ▓▓▓   (0.5d)
  └─ Pairing tests               ▓▓    (0.5d)
                                 ─────────── = 3.5 days (Dev 2)

Phase 7: Frontend Polling (week 4)
  ├─ PollingManager service      ▓▓▓▓  (1.5d)
  ├─ Interval logic              ▓▓▓   (1d)
  ├─ Provider invalidation       ▓▓▓   (1d)
  ├─ Offline support             ▓▓    (0.5d)
  └─ Polling tests               ▓▓    (0.5d)
                                 ─────────── = 4.5 days (Dev 2)
```

### **Semaine 5–6 — Frontend Features**

```
Phase 8: Feature Screens (Q&A, Goals, Checkins, Letters)
  ├─ Q&A list + detail           ▓▓▓   (1d)
  ├─ Q&A answer form             ▓▓▓   (1d)
  ├─ Goals list + detail         ▓▓▓   (1d)
  ├─ Goals micro-actions         ▓▓▓   (1d)
  ├─ Checkins form               ▓▓▓   (1d)
  ├─ Checkins history            ▓▓    (0.5d)
  ├─ Letters editor              ▓▓▓   (1d)
  ├─ Letters history             ▓▓    (0.5d)
  ├─ Riverpod providers          ▓▓▓▓  (1.5d)
  └─ Feature tests               ▓▓    (1d)
                                 ─────────── = 9 days (Dev 2)

  [Dev 1 available for support or backend issues]
```

### **Semaine 6–7 — Polish & Testing**

```
Phase 9: UX Polish & Error Handling (week 6)
  ├─ Loading states all screens  ▒▒▒▒  (1d, shared)
  ├─ Error handling              ▒▒▒▒  (1.5d, shared)
  ├─ Form validations            ▒▒▒   (1d, shared)
  ├─ Localization setup          ▒▒▒   (0.5d, shared)
  ├─ Design rules enforcement    ▒▒▒   (1d, shared)
  └─ Accessibility review        ▒▒    (0.5d, shared)
                                 ─────────── = 6 days (shared effort)

Phase 10: Integration & E2E (week 7)
  ├─ Full workflow tests         ▒▒▒▒  (1.5d, shared)
  ├─ Sync cross-device test      ▒▒▒▒  (1.5d, shared)
  ├─ Perf testing (10 users)     ▒▒▒   (1d, shared)
  ├─ Mobile responsive check     ▒▒    (0.5d, shared)
  └─ Known issues doc            ▒▒    (0.5d, shared)
                                 ─────────── = 5 days (shared effort)
```

### **Semaine 8 — Deployment**

```
Phase 11a: Backend Deploy
  ├─ cPanel Python setup         █████ (1d)
  ├─ Database migration          █████ (1d)
  ├─ Gunicorn + WhiteNoise       ████  (1d)
  ├─ SSL/HTTPS                   ███   (0.5d)
  └─ Error logging setup         ███   (0.5d)
                                 ─────────── = 4 days (Dev 1)

Phase 11b: Frontend Deploy (parallel)
  ├─ Flutter web build           ▓▓▓▓  (0.5d)
  ├─ Upload to cPanel            ▓▓▓   (0.5d)
  ├─ API URL config in prod      ▓▓▓   (0.25d)
  ├─ Android APK/AAB build       ▓▓▓▓  (1d)
  └─ Smoke tests in prod         ▓▓▓   (0.5d)
                                 ─────────── = 2.75 days (Dev 2)

Phase 11c: Launch Prep (shared)
  ├─ Privacy policy + ToS        ▒▒    (0.5d, shared)
  ├─ FAQs + support docs         ▒▒    (0.5d, shared)
  └─ Monitoring setup            ▒▒    (0.5d, shared)
                                 ─────────── = 1.5 days (shared)

✅ MVP LIVE!                      (End of week 8)
```

---

## 🔄 Dépendances critiques

```
Auth API (P0)
    ↓
Pairing API (P1) ──┬─→ Frontend Auth (P5)
                  └─→ Frontend Pairing (P6)
                      ↓
Sync API (P2)  ←────────┴──→ Frontend Polling (P7)
    ↓
Feature APIs (P3A–D) ──→ Feature Screens (P8)
    ↓
Backend Quality (P4) ─→ E2E Testing (P10)
    ↓
    └──→ Deployment (P11) ✅ LIVE
```

**Chemin critique :**  
`Auth → Pairing → Sync → Features API → Frontend Polling → Feature Screens → E2E → Deploy`  
**Longueur :** ~32–35 jours (travail effectif)

---

## ⏱️ Heures estimées (par rôle)

### Backend (Dev 1)
- **Phase 0:** 5.5j × 8h = **44h**
- **Phase 1:** 3j × 8h = **24h**
- **Phase 2:** 3j × 8h = **24h**
- **Phase 3A–D:** 4j × 8h = **32h**
- **Phase 4:** 4j × 8h = **32h**
- **Phase 11a:** 4d × 8h = **32h**
- **Overhead (meetings, reviews):** ~10h
- **Total:** ~198h (≈ 5 semaines full-time)

### Frontend (Dev 2)
- **Frontend Setup:** 3j × 8h = **24h**
- **Phase 5:** 5d × 8h = **40h**
- **Phase 6:** 3.5d × 8h = **28h**
- **Phase 7:** 4.5d × 8h = **36h**
- **Phase 8:** 9d × 8h = **72h**
- **Phase 9–10:** ~6d × 8h = **48h** (shared with Dev 1)
- **Phase 11b:** 2.75d × 8h = **22h**
- **Overhead:** ~10h
- **Total:** ~280h (≈ 7 semaines full-time)

### Shared Effort
- **Phase 9–10 (Polish & E2E):** ~6d × 16h = **96h** (both devs together)
- **Phase 11c (Launch prep):** ~1.5d × 16h = **24h** (both devs)

**Total Effort:** 198 + 280 + 120 = **598 person-hours**  
**For 2-person team:** ~8 weeks full-time  
**For 3-person team:** ~6 weeks (add QA specialist)

---

## 🎯 Milestones & Go/No-Go Gates

| Milestone | Jour | Owner | Success Criteria |
|-----------|------|-------|------------------|
| **M1: Auth works locally** | J7 | Dev 1 | `/login`, `/register`, JWT stored |
| **M2: Pairing works locally** | J10 | Dev 1 | 2 users can pair via code |
| **M3: Feature APIs all working** | J14 | Dev 1 | All 4 features CRUD endpoints tested |
| **M4: Frontend Auth screens** | J14 | Dev 2 | Login/Register screens + navigation |
| **M5: Sync verified** | J14 | Dev 1 | `/changes` returns correct IDs, perf OK |
| **M6: PollingManager working** | J21 | Dev 2 | Active/idle intervals, invalidation working |
| **M7: 1 feature end-to-end** | J21 | Both | Q&A: create question → see update on other device |
| **M8: MVP feature-complete** | J35 | Both | All 4 features screens + polling working |
| **M9: ≥70% tests coverage** | J35 | Both | Backend & frontend unit tests pass |
| **M10: E2E tests green** | J42 | Both | 2-user full workflows pass |
| **M11: Live on cPanel** | J48 | Both | Web + Android accessible, backup OK |

---

## 📋 Checklist de démarrage (avant J1)

- [ ] Repository setup (Git, CI/CD if desired)
- [ ] Django project structure verified
- [ ] Flutter project structure verified
- [ ] cPanel account ready (Python 3.9+, PostgreSQL)
- [ ] Team agrees on communication (Slack, Git commits, etc.)
- [ ] Design guidelines/wireframes shared
- [ ] API documentation tool decided (Swagger, Postman, etc.)
- [ ] Testing framework setup (pytest for Django, flutter_test for Flutter)
- [ ] Local dev environment tested (both devs can run backend + frontend)

---

## 🚨 Risk Triggers & Escalation

| Trigger | Probability | Response Time |
|---------|-------------|----------------|
| **Sync endpoint >500ms for 100 changes** | Medium | Pause Phase 3, optimize queries (24h) |
| **JWT issues in prod** | Low | Extend Phase 4 quality (2d) |
| **cPanel Python/DB constraints** | Low | Early test (Week 1), escalate if blocker (3d) |
| **Polling flood detected** | Medium | Reduce interval/add backoff (12h) |
| **Concurrent edit conflicts** | Low | Implement conflict resolution (2d, Phase 4) |

---

## 📈 Tracking & Reporting

**Weekly sync (every Friday):**
1. Metrics: % of phases complete, blockers
2. Velocity: tasks closed vs planned
3. Risks: any new issues?
4. Plan adjustments needed?

**Example Week 1 report:**
```
✅ COMPLETED
  - Phase 0 (Auth API): 100% (serializers, views, tests, docs)
  - Frontend setup: 100% (router, skeleton)

⏳ IN PROGRESS
  - Phase 1 (Pairing API): 70% (endpoints done, edge cases testing)

❌ BLOCKED
  - (None)

📊 VELOCITY
  - Planned: 8 tasks
  - Done: 7 tasks
  - Carry-over: 1 task → next week

⚠️ RISKS
  - None yet; on track
```

---

**Document Version :** 1.0  
**Créé :** 16 janvier 2026  
**Prochaine révision :** Jour 7 (fin semaine 1)
