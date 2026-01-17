# Couple App — Roadmap MVP & Documentation

**Analyse complète du projet + Feuille de route 8 semaines pour MVP**

---

## 📋 Qu'est-ce que tu trouveras ici ?

J'ai analysé complètement le projet Couple App et créé **une roadmap MVP exécutable en 8 semaines** avec :

✅ **3 nouveaux documents stratégiques**
- **Roadmap détaillée** (11 phases, checklists, risques)
- **Timeline & Gantt** (horaires, efforts estimés, dépendances)
- **Launch Checklist** (70 points de contrôle par phase)

✅ **2 documents tactiques**
- **Quick Start** (Phase 0–1 : code-ready en 48h)
- **Executive Summary** (1 page pour stakeholders)

✅ **1 guide de navigation**
- **INDEX** (directions pour chaque rôle : PM, devs, QA, ops)

---

## 🎯 L'essentiel (5 min)

### État du projet
- ✅ Architecture Django définie (7 apps prêtes)
- ✅ Modèles de données complètes
- ✅ Configuration de base (CORS, JWT, env vars)
- ❌ **0 features implémentées** → prêt pour coding

### MVP Scope (8 semaines)
- ✅ Auth (login/register)
- ✅ Pairing (invite code)
- ✅ Q&A, Goals, Check-ins, Letters
- ✅ Smart polling (real-time sync)
- ✅ Web + Android builds
- ✅ cPanel deployment

### Ressources requises
- **Backend dev :** 198 hours (5 semaines)
- **Frontend dev :** 280 hours (7 semaines)
- **DevOps :** 16 hours (1 jour)
- **Total :** ~600 person-hours (8 semaines pour équipe 2–3)

### Timeline
```
Week 1:    Foundation (Auth)
Week 2:    Smart Polling + Feature APIs
Week 3–4:  Backend Quality + Frontend Auth
Week 5–6:  Feature Screens + Polish
Week 7–8:  E2E Testing + Deployment
```

---

## 📚 Guides par rôle

### 👨‍💼 **Product Manager / Tech Lead**
1. **Start :** [Executive Summary](08-Executive-Summary.md) (10 min)
2. **Deep dive :** [Roadmap MVP](05-Roadmap-MVP.md) (45 min)
3. **Schedule :** [Timeline & Gantt](06-Timeline-Gantt.md) (30 min)
4. **Track :** [Launch Checklist](09-Launch-Checklist.md) (weekly)

### 👨‍💻 **Backend Developer**
1. **Setup :** [Quick Start](07-QuickStart-Phase0-1.md) (30 min)
   - Environment local en 15 min
   - Phase 0 checklist (Auth API)
   - Phase 1 checklist (Pairing API)
2. **Plan :** [Roadmap MVP](05-Roadmap-MVP.md) (focus Phase 0–4)
3. **Code :** Follow Phase 0–1 checklists immediately

### 👩‍💻 **Frontend Developer**
1. **Setup :** [Quick Start](07-QuickStart-Phase0-1.md) (30 min)
   - Flutter environment
   - Phase 5 checklist (Auth screens)
   - Phase 6 checklist (Pairing screens)
2. **Plan :** [Roadmap MVP](05-Roadmap-MVP.md) (focus Phase 5–8)
3. **Code :** Attend Phase 0–2 backend, puis démarre Phase 5

### 🔧 **DevOps / Deployment**
1. **Overview :** [04-Deploy-cPanel.md](04-Deploy-cPanel.md) (30 min)
2. **Deep dive :** [Roadmap MVP Phase 11](05-Roadmap-MVP.md#phase-11--deployment--launch-prep-semaine-78) (20 min)
3. **Checklist :** [Launch Checklist Phase 11](09-Launch-Checklist.md#-phase-11-deployment-on-cpanel--checkpoint-end-day-63-70)
4. **Prep :** Start Week 1 (cPanel account, DB setup)

### 🧪 **QA / Testing**
1. **Scope :** [Design Rules](03-Design-Rules.md) + Starter Pack (20 min)
2. **Test cases :** Prepare from Phase 4 onwards
3. **E2E :** Lead Phase 10 (Integration & E2E testing)

---

## 🗂️ Structure des documents

### Stratégiques (Planification)
| Doc | Audience | Lire | Quand |
|-----|----------|------|-------|
| **00-INDEX.md** | Tous | Navigation complète | Jour 1 (orientation) |
| **08-Executive Summary.md** | Stakeholders, PM | 10 min | Avant approuval |
| **05-Roadmap-MVP.md** | Tech lead, devs | 45 min | Avant démarrage |
| **06-Timeline-Gantt.md** | PM, project mgmt | 30 min | Avant démarrage |

### Tactiques (Execution)
| Doc | Audience | Lire | Quand |
|-----|----------|------|-------|
| **07-QuickStart-Phase0-1.md** | Devs | 30 min | Jour 1 (setup local) |
| **09-Launch-Checklist.md** | Tous | Weekly | Suivi hebdomadaire |

### Référence (Contexte existant)
| Doc | Audience | Lire | Quand |
|-----|----------|------|-------|
| **01-StarterPack.md** | Tous | 30 min | Jour 1 (vision) |
| **02-IA-Prompts.md** | Devs | Before coding | Si coding avec IA |
| **03-Design-Rules.md** | Devs, PM | 20 min | Continu (appliquer) |
| **04-Deploy-cPanel.md** | DevOps | 30 min | Week 8 (deployment) |

---

## ✅ Prochaines étapes immédiatement

### Jour 1 (Kickoff)
- [ ] Tech lead lit [Roadmap](05-Roadmap-MVP.md)
- [ ] PM lit [Executive Summary](08-Executive-Summary.md) + approuve scope
- [ ] Devs lisent [Quick Start](07-QuickStart-Phase0-1.md)
- [ ] Team démarrage meeting (30 min)

### Jour 1–3 (Setup)
- [ ] Backend dev setup local environment
- [ ] Frontend dev setup Flutter
- [ ] DevOps prepare cPanel account

### Jour 4–7 (Phase 0)
- [ ] Backend dev code Phase 0 (Auth API)
- [ ] Following [Quick Start checklist](07-QuickStart-Phase0-1.md#-phase-0--auth-api-jour-1-2)
- [ ] Daily standup (15 min)
- [ ] Review Friday (checkpoint Phase 0)

---

## 🎯 Key Milestones

| Checkpoint | Jour | Validation | Decision |
|------------|------|-----------|----------|
| **M1: Auth working locally** | 7 | `/login`, `/register`, JWT | Go Phase 1 |
| **M2: Pairing working locally** | 14 | 2 users pair via code | Go Phase 2 |
| **M3: All APIs complete** | 24 | CRUD endpoints tested | Go Phase 4 |
| **M4: Frontend auth screens** | 24 | Login/Register visible | Go Phase 6 |
| **M5: 1 feature end-to-end** | 35 | Q&A: create → see on other device | Go Phase 8 |
| **M6: MVP feature-complete** | 49 | All 4 features + polling | Go Phase 9 |
| **M7: E2E tests passing** | 63 | Full workflows validated | Go Phase 11 |
| **M8: LIVE on cPanel** | 70 | Production smoke tests | 🎉 Launch! |

---

## ⚠️ Top Risks (Mitigated)

1. **Polling flood** → Early perf testing (Week 2)
2. **cPanel Python incompatibility** → Verify Day 1
3. **JWT edge cases** → Simple 24h expiration for MVP
4. **Concurrent edits** → Last-write-wins + UI warning
5. **Database migration issues** → Test locally, backup procedure

See [Roadmap Risks section](05-Roadmap-MVP.md#-risques--mitigations) for full details + mitigation.

---

## 📊 Effort Estimate Summary

```
Phase     Feature         Backend   Frontend   Total
─────────────────────────────────────────────────
0–1       Auth+Pairing    8.5d      —          8.5d
2–4       APIs+Quality    10d       —          10d
5–7       Auth+Polling    —         13.5d      13.5d
8–9       Features        —         15d        15d
10–11     E2E+Deploy      2d        2d         4d
─────────────────────────────────────────────────
Total                     20.5d     30.5d      51d (shared)

Per developer (assuming 40h/week):
  Backend:  198h   = ~5 weeks
  Frontend: 280h   = ~7 weeks
  Shared:   120h   = 3 days × 2 devs
  
Together: 8 weeks for 2–3 devs ✅
```

---

## 🚀 To Get Started

1. **Click [00-INDEX.md](00-INDEX.md)** — Complete navigation by role
2. **Then follow your role's reading guide** (above)
3. **Start coding** on Day 4 (Phase 0)

---

## 💬 Questions?

- **Product scope :** Review [Starter Pack](../CoupleApp_StarterPack.md)
- **Architecture :** Review [Roadmap](05-Roadmap-MVP.md) design decisions
- **Timeline feasible ?** Review [Timeline & effort](06-Timeline-Gantt.md)
- **How to code Phase X ?** Review [Quick Start](07-QuickStart-Phase0-1.md) + [Roadmap Phase X section](05-Roadmap-MVP.md)
- **Weekly tracking :** Use [Launch Checklist](09-Launch-Checklist.md)

---

## 📌 Document Versions

| Document | Version | Date | Status |
|----------|---------|------|--------|
| 00-INDEX.md | 1.0 | Janv. 16, 2026 | ✅ Complete |
| 01-StarterPack.md | 1.0 | Janv. 16, 2026 | ✅ Existing |
| 02-IA-Prompts.md | 1.0 | Janv. 16, 2026 | ✅ Existing |
| 03-Design-Rules.md | 1.0 | Janv. 16, 2026 | ✅ Existing |
| 04-Deploy-cPanel.md | 1.0 | Janv. 16, 2026 | ✅ Existing |
| **05-Roadmap-MVP.md** | **1.0** | **Janv. 16, 2026** | **✅ NEW** |
| **06-Timeline-Gantt.md** | **1.0** | **Janv. 16, 2026** | **✅ NEW** |
| **07-QuickStart-Phase0-1.md** | **1.0** | **Janv. 16, 2026** | **✅ NEW** |
| **08-Executive-Summary.md** | **1.0** | **Janv. 16, 2026** | **✅ NEW** |
| **09-Launch-Checklist.md** | **1.0** | **Janv. 16, 2026** | **✅ NEW** |

---

**Ready to ship Couple App MVP?** 🚀

Let's go! Start with [00-INDEX.md](00-INDEX.md) or jump straight to your role's guide above.

---

**Created :** January 16, 2026  
**By :** GitHub Copilot (AI Coding Assistant)  
**For :** Couple App Starter Pack team
