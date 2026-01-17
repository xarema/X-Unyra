# Couple App — Starter Repo (Option A)

**Goal:** ship fast on cPanel with a near-live experience (smart polling), Android-first + Web.

- Backend: Django + DRF + JWT
- DB: PostgreSQL or MySQL (via DATABASE_URL)
- Frontend: Flutter (Android + Web)

Docs: `docs/01-StarterPack.md`

## 1) Backend
See `backend/README.md`.

## 2) Frontend
See `frontend/README.md`.

## 3) Smart polling contract
- Clients call `GET /api/sync/changes?since=<ISO8601>`
- For any changed id, fetch the relevant resource (`/api/qna/questions/...`, `/api/goals/...`, etc.).
