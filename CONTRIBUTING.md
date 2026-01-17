# 🤝 Guide de Contribution

Merci de vouloir contribuer à Couple App! Ce guide vous aidera à commencer.

## 📋 Code de Conduite

Soyez respectueux, inclusif et bienveillant envers les autres contributeurs.

## 🚀 Comment Contribuer

### 1. Fork le Projet

```bash
# Sur GitHub, cliquez sur "Fork" en haut à droite
git clone https://github.com/YOUR_USERNAME/couple-app.git
cd couple-app
git remote add upstream https://github.com/original-owner/couple-app.git
```

### 2. Créer une Branche

```bash
# Mettez à jour votre fork
git fetch upstream
git checkout upstream/main
git checkout -b feature/your-feature-name
```

### 3. Faire vos Changements

#### Pour le Backend:
- Respectez le style PEP 8
- Écrivez des tests pour les nouvelles fonctionnalités
- Documentez vos changements

#### Pour le Frontend:
- Respectez les conventions Dart
- Testez sur mobile ET web
- Gardez les performances en tête

### 4. Commiter

```bash
git add .
git commit -m "Add: description courte de la fonctionnalité"
```

**Format des messages de commit:**
- `Add:` - Nouvelle fonctionnalité
- `Fix:` - Correctif de bug
- `Refactor:` - Refactorisation du code
- `Docs:` - Mise à jour de la documentation
- `Test:` - Ajout/modification de tests

### 5. Push & Pull Request

```bash
git push origin feature/your-feature-name
```

Sur GitHub, cliquez sur "New Pull Request" et décrivez votre contribution.

## 🧪 Tests

Avant de soumettre une PR, assurez-vous que:

### Backend
```bash
cd backend
python manage.py test
python manage.py check
```

### Frontend
```bash
cd frontend
flutter test
flutter analyze
```

## 📝 Documentation

- Mettez à jour le README si vous changez l'installation
- Commentez le code complexe
- Documentez les nouvelles API endpoints

## 🐛 Signaler un Bug

### Avant de créer une issue:

1. Vérifiez que le bug n'a pas déjà été rapporté
2. Testez avec la dernière version

### Créer une issue:

1. Allez sur "Issues" → "New Issue"
2. Décrivez le problème clairement
3. Incluez les étapes pour reproduire
4. Spécifiez votre système (OS, navigateur, version)

**Exemple:**
```
Titre: Login échoue avec email contenant des majuscules

Description:
- Se connecter avec Alice@Example.com
- Réceptionner une erreur "Email invalide"
- Attendre: Accepter majuscules/minuscules

Système: macOS 14, Chrome 120, Flutter 3.38
```

## 💡 Idées de Contribution

### Facile (Bonnes pour débuter)
- [ ] Ajouter des commentaires au code
- [ ] Améliorer la documentation
- [ ] Fixer des typos
- [ ] Ajouter des tests existants

### Moyen
- [ ] Ajouter une nouvelle page Flutter
- [ ] Implémenter un nouvel endpoint API
- [ ] Améliorer les performances
- [ ] Fixer des bugs signalés

### Avancé
- [ ] Refactoriser une partie majeure
- [ ] Ajouter des tests end-to-end
- [ ] Implémenter une nouvelle fonctionnalité complexe
- [ ] Optimiser la base de données

## 📦 Structure des Branches

- `main` - Production prêt
- `develop` - Développement actif
- `feature/*` - Nouvelles fonctionnalités
- `fix/*` - Correctifs de bugs
- `docs/*` - Mises à jour de documentation

## 🔄 Processus de Révision

1. Nous examinons votre PR
2. Nous demandons des changements si nécessaire
3. Une fois approuvé, nous fusionnons dans `develop`
4. Nous fusionnons `develop` dans `main` régulièrement

## ✅ Checklist avant la PR

- [ ] Le code suit le style du projet
- [ ] Les tests passent (`flutter test`, `python manage.py test`)
- [ ] La documentation est à jour
- [ ] Le commit message est clair
- [ ] Pas de fichiers inutiles commitués

## 🎯 Priorités

Nous priorisons:
1. Les correctifs de bugs critiques
2. Les tests et documentation
3. Les améliorations de performance
4. Les nouvelles fonctionnalités

## 📞 Besoin d'Aide?

- **Documentation**: Voir [README.md](README.md)
- **Issues**: Cherchez les issues existantes
- **Discussions**: Ouvrez une discussion pour les grandes idées
- **Discord**: Rejoignez notre serveur (lien à venir)

## 🎉 Merci!

Chaque contribution, grande ou petite, aide à rendre Couple App meilleur!

---

**Heureux à contribuer! ❤️**
