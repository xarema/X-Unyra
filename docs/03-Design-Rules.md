# Règles de conception (Couple App)

## Objectif
Créer une app calme et utile : moins de drama, plus de clarté.

## UX
- **2 minutes max** pour un check-in.
- Pas de notifications culpabilisantes.
- Tous les textes importants doivent pouvoir être écrits en **brouillon** (ex: lettre mensuelle).
- Toujours proposer un bouton “Je ne sais pas encore / besoin de temps”.

## Données
- *Local-first* possible plus tard, mais V1 = serveur (simple).
- Chaque ressource a `updated_at` (smart polling).
- **Aucune donnée sensible** dans les logs.

## Sécurité
- JWT access token court (60 min), refresh 30 jours.
- Forcer HTTPS en prod.
- CORS strict (uniquement tes domaines).
- Pairing code expirant + usage unique.

## Code (IA-friendly)
- Petites PR, petites tâches.
- Toujours demander à l'IA :
  - "écris le code"
  - "ajoute validations"
  - "ajoute tests"
- Nommer les endpoints et modèles clairement (pas de magie).

## Smart polling (Option A)
- Poll uniquement en foreground.
- 5s sur écran actif, 30-60s si inactif.
- Endpoint changes = petit payload.
