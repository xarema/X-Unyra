# 📚 Documentation Index — Couple App

**Navigation complète vers tous les documents d'architecture et planification du projet**

---

## 🎉 STATUS ACTUEL (16 janvier 2026)

### ✅ **BACKEND MVP — COMPLET!**

| Phase | Status | Tests | Temps |
|-------|--------|-------|-------|
| Phase 0 (Auth) | ✅ COMPLET | 14/14 | 4.5h |
| Phase 1 (Pairing) | ✅ COMPLET | 23/23 | 2.0h |
| Phase 2 (Sync) | ✅ COMPLET | 15/15 | 1.5h |
| Phase 3 (Features) | ✅ COMPLET | 27/27 | 1.5h |
| **TOTAL** | **✅ 79/79** | **100%** | **~9h** |

👉 **[Voir le rapport final complet](ROADMAP_UPDATE_JAN16.md)**

---

## 🎯 Pour commencer immédiatement

1. **[Backend Validation Reports](../backend/)** ← **Backend terminé!**
   - [Phase 0 Validation](../backend/PHASE0_VALIDATION_REPORT.md)
   - [Phase 1 Validation](../backend/PHASE1_VALIDATION_REPORT.md)
   - [Phase 2 Validation](../backend/PHASE2_VALIDATION_REPORT.md)
   - [Phase 3 Validation](../backend/PHASE3_VALIDATION_REPORT.md)

2. **[Roadmap Mise à Jour](ROADMAP_UPDATE_JAN16.md)** — Statut final janvier 2026
   - Backend complet (79/79 tests ✅)
   - Frontend à faire (Flutter Phase 4)
   - Timeline révisée pour frontend

3. **[Quick Start (Phase 0–1)](07-QuickStart-Phase0-1.md)** — Si tu es dev frontend
   - Comment brancher le frontend au backend
   - Authentication flow client
   - Smart polling client implementation

---

## 📋 Documents de planification

### **[Roadmap MVP (05-Roadmap-MVP.md)](05-Roadmap-MVP.md)** — Plan complet initial
- État du projet (mis à jour)
- 11 phases : Backend → Frontend → Deploy
- Chaque phase : objectifs, tâches, livrables
- Risques & mitigations
- Security checklist

### **[Timeline & Gantt (06-Timeline-Gantt.md)](06-Timeline-Gantt.md)** — Vue visuelle sur 8 semaines
- Timeline séquentielle (Backend)
- Timeline parallèle (Frontend)
- Chemin critique & dépendances
- Heures estimées
- Milestones

### **[Quick Start (Phase 0–1)](07-QuickStart-Phase0-1.md)** — Hands-on guide
- **Setup environnement** (backend + frontend)
- **Phase 0 — Auth API :** Checklist + code snippets
  - Serializers, views, tests
  - cURL validation examples
- **Phase 1 — Pairing API :** Checklist + logique métier
  - Code generation, expiration, join atomicity
- **Phase 5 — Frontend Auth :** Checklist + code patterns
  - API client, secure storage, Riverpod providers
  - Login/Register screens
- **Definition of Done :** Validations fin Phase 1–5

---

## 📐 Documents de conception & architecture

### **[Design Rules (03-Design-Rules.md)](03-Design-Rules.md)** — Règles produit
- **Core UX rules :** Langage sans blame, statuts qui dé-culpabilisent
- **Intercultural safe :** Phrases courtes, pas d'idiomes
- **Data & privacy :** Couples-only access, HTTPS, secrets en env
- **Engineering rules :** Couple-scoping, `updated_at` partout, small payloads

### **[Starter Pack (CoupleApp_StarterPack.md)](../CoupleApp_StarterPack.md)** — Vision & spec
- **Product definition :** Espace privé pour couples (goals, check-ins, Q&A, letters)
- **Tech stack :** Django + DRF, Flutter, PostgreSQL, smart polling
- **MVP features :** 6 must-haves + 2 nice-to-haves
- **Data model :** 9 tables (User, Couple, PairingInvite, Q&A, Goal, CheckIn, Letter)
- **API design :** REST endpoints (auth, couple, qna, goals, checkins, letters, sync)
- **Smart polling :** `/sync/changes?since=<timestamp>`
- **Flutter structure :** Features, domain, data layers
- **Prompts IA :** 7 prompts copy/paste pour générer code

---

## 🏗️ Structure du repo

```
couple-app-starter/
├─ docs/ ← TU ES ICI
│  ├─ 01-StarterPack.md        → Vision produit + tech stack (LIRE D'ABORD)
│  ├─ 02-IA-Prompts.md         → Prompts pour coding AI (LIRE AVANT CODING)
│  ├─ 03-Design-Rules.md       → Règles produit (CONSULTER EN CONTINU)
│  ├─ 04-Deploy-cPanel.md      → Deployment instructions (LIRE à Phase 11)
│  ├─ 05-Roadmap-MVP.md        → Plan détaillé 8 semaines (TU ES ICI)
│  ├─ 06-Timeline-Gantt.md     → Vue visuelle + efforts (TU ES ICI)
│  └─ 07-QuickStart-Phase0-1.md → Checklist codage (DEBUT SI DEV)
│
├─ backend/
│  ├─ accounts/        → User registration + login + profile
│  ├─ couples/         → Couple pairing + invite codes
│  ├─ qna/             → Questions + answers with 3 statuses
│  ├─ goals/           → Goals + micro-actions
│  ├─ checkins/        → Daily mood/stress/energy tracking
│  ├─ letters/         → Monthly letters
│  ├─ sync/            → Changes feed for smart polling
│  ├─ manage.py        → Django entry point
│  ├─ requirements.txt  → Python dependencies
│  └─ README.md        → Backend setup
│
├─ frontend/
│  ├─ lib/
│  │  ├─ features/
│  │  │  ├─ auth/      → (To implement Phase 5)
│  │  │  ├─ pairing/   → (To implement Phase 6)
│  │  │  ├─ qna/       → (To implement Phase 8)
│  │  │  ├─ goals/     → (To implement Phase 8)
│  │  │  ├─ checkins/  → (To implement Phase 8)
│  │  │  ├─ letters/   → (To implement Phase 8)
│  │  │  └─ sync/      → (To implement Phase 7)
│  │  ├─ core/
│  │  ├─ router.dart   → Navigation (GoRouter)
│  │  └─ main.dart
│  ├─ pubspec.yaml     → Flutter dependencies
│  └─ README.md        → Frontend setup
│
├─ CoupleApp_StarterPack.md   → Master document (produit + arch)
└─ README.md                  → Repo root overview
```

---

## 🎓 Lecture recommandée (par rôle)

### **Si tu es Product Manager / Tech Lead**
1. [Starter Pack](../CoupleApp_StarterPack.md) — 30 min (vision globale)
2. [Roadmap MVP](05-Roadmap-MVP.md) — 45 min (phases + efforts)
3. [Timeline & Gantt](06-Timeline-Gantt.md) — 30 min (scheduling)
4. [Design Rules](03-Design-Rules.md) — 15 min (product rules)
5. **→ Tu peux maintenant manager le projet**

### **Si tu es Backend Dev**
1. [Starter Pack](../CoupleApp_StarterPack.md) — 30 min (vision)
2. [Quick Start](07-QuickStart-Phase0-1.md) — 30 min (setup local)
3. [Roadmap MVP](05-Roadmap-MVP.md) — 20 min (focus Phase 0–4)
4. **→ Commence Phase 0 immédiatement**

### **Si tu es Frontend Dev**
1. [Starter Pack](../CoupleApp_StarterPack.md) — 30 min (vision)
2. [Quick Start](07-QuickStart-Phase0-1.md) — 30 min (setup local)
3. [Roadmap MVP](05-Roadmap-MVP.md) — 20 min (focus Phase 5–11)
4. **→ Attends que Phase 0–2 (backend) soit stables, puis démarre Phase 5**

### **Si tu es QA / Tester**
1. [Starter Pack](../CoupleApp_StarterPack.md) — 30 min (features)
2. [Design Rules](03-Design-Rules.md) — 20 min (UX rules)
3. [Roadmap MVP](05-Roadmap-MVP.md) — Focus section "Integration & E2E" (Phase 10)
4. **→ Prépare test cases dès Phase 4**

### **Si tu es DevOps / Deployment**
1. [Starter Pack](../CoupleApp_StarterPack.md) — Section "Deployment" — 15 min
2. [04-Deploy-cPanel.md](04-Deploy-cPanel.md) — 30 min (step-by-step)
3. [Roadmap MVP](05-Roadmap-MVP.md) — Phase 11 (Deployment) — 15 min
4. **→ Prépare cPanel staging dès Week 1**

---

## 🔑 Concepts clés

### **Smart Polling (au lieu de WebSockets)**
- Client appelle `/api/sync/changes?since=<timestamp>` périodiquement
- Serveur retourne IDs des ressources modifiées depuis `timestamp`
- Client fetch seulement les ressources changées
- Intervals : 5s (active), 30s (idle), stop (background)
- **Avantage :** Fonctionne sur cPanel sans serveur always-on

### **Couple-scoped data**
- Chaque ressource (Question, Goal, CheckIn, Letter) appartient à une Couple
- Chaque requête doit vérifier que l'user appartient au couple
- Jamais retourner data cross-couple (sécurité)
- Permission helper : `IsCoupleMember`

### **MVP vs Release 1.1**
- **MVP (8 semaines) :** Auth, Pairing, Q&A, Goals, Check-ins, Letters, Sync
- **1.1 (semaines 9–12) :** PDF export, Repair flow, Pause feature
- **1.2 (semaines 13+) :** i18n, iOS, advanced features

---

## 💬 FAQ rapides

**Q: Par où je commence ?**  
A: [Quick Start](07-QuickStart-Phase0-1.md) si tu codes, sinon [Roadmap](05-Roadmap-MVP.md)

**Q: Combien de temps pour MVP ?**  
A: 6–8 semaines pour équipe 2–3 devs (voir [Timeline](06-Timeline-Gantt.md))

**Q: Où sont les modèles ?**  
A: [Starter Pack](../CoupleApp_StarterPack.md) section "5) Data Model"

**Q: Quel est le chemin critique ?**  
A: Auth → Pairing → Sync → Feature APIs → Frontend → E2E → Deploy (32–35 jours)

**Q: Et si je dois passer en production plus tôt ?**  
A: Livrer une feature end-to-end à la fois. Voir Phase 10 (E2E) et Phase 11 (Deploy).

**Q: Faut-il l'internationalisation (i18n) en MVP ?**  
A: Non, scheduled pour Phase 9 (setup i18n structure, but EN only for MVP)

**Q: Quels sont les risques ?**  
A: Voir [Roadmap](05-Roadmap-MVP.md) section "Risques & Mitigations"

---

## 📞 Escalation & Help

- **Technical questions :** Check Starter Pack + Design Rules docs
- **Architecture / Design :** Ask tech lead (review Roadmap & Timeline)
- **Blockers / Risks :** Escalate immediately (see Timeline "Risk Triggers")
- **Weekly sync :** Every Friday, review [Timeline reporting template](06-Timeline-Gantt.md#📈-tracking--reporting)

---

## 📊 Documentation Status

| Document | Status | Last Update | Owner |
|----------|--------|-------------|-------|
| 01-StarterPack.md | ✅ Complete | Janv. 16, 2026 | PM |
| 02-IA-Prompts.md | ✅ Complete | Janv. 16, 2026 | PM |
| 03-Design-Rules.md | ✅ Complete | Janv. 16, 2026 | PM |
| 04-Deploy-cPanel.md | ✅ Complete | Janv. 16, 2026 | DevOps |
| **05-Roadmap-MVP.md** | ✅ **NEW** | **Janv. 16, 2026** | **Tech Lead** |
| **06-Timeline-Gantt.md** | ✅ **NEW** | **Janv. 16, 2026** | **Tech Lead** |
| **07-QuickStart-Phase0-1.md** | ✅ **NEW** | **Janv. 16, 2026** | **Tech Lead** |

---

**Prêt à démarrer ?** 🚀

→ Si tu codes : Voir [Quick Start](07-QuickStart-Phase0-1.md)  
→ Si tu planifies : Voir [Roadmap](05-Roadmap-MVP.md)  
→ Si tu veux la vision : Voir [Starter Pack](../CoupleApp_StarterPack.md)

---

**Version :** 1.0  
**Date :** 16 janvier 2026  
**Prochaine révision :** Fin semaine 1
