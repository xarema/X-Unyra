# Couple App — Starter Pack (Option A: Django + Smart Polling)

**Target:** ship fast with AI-assisted coding.

- **Android first** (release 1)
- **Web version** (same features)
- **iOS later**
- **Hosting:** cPanel
- **Backend:** Python (**Django + Django REST Framework**)
- **Database:** **PostgreSQL** (preferred) or MySQL
- **Near-live:** **Smart polling** (no WebSockets; reliable on cPanel)

This single document is meant to be opened in **IntelliJ IDEA** (Markdown preview) and used as your build plan.

---

## 0) One-sentence product definition

A private couple space to align on **goals**, do **daily/weekly check-ins**, answer **guided Q&A**, write **monthly letters**, and keep everything calm, structured, and intercultural-friendly.

---

## 1) Chosen Approach

### Why Option A (Django + Polling)

- **Fastest to deploy on cPanel** (typical Python WSGI)
- No “always-on” WebSocket server to maintain
- Still feels “live” with **smart polling** + efficient “changes feed”
- Simple enough to generate large parts with an AI coder

### What “smart polling” means

- Poll only when needed (active screen)
- Poll slower when app is idle (foreground, no active screen)
- Stop in background
- Use a **changes endpoint**: `/api/sync/changes?since=<timestamp>`
- Then fetch only what changed

---

## 2) Tech Stack

### Backend
- Python 3.x
- Django
- Django REST Framework
- JWT auth (simple; secure)
- (Optional) Celery for scheduled jobs later (monthly PDF generation)

### Database
- PostgreSQL (recommended)
- MySQL (OK if it’s easier on cPanel)

### Clients
- **Flutter**: single codebase for **Android + Web**
- State management: Riverpod (or Bloc, but Riverpod is fast for MVP)

### Caching / optional
- Redis (available): optional for rate limiting / caching / future tasks

---

## 3) Repo Layout (monorepo)

```
couple-app/
  backend/
    manage.py
    config/
    apps/
      accounts/
      couples/
      qna/
      goals/
      checkins/
      letters/
      sync/
    requirements.txt
    .env.example
  frontend/
    pubspec.yaml
    lib/
      app/
      features/
        auth/
        pairing/
        qna/
        goals/
        checkins/
        letters/
        sync/
      shared/
      main.dart
  docs/
    CoupleApp_StarterPack.md
```

---

## 4) MVP Features (Release 1)

### Must-have
1) **Auth** (register/login)
2) **Pairing** (create couple + invite code + join)
3) **Q&A** (questions, answers with status)
4) **Goals** (goal + micro-actions)
5) **Check-in** (mood/stress/energy + note)
6) **Monthly letter** (guided writing, saved content)
7) **Near-live** updates via polling

### Nice-to-have (Release 1.1)
- “Pause saine” button (I need time; I’ll come back)
- “Repair flow” after tension (fact/interpretation/feeling/need/proposal)
- Templates for Q&A themes

---

## 5) Data Model (Backend)

### Core rules
- Every resource belongs to a **Couple**
- Every request must be scoped to the user’s couple
- Every table has `updated_at` for sync

### Tables / models (MVP)

**User (accounts)**
- email (unique)
- password hash
- display_name
- language (en/fr/ko)
- timezone (default: America/Montreal)
- created_at, updated_at

**Couple (couples)**
- id (UUID)
- partner_a (FK User)
- partner_b (FK User, nullable until join)
- created_at, updated_at

**PairingInvite (couples)**
- couple (FK)
- code (6-digit string)
- expires_at
- used_at (nullable)
- created_at

**Question (qna)**
- couple (FK)
- theme (string)
- text (text)
- created_by (FK User)
- created_at, updated_at

**Answer (qna)**
- question (FK)
- user (FK)
- status (enum): ANSWERED | NEEDS_TIME | CLARIFY
- text (text, nullable)
- updated_at

**Goal (goals)**
- couple (FK)
- title
- why_for_us
- owner_user (FK User, nullable)
- status: ACTIVE | PAUSED | DONE
- target_date (nullable)
- updated_at

**GoalAction (goals)**
- goal (FK)
- text
- done (bool)
- updated_at

**CheckIn (checkins)**
- couple (FK)
- user (FK)
- date (date) (unique per user/day)
- mood (0–10)
- stress (0–10)
- energy (0–10)
- note (nullable)
- updated_at

**Letter (letters)**
- couple (FK)
- month (YYYY-MM)
- content (text/markdown)
- updated_at

> Index: add DB indexes on `(couple_id, updated_at)` for fast change queries.

---

## 6) API Design (REST)

### Auth
- `POST /api/auth/register`
- `POST /api/auth/login` (returns JWT)
- `GET /api/me`

### Couple / Pairing
- `POST /api/couple/create`
- `POST /api/couple/invite` (returns code)
- `POST /api/couple/join` (code)
- `GET /api/couple`

### Q&A
- `GET /api/qna/questions`
- `POST /api/qna/questions`
- `GET /api/qna/questions/{id}`
- `PUT /api/qna/questions/{id}`
- `POST /api/qna/questions/{id}/answer` (status + text)

### Goals
- `GET /api/goals`
- `POST /api/goals`
- `PUT /api/goals/{id}`
- `POST /api/goals/{id}/actions`
- `PUT /api/goals/actions/{action_id}`

### Check-ins
- `GET /api/checkins?from=YYYY-MM-DD&to=YYYY-MM-DD&user=me`
- `POST /api/checkins`
- `PUT /api/checkins/{id}`

### Letters
- `GET /api/letters?month=YYYY-MM`
- `POST /api/letters` (create or update)

---

## 7) Sync / Near-Live (Smart Polling)

### Endpoint
`GET /api/sync/changes?since=<ISO-8601 timestamp>`

### Response example
```json
{
  "server_time": "2026-01-16T13:00:05Z",
  "changes": {
    "qna": ["uuid1", "uuid2"],
    "goals": ["uuid3"],
    "checkins": [],
    "letters": ["uuid4"]
  }
}
```

### Client algorithm
1) Store `lastSyncTime` locally
2) Call `/changes?since=lastSyncTime`
3) For each changed ID, fetch only that resource:
   - Q&A: `GET /qna/questions/{id}`
   - Goals: `GET /goals/{id}` (or re-fetch list if simpler in MVP)
4) Set `lastSyncTime = server_time`

### Polling intervals (recommended)
- Active screen (Q&A / Goals): every **5s**
- Foreground idle: every **30–60s**
- Background: **stop**

---

## 8) Flutter App Structure

### Screens
- Auth (login/register)
- Pairing (create/join)
- Tabs:
  - Goals
  - Q&A
  - Check-in
  - Letter

### Folder guidance
- `features/<feature>/data` (api clients, DTO)
- `features/<feature>/domain` (models)
- `features/<feature>/ui` (screens, widgets)
- `features/sync` (polling manager)

### “Polling Manager” concept
- A singleton/service that can:
  - start/stop polling
  - change interval depending on active route
  - broadcast change events to feature stores

---

## 9) Design Rules (Product)

### Core UX rules
- **No blame language**: everything framed as needs, feelings, clarity
- **Statuses remove pressure**:
  - “Needs time” is a first-class answer
  - “Clarify” is a first-class answer
- **Intercultural safe**:
  - Short sentences
  - Avoid idioms
  - “Soft tone” templates
- **Small wins**:
  - micro-actions for goals
  - tiny check-ins

### Data & privacy rules
- Couples-only access: never leak cross-couple data
- Minimal data collection
- HTTPS only
- Store secrets in env vars

### Engineering rules
- Every API list endpoint must scope by couple
- Use `updated_at` everywhere for sync
- Keep payloads small (IDs in changes feed)

---

## 10) Prompts (copy/paste) to Build Fast With AI

Use these prompts with your coding AI (edit names if needed).

### Prompt A — Create the Django project skeleton
"""
Generate a Django project named `config` with apps:
accounts, couples, qna, goals, checkins, letters, sync.
Use Django REST Framework and JWT auth.
Add `created_at` and `updated_at` fields.
Provide `requirements.txt`, `.env.example`, and basic settings.
"""

### Prompt B — Models
"""
Implement Django models for:
User profile fields (display_name, language, timezone), Couple, PairingInvite,
Question, Answer (status enum), Goal, GoalAction, CheckIn, Letter.
Ensure each model has updated_at for sync and couple scoping.
Create migrations.
"""

### Prompt C — Permissions & scoping
"""
Implement DRF permissions so that every request is scoped to the authenticated user's couple.
Add helper function get_user_couple(user) and enforce filtering in all querysets.
"""

### Prompt D — API endpoints
"""
Create DRF serializers and viewsets/endpoints:
- /api/auth/register, /api/auth/login (JWT), /api/me
- /api/couple/create, /api/couple/invite, /api/couple/join, /api/couple
- CRUD for Q&A questions, and POST /questions/{id}/answer
- CRUD for goals and goal actions
- CRUD for checkins (enforce one per user per date)
- letters get by month and create/update
Include URL routing.
"""

### Prompt E — Sync changes feed
"""
Create endpoint GET /api/sync/changes?since=<timestamp>.
Return server_time and IDs of changed resources per feature.
Only include resources belonging to the user's couple.
Optimize using updated_at and indexes.
"""

### Prompt F — Flutter skeleton
"""
Generate a Flutter app with Riverpod.
Screens: Auth, Pairing, and a bottom tab navigation with Goals, Q&A, Check-in, Letter.
Create API client with JWT storage.
Implement a PollingManager that calls /api/sync/changes and triggers feature refresh.
"""

### Prompt G — UI tone templates
"""
Create a small dictionary of 'soft tone' template messages for:
- Needs time
- Clarify
- Pause healthy
Return English first, optional French and Korean variants.
"""

---

## 11) Deployment Notes (cPanel)

### Backend (Django)
- Use cPanel Python app setup (WSGI)
- Add env vars from `.env`
- Install requirements
- Run migrations

### Database
- Create PostgreSQL (preferred) or MySQL database + user in cPanel
- Put credentials in env vars

### Frontend (Flutter Web)
- Build web: `flutter build web`
- Upload static files to a subdomain or public_html folder

### Android
- Build AAB/APK with Flutter

---

## 12) Development Checklist (first 48 hours)

1) Repo created + Git connected (cPanel Git Version Control)
2) Django project boots locally
3) JWT auth working
4) Couple create/join flow complete
5) Q&A create/answer complete
6) Sync endpoint working
7) Flutter basic screens + login + list Q&A
8) Polling manager refreshes Q&A changes

---

## 13) Security Minimums (do not skip)

- Always filter by couple in every query
- Use HTTPS
- Use strong secret keys (env)
- JWT expiration + refresh strategy (simple)
- Rate limit login endpoint (optional; can be added later)

---

## 14) Next Up (after MVP)

- PDF export for monthly letter
- “Repair flow” (guided conflict repair)
- “Pause saine” feature with reassuring auto-message
- i18n (EN/FR/KO) and timezone-aware scheduling

---

## 15) Glossary

- **MVP**: minimum viable product
- **DRF**: Django REST Framework
- **JWT**: JSON Web Token
- **Polling**: client periodically checks for updates
- **Changes feed**: endpoint that returns what changed since last sync

