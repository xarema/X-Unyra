# 🎯 Executive Summary — Couple App Roadmap

**One-page overview pour décideurs & stakeholders**

---

## 📌 Projet

**Couple App** : Application mobile-first (Flutter) + web permettant aux couples de s'aligner sur des objectifs, faire des check-ins quotidiens, partager des questions-réponses, et écrire des lettres mensuelles. Déploiement cPanel, sans WebSockets (smart polling).

**Lancé :** Janvier 2026 | **MVP livré :** Août 2026 (8 semaines)

---

## 💰 Ressources requises

| Rôle | Durée | Effort | Notes |
|------|-------|--------|-------|
| **Backend Developer** | 8 semaines | 198h (5 SEM full-time) | Django + DRF, auth, APIs |
| **Frontend Developer** | 8 semaines | 280h (7 SEM full-time) | Flutter (Android + Web) |
| **DevOps / Deployment** | 1 semaine | 16h (jeudi-vendredi S8) | cPanel setup + monitoring |
| **QA / Testing** | 2 semaines | 40h (E2E + regression) | Phase 10–11 |
| **Tech Lead / PM** | 8 semaines | ~20% du temps | Planning, reviews, unblocking |

**Total :** ~2.5–3 FTE pour 8 semaines = **~600 person-hours**

**Alternativement :** 1 senior dev full-time + 1 junior dev full-time = 16 semaines

---

## 📊 Scope MVP

### ✅ Inclus (Must-have)
- User authentication (register, login, JWT)
- Couple pairing via code invitation
- Q&A with 3-status answers (ANSWERED, NEEDS_TIME, CLARIFY)
- Goals with micro-actions
- Daily check-ins (mood, stress, energy 0–10)
- Monthly letters (draft + save)
- **Smart polling** for near-live updates (no WebSockets)
- Web + Android builds

### 🚫 Exclu de MVP (Release 1.1+)
- PDF export de lettres
- "Repair flow" (guided conflict resolution)
- "Pause saine" (temporary pause feature)
- Notifications push
- Internationalisation (en/fr/ko) — structure prep only
- iOS app
- Advanced analytics

---

## 🗓️ Timeline

```
Week 1:    Foundation (Auth) + Setup
Week 2:    Smart Polling + Feature APIs
Week 3–4:  Backend Quality + Frontend Auth/Pairing
Week 5–6:  Feature Screens (Q&A, Goals, etc.)
Week 6–7:  Polish & E2E Testing
Week 8:    Deployment (cPanel)

Go-Live:   End of Week 8
```

**Dépendance critique :** Auth → Pairing → Sync → Features → Frontend (path critique = 32–35 jours)

---

## 💾 Tech Stack

| Component | Technology |
|-----------|------------|
| **Backend** | Python 3.9+ / Django 5.0 + DRF |
| **Frontend** | Flutter (single codebase: Android + Web) |
| **Database** | PostgreSQL (preferred) or MySQL |
| **Auth** | JWT (SimpleJWT) |
| **Hosting** | cPanel (WSGI, no always-on server) |
| **Polling** | Smart client-side polling (5s active, 30s idle, stop background) |
| **State mgmt (Frontend)** | Riverpod |

---

## 🎯 Success Criteria

✅ **Functional MVP:**
- 2 users can register → pair → collaborate on 4 features
- All CRUD operations working
- Data syncs <5s between devices
- ≥70% test coverage (backend + frontend)

✅ **Performance:**
- API <200ms for 100 concurrent requests
- Polling doesn't overload cPanel (tested with 10 users)

✅ **Security:**
- All endpoints couple-scoped (no cross-couple leaks)
- HTTPS enforced
- JWT with 24h expiration
- Secrets in env vars, not in code

✅ **User Experience:**
- 2-minute daily check-in
- No guilt-inducing language
- Intercultural-safe (EN only for MVP)

---

## ⚠️ Top Risks & Mitigations

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|-----------|
| **Polling flood** | Medium | High | Early perf testing Week 2 + configurable intervals |
| **cPanel Python version incompatible** | Low | High | Verify Python 3.9+ Week 1 |
| **JWT expiration edge cases** | Medium | Medium | Simple 24h expiration, no refresh token for MVP |
| **Concurrent edit conflicts** | Low | Medium | Last-write-wins, UI warning if conflict |
| **Migration issues on cPanel** | Low | High | Test migrations locally, backup procedure Week 8 |

**Mitigation strategy :** Weekly risk review, rapid escalation for blockers.

---

## 💵 Cost Estimate (assumption)

Assuming **$120/hour** for avg developer:

- **Backend :** 198h × $120 = **$23,760**
- **Frontend :** 280h × $120 = **$33,600**
- **DevOps + QA :** 56h × $120 = **$6,720**
- **Overhead (PM, reviews, unblocking):** ~10% = **$6,400**

**Total :** ~**$71,000–75,000** for MVP (assuming internal team or fixed cost)

**cPanel hosting :** ~$30–50/month (with DB + backups)

---

## 📈 Roadmap à long terme (Post-MVP)

**Release 1.1 (Months 3–4)**
- PDF export + email delivery for monthly letters
- "Repair flow" guided conflict resolution
- "Pause saine" (temporary pause with auto-message)

**Release 1.2 (Months 5–6)**
- Full i18n (EN/FR/KO) + timezone scheduling
- iOS app (Flutter iOS build)
- Analytics dashboard (mood trends, goals progress)

**Release 2.0+ (Months 7+)**
- Celery jobs for scheduled emails + PDF generation
- Community features (couple groups, forums)
- Advanced analytics (therapist dashboard)

---

## 🚀 Go/No-Go Decision Gates

| Gate | Timing | Decision |
|------|--------|----------|
| **G1: Auth + Pairing working locally** | End Week 1 | All endpoints tested, proceed to Features |
| **G2: Feature APIs stable** | End Week 2 | Performance acceptable, no breaking changes |
| **G3: Frontend screens 80% complete** | End Week 5 | Core features accessible, UX acceptable |
| **G4: E2E tests passing** | End Week 6 | Full workflows validated, go for deploy prep |
| **G5: cPanel deployment successful** | End Week 8 | MVP live, monitoring OK, go for launch |

If any gate fails → pause, debug, re-test. Est. impact = +1 week per blocker.

---

## 📞 Stakeholder Sign-Off

| Role | Name | Approval | Notes |
|------|------|----------|-------|
| **Tech Lead** | — | ☐ | Review architecture, timeline, risks |
| **Product Manager** | — | ☐ | Confirm scope (what's in/out MVP) |
| **DevOps / Ops** | — | ☐ | Confirm cPanel readiness + hosting plan |
| **Budget Owner** | — | ☐ | Approve cost estimate ($71k) + 8-week timeline |

---

## 📚 Full Documentation

All details in `docs/` folder:
- **00-INDEX.md** — Navigation & reading guide
- **05-Roadmap-MVP.md** — 11 phases with checklists
- **06-Timeline-Gantt.md** — Detailed schedule + effort tracking
- **07-QuickStart-Phase0-1.md** — Dev hands-on guide

---

## ✅ Next Steps

1. **Approve roadmap** → Stakeholder sign-off above
2. **Assign resources** → 2–3 devs start immediately
3. **Setup local environment** → See [Quick Start](07-QuickStart-Phase0-1.md)
4. **Kickoff Week 1** → Auth endpoints by Day 5

---

**Questions ?** Schedule sync with Tech Lead to review roadmap details.

---

**Document :** Executive Summary v1.0  
**Date :** January 16, 2026  
**Status :** Ready for sign-off
