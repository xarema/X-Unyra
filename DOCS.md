# 📚 Documentation Index

Bienvenue dans la documentation de Couple App! Voici comment naviguer:

## 🚀 Pour Débuter

- **[Quick Start](QUICKSTART.md)** ⭐ - Lancez l'app en 5 minutes
- **[README](README.md)** - Vue d'ensemble complète du projet
- **[Setup Guide](docs/01-StarterPack.md)** - Installation détaillée

## 📖 Documentation Principale

| Document | Description |
|----------|-------------|
| [API.md](API.md) | Documentation complète de l'API REST |
| [CONTRIBUTING.md](CONTRIBUTING.md) | Guide pour contribuer au projet |
| [README.md](README.md) | Présentation générale & features |

## 🎯 Cas d'Usage Courants

### Je veux tester l'API
→ Voir [QUICKSTART.md](QUICKSTART.md)

### Je veux développer une nouvelle feature
→ Voir [CONTRIBUTING.md](CONTRIBUTING.md) + [Architecture](#-architecture)

### Je veux intégrer l'API dans mon app
→ Voir [API.md](API.md)

### Je veux déployer en production
→ Voir [docs/04-Deploy-cPanel.md](docs/04-Deploy-cPanel.md)

### Je veux contribuer au projet
→ Voir [CONTRIBUTING.md](CONTRIBUTING.md)

## 📁 Structure de la Documentation

```
📚 Documentation/
├── 📄 README.md              # Vue d'ensemble
├── ⚡ QUICKSTART.md          # Démarrage rapide
├── 📡 API.md                 # API REST
├── 🤝 CONTRIBUTING.md        # Guide contribution
└── 📂 docs/
    ├── 01-StarterPack.md     # Installation complète
    ├── 02-IA-Prompts.md      # Prompts pour l'IA
    ├── 03-Design-Rules.md    # Règles de design
    ├── 04-Deploy-cPanel.md   # Déploiement
    ├── 05-Roadmap-MVP.md     # Roadmap du projet
    ├── 06-Timeline-Gantt.md  # Timeline
    ├── 07-QuickStart-Phase0-1.md
    ├── 08-Executive-Summary.md
    └── 09-Launch-Checklist.md
```

## 🔑 Concepts Clés

### Authentification
- JWT (JSON Web Tokens)
- Tokens d'accès & refresh
- Voir: [API.md - Authentication](API.md#-endpoints-dauthentification)

### Architecture
- Backend: Django REST + SQLite/PostgreSQL
- Frontend: Flutter (Mobile + Web)
- Voir: [README.md - Architecture](README.md#-architecture)

### Smart Polling
- Synchronisation via `GET /api/sync/changes/`
- Voir: [API.md - Sync](API.md#-endpoints-de-synchronisation)

## 👥 Pour Différents Rôles

### 👨‍💻 Développeur Backend
1. [README.md](README.md) - Vue générale
2. [docs/01-StarterPack.md](docs/01-StarterPack.md) - Setup
3. [API.md](API.md) - API Reference

### 📱 Développeur Frontend
1. [README.md](README.md) - Vue générale
2. [API.md](API.md) - API à intégrer
3. [QUICKSTART.md](QUICKSTART.md) - Tester le backend

### 🚀 DevOps/Deployment
1. [docs/04-Deploy-cPanel.md](docs/04-Deploy-cPanel.md)
2. [README.md - Deployment](README.md#-déploiement)

### 🤝 Contributeur
1. [CONTRIBUTING.md](CONTRIBUTING.md)
2. [docs/03-Design-Rules.md](docs/03-Design-Rules.md)

### 📊 Manager/Product Owner
1. [docs/08-Executive-Summary.md](docs/08-Executive-Summary.md)
2. [docs/05-Roadmap-MVP.md](docs/05-Roadmap-MVP.md)
3. [docs/09-Launch-Checklist.md](docs/09-Launch-Checklist.md)

## ❓ Questions Fréquentes

### Comment démarrer?
→ [QUICKSTART.md](QUICKSTART.md)

### Où trouver les identifiants de test?
→ [QUICKSTART.md - Tester l'API](QUICKSTART.md#️-tester-lapi)

### Comment contribuer?
→ [CONTRIBUTING.md](CONTRIBUTING.md)

### L'API est-elle en production?
→ Voir [docs/04-Deploy-cPanel.md](docs/04-Deploy-cPanel.md)

### Comment signaler un bug?
→ [CONTRIBUTING.md - Signaler un Bug](CONTRIBUTING.md#-signaler-un-bug)

## 🔗 Liens Utiles

- **GitHub**: [Lien du repo]
- **Issues**: [Issues du projet]
- **Discussions**: [Discussions]
- **Discord**: [Serveur Discord] (À venir)

## 📊 Statistiques

- **Backend**: Django + DRF
- **Frontend**: Flutter
- **Endpoints**: 20+
- **Apps**: 7 (accounts, couples, checkins, qna, goals, letters, sync)
- **Tests**: ✅ À compléter

## 🎯 Prochaines Étapes

1. Clonez le repo: `git clone ...`
2. Suivez [QUICKSTART.md](QUICKSTART.md)
3. Lisez le [README](README.md)
4. Testez l'[API.md](API.md)
5. Contribuez avec [CONTRIBUTING.md](CONTRIBUTING.md)!

---

**Besoin d'aide? Ouvrez une issue ou rejoignez nos discussions! 💬**

**Bonne lecture! 📖**
