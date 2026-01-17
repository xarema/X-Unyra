# ⚡ TLDR — Couple App Roadmap (2 minutes)

**Ultra-rapide : Quoi, Quand, Qui, Comment**

---

## 🎯 C'est quoi ?

**Couple App :** App mobile (Flutter) pour couples → goals, check-ins, Q&A, letters, sync en temps réel via smart polling.

**Tech Stack :** Django + DRF (backend), Flutter (frontend), PostgreSQL, JWT, cPanel.

**MVP :** 8 semaines, 2–3 devs, ~$71k.

---

## 📅 Timeline

```
Week 1:    Auth + Pairing APIs (backend)
Week 2:    Smart polling + feature APIs
Week 3–4:  Backend quality + frontend auth
Week 5–6:  Feature screens + polish
Week 7–8:  E2E tests + deployment
→ LIVE 🎉
```

---

## 👥 Effort

| Rôle | Heures | Semaines | Cost |
|------|--------|----------|------|
| Backend | 198h | 5 SEM | $24k |
| Frontend | 280h | 7 SEM | $34k |
| DevOps | 16h | 1 day | $2k |
| Other | 56h | 1 SEM | $7k |
| **TOTAL** | **600h** | **8 SEM** | **$71k** |

---

## ✅ 11 Phases

| Phase | Feature | Days |
|-------|---------|------|
| 0 | Auth API | 2.5 |
| 1 | Pairing API | 3 |
| 2 | Smart polling | 2 |
| 3 | Feature APIs | 4 |
| 4 | Backend quality | 4 |
| 5 | Frontend auth | 5 |
| 6 | Frontend pairing | 3.5 |
| 7 | Polling manager | 4.5 |
| 8 | Feature screens | 9 |
| 9 | Polish/UX | 6 |
| 10 | E2E tests | 5 |
| 11 | Deploy (cPanel) | 4 |

**Total:** 51 days = 8 weeks (2–3 devs)

---

## 🚨 Top Risks

1. **Polling flood** → Perf test Week 2
2. **cPanel Python version** → Verify Day 1
3. **JWT edge cases** → Simple 24h expiration
4. **Concurrent edits** → Last-write-wins

---

## 📚 Documents créés

| Doc | Audience | Read Time |
|-----|----------|-----------|
| [00-INDEX.md](docs/00-INDEX.md) | Navigation | 5 min |
| [05-Roadmap-MVP.md](docs/05-Roadmap-MVP.md) | Full plan | 45 min |
| [06-Timeline-Gantt.md](docs/06-Timeline-Gantt.md) | Schedule | 30 min |
| [07-QuickStart-Phase0-1.md](docs/07-QuickStart-Phase0-1.md) | **Devs START** | 30 min |
| [08-Executive-Summary.md](docs/08-Executive-Summary.md) | Stakeholders | 10 min |
| [09-Launch-Checklist.md](docs/09-Launch-Checklist.md) | Weekly track | 10 min/week |

---

## 🚀 Start (RIGHT NOW)

**Backend Dev:**
```bash
cd backend && python3 -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt
# Read docs/07-QuickStart-Phase0-1.md → Phase 0 checklist
# Start coding Auth API today!
```

**Frontend Dev:**
```bash
cd frontend && flutter pub get && flutter run -d chrome
# Wait for backend Phase 0-2
# Read docs/07-QuickStart-Phase0-1.md → Phase 5 checklist
# Then start coding Auth screens
```

**Tech Lead:**
```
Read: docs/05-Roadmap-MVP.md (45 min)
       docs/06-Timeline-Gantt.md (30 min)
       docs/09-Launch-Checklist.md (weekly)
```

**PM/Stakeholders:**
```
Read: docs/08-Executive-Summary.md (10 min) → APPROVE!
```

---

## ✅ Success Milestones

| Day | Milestone | Go/No-Go |
|-----|-----------|----------|
| 7 | Auth API working | YES → Phase 1 |
| 14 | Pairing API working | YES → Phase 2 |
| 24 | All APIs complete | YES → Phase 4 |
| 31 | Backend quality OK | YES → Phase 5 |
| 35 | 1 feature end-to-end | YES → Phase 8 |
| 49 | MVP feature-complete | YES → Phase 9 |
| 63 | E2E tests passing | YES → Phase 11 |
| 70 | Live on cPanel | 🎉 LAUNCH! |

---

## 🎯 MVP Scope

✅ **IN:** Auth, Pairing, Q&A, Goals, Check-ins, Letters, Smart polling, Web+Android  
❌ **OUT (v1.1+):** PDF export, repair flow, pause feature, i18n, iOS

---

## 📊 By the Numbers

- **0 features coded** → Start Day 1
- **11 phases** → 8 weeks
- **51 working days** → ~10 per week (2–3 devs)
- **600 person-hours** → Money: ~$71k
- **70 checkpoints** → Launch checklist

---

## 💡 Key Insight

**Chemin critique = 32–35 jours (Tech dependency flow)**
```
Auth → Pairing → Sync → APIs → Frontend → E2E → Deploy
```

Everything else parallélisable = pourquoi 8 semaines au lieu de 12.

---

## 📞 Questions?

- **"C'est faisable?"** → OUI, 8 semaines pour 2–3 devs ✅
- **"Combien ça coûte?"** → ~$71k (full salaries) ✅
- **"C'est risqué?"** → Non, risques mitigés (polling, JWT, cPanel) ✅
- **"Par où je commence?"** → Lire [Quick Start](docs/07-QuickStart-Phase0-1.md) Day 1 ✅

---

## 🎉 Bottom Line

**READY TO SHIP** ✅

Everything planned, scheduled, checkpointed.  
Start Phase 0 today.  
Live on cPanel in 8 weeks.

📂 **All docs in:** `/docs/`  
🎯 **Start reading:** Your role above or [00-INDEX.md](docs/00-INDEX.md)

---

**Version :** 1.0  
**Date :** January 16, 2026  
**Status :** READY TO GO 🚀
