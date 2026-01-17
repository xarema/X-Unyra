# 📡 Documentation API Couple App

Guide complet des endpoints API REST.

## 🔐 Authentification

Tous les endpoints (sauf auth) nécessitent un JWT token.

### Header d'Authentification

```
Authorization: Bearer <access_token>
```

### Format de Réponse d'Erreur

```json
{
  "detail": "Message d'erreur"
}
```

ou

```json
{
  "field_name": ["Erreur sur ce champ"]
}
```

---

## 🔑 Endpoints d'Authentification

### POST /api/auth/register/

Créer un nouveau compte utilisateur.

**Request:**
```json
{
  "username": "john",
  "email": "john@example.com",
  "password": "SecurePass123!",
  "password_confirm": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe",
  "language": "fr",
  "timezone": "Europe/Paris"
}
```

**Response (201 Created):**
```json
{
  "user": {
    "id": 1,
    "username": "john",
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "language": "fr",
    "timezone": "Europe/Paris"
  },
  "access": "eyJhbGciOiJIUzI1NiIs...",
  "refresh": "eyJhbGciOiJIUzI1NiIs..."
}
```

---

### POST /api/auth/login/

Se connecter avec email/password.

**Request:**
```json
{
  "email": "john@example.com",
  "password": "SecurePass123!"
}
```

**Response (200 OK):**
```json
{
  "user": {...},
  "access": "eyJhbGciOiJIUzI1NiIs...",
  "refresh": "eyJhbGciOiJIUzI1NiIs..."
}
```

---

### POST /api/auth/refresh/

Rafraîchir le token d'accès avec le refresh token.

**Request:**
```json
{
  "refresh": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Response (200 OK):**
```json
{
  "access": "eyJhbGciOiJIUzI1NiIs..."
}
```

---

### GET /api/auth/me/

Récupérer les infos de l'utilisateur connecté.

**Response (200 OK):**
```json
{
  "user": {
    "id": 1,
    "username": "john",
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "language": "fr",
    "timezone": "Europe/Paris"
  }
}
```

---

## 💑 Endpoints de Couple

### GET /api/couple/

Récupérer le couple de l'utilisateur connecté.

**Response (200 OK):**
```json
{
  "couple": {
    "id": "6ec43962-d272-409d-bc1e-301dc69b0650",
    "partner_a": {
      "id": 24,
      "username": "alice",
      "language": "fr",
      "timezone": "UTC"
    },
    "partner_b": {
      "id": 25,
      "username": "bob",
      "language": "fr",
      "timezone": "UTC"
    },
    "created_at": "2026-01-17T02:52:08.559553Z",
    "updated_at": "2026-01-17T02:52:08.559856Z"
  }
}
```

**Response (404 Not Found):**
```json
{
  "detail": "Pas de couple trouvé."
}
```

---

### POST /api/couple/create/

Créer un nouveau couple (l'utilisateur devient partner_a).

**Response (201 Created):**
```json
{
  "couple": {
    "id": "uuid",
    "partner_a": {...},
    "partner_b": null,
    "created_at": "2026-01-17T...",
    "updated_at": "2026-01-17T..."
  }
}
```

**Response (400 Bad Request):**
```json
{
  "detail": "L'utilisateur est déjà dans un couple."
}
```

---

### POST /api/couple/invite/

Générer un code d'invitation pour rejoindre le couple.

**Request:**
```json
{
  "ttl_minutes": 60
}
```

**Response (200 OK):**
```json
{
  "invite": {
    "id": 123,
    "code": "123456",
    "expires_at": "2026-01-17T03:52:08Z",
    "used_at": null
  }
}
```

---

### POST /api/couple/join/

Rejoindre un couple avec un code d'invitation.

**Request:**
```json
{
  "code": "123456"
}
```

**Response (200 OK):**
```json
{
  "couple": {...}
}
```

**Response (400 Bad Request):**
```json
{
  "detail": "Code invalide ou expiré."
}
```

---

## ✅ Endpoints de Check-in

### GET /api/checkins/

Lister tous les check-ins du couple.

**Query Parameters:**
- `limit` (int, default=50): Nombre de résultats
- `offset` (int, default=0): Décalage

**Response (200 OK):**
```json
{
  "count": 42,
  "next": "http://localhost:8000/api/checkins/?offset=50",
  "previous": null,
  "results": [
    {
      "id": 1,
      "user": {
        "id": 24,
        "username": "alice"
      },
      "mood": "happy",
      "energy": 8,
      "notes": "Belle journée!",
      "created_at": "2026-01-17T02:00:00Z"
    }
  ]
}
```

---

### POST /api/checkins/

Créer un nouveau check-in.

**Request:**
```json
{
  "mood": "happy",
  "energy": 8,
  "notes": "Bonne journée!"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "user": {...},
  "mood": "happy",
  "energy": 8,
  "notes": "Bonne journée!",
  "created_at": "2026-01-17T02:00:00Z"
}
```

---

### GET /api/checkins/{id}/

Récupérer un check-in spécifique.

**Response (200 OK):**
```json
{
  "id": 1,
  "user": {...},
  "mood": "happy",
  "energy": 8,
  "notes": "Bonne journée!",
  "created_at": "2026-01-17T02:00:00Z"
}
```

---

## ❓ Endpoints Q&A

### GET /api/qna/questions/

Lister les questions disponibles.

**Response (200 OK):**
```json
{
  "count": 100,
  "results": [
    {
      "id": 1,
      "text": "Quel a été ton meilleur moment cette semaine?",
      "theme": "reflection",
      "created_at": "2026-01-15T00:00:00Z"
    }
  ]
}
```

---

### POST /api/qna/answers/

Répondre à une question.

**Request:**
```json
{
  "question": 1,
  "status": "answered",
  "text": "Un jour en nature avec mon partenaire!"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "user": {...},
  "question": {
    "id": 1,
    "text": "Quel a été ton meilleur moment cette semaine?"
  },
  "status": "answered",
  "text": "Un jour en nature avec mon partenaire!",
  "created_at": "2026-01-17T02:00:00Z"
}
```

---

### GET /api/qna/answers/

Lister les réponses de l'utilisateur.

**Response (200 OK):**
```json
{
  "count": 15,
  "results": [...]
}
```

---

## 🎯 Endpoints de Buts/Objectifs

### GET /api/goals/

Lister les objectifs du couple.

**Response (200 OK):**
```json
{
  "count": 5,
  "results": [
    {
      "id": 1,
      "title": "Voyager en Europe",
      "description": "Faire un road trip à travers l'Europe",
      "status": "in_progress",
      "created_at": "2026-01-01T00:00:00Z",
      "due_date": "2026-12-31T00:00:00Z"
    }
  ]
}
```

---

### POST /api/goals/

Créer un nouvel objectif.

**Request:**
```json
{
  "title": "Apprendre une langue",
  "description": "Apprendre l'espagnol ensemble",
  "due_date": "2026-12-31T00:00:00Z"
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "title": "Apprendre une langue",
  "description": "Apprendre l'espagnol ensemble",
  "status": "not_started",
  "created_at": "2026-01-17T02:00:00Z",
  "due_date": "2026-12-31T00:00:00Z"
}
```

---

## 💌 Endpoints de Lettres

### GET /api/letters/

Lister les lettres reçues.

**Response (200 OK):**
```json
{
  "count": 10,
  "results": [
    {
      "id": 1,
      "from_user": {
        "id": 24,
        "username": "alice"
      },
      "subject": "Merci pour hier",
      "content": "Merci pour cette belle soirée...",
      "created_at": "2026-01-17T02:00:00Z",
      "read_at": null
    }
  ]
}
```

---

### POST /api/letters/

Envoyer une lettre au partenaire.

**Request:**
```json
{
  "subject": "Je t'aime",
  "content": "Contenu de la lettre d'amour..."
}
```

**Response (201 Created):**
```json
{
  "id": 1,
  "from_user": {...},
  "subject": "Je t'aime",
  "content": "Contenu de la lettre d'amour...",
  "created_at": "2026-01-17T02:00:00Z",
  "read_at": null
}
```

---

## 🔄 Endpoints de Synchronisation

### GET /api/sync/changes/

Obtenir les changements depuis une date donnée (smart polling).

**Query Parameters:**
- `since` (ISO8601): Timestamp depuis lequel récupérer les changements

**Request:**
```
GET /api/sync/changes/?since=2026-01-17T00:00:00Z
```

**Response (200 OK):**
```json
{
  "checkins": [
    {
      "id": 1,
      "changed_at": "2026-01-17T02:00:00Z"
    }
  ],
  "questions": [],
  "answers": [...],
  "goals": [...],
  "letters": [...]
}
```

---

## 📊 Codes d'Erreur

| Code | Signification |
|------|---------------|
| 200 | OK |
| 201 | Créé |
| 204 | Pas de contenu |
| 400 | Mauvaise requête |
| 401 | Non authentifié |
| 403 | Interdit |
| 404 | Non trouvé |
| 500 | Erreur serveur |

---

## 🔗 Tester l'API

### Avec cURL

```bash
# Login
curl -X POST http://localhost:8000/api/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"email":"alice@example.com","password":"testpass123"}'

# Récupérer le couple
curl -X GET http://localhost:8000/api/couple/ \
  -H "Authorization: Bearer <token>"
```

### Avec Postman

1. Importer la collection: [Lien à ajouter]
2. Configurer la variable `base_url`: `http://localhost:8000`
3. Lancer une requête!

### Avec Python

```python
import requests

# Login
response = requests.post(
  'http://localhost:8000/api/auth/login/',
  json={'email': 'alice@example.com', 'password': 'testpass123'}
)
token = response.json()['access']

# Couple
headers = {'Authorization': f'Bearer {token}'}
response = requests.get(
  'http://localhost:8000/api/couple/',
  headers=headers
)
print(response.json())
```

---

**Documentation complète! Commencez à intégrer! 🚀**
