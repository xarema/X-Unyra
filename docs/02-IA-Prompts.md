# IA Prompts — Couple App (Option A)

Copie/colle ces prompts dans ton IA de code (ou dans ChatGPT) en donnant le chemin de fichier à écrire/modifier.

## 1) Backend — générer rapidement

### 1.1 Modèles + migrations
> "Dans un projet Django DRF existant, implémente les modèles pour l'app `qna` (Question, Answer) avec `updated_at` indexé, unique constraint (question,user), et admin. Puis génère les migrations."

### 1.2 Endpoints DRF
> "Ajoute un ViewSet DRF pour `Question` filtré par le couple de l'utilisateur. Ajoute une action POST `/answer/` qui crée/met à jour l'Answer pour l'utilisateur courant (status+text)."

### 1.3 Sync / Smart polling
> "Implémente `GET /api/sync/changes?since=...` qui retourne `{server_time, since, changes:{qna_questions:[{id,updated_at}], ...}}` en ne renvoyant que les entités du couple."

### 1.4 Permissions
> "Crée une permission `IsCoupleMember` et applique-la aux endpoints sensibles."

## 2) Flutter — génération rapide

### 2.1 Auth
> "Crée un service d'auth Flutter (Dio + secure storage) pour `/auth/register` et `/auth/login` (JWT). Ajoute un écran Login/Register simple."

### 2.2 Pairing
> "Crée un écran Pairing: create couple, invite code, join with code, et navigation vers home."

### 2.3 Smart polling
> "Implémente un PollingManager qui appelle `/sync/changes` toutes les 5s quand l'app est au premier plan. Si changes non vides, invalide les providers Riverpod correspondants."

## 3) Prompts “qualité”

### 3.1 Tests
> "Ajoute des tests unitaires pour la création de couple et join via code (cas ok + cas expiré + cas déjà paired)."

### 3.2 Sécurité
> "Ajoute rate-limit simple sur `/couple/join` et `/auth/login` (anti brute force) en utilisant Redis si dispo, sinon cache local Django."
