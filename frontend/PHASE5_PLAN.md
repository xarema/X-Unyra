# PHASE 5 — Frontend Flutter — Q&A + Goals + Check-ins Screens

**Status**: À faire  
**Date**: 16 janvier 2026  
**Durée estimée**: 8 heures  
**Équipe**: 1 dev Flutter  

---

## 🎯 Objectifs

1. ✅ Smart Polling Client
2. ✅ Q&A Screen (list, create, answer)
3. ✅ Goals Screen (list, create, update)
4. ✅ Check-ins Screen (daily mood tracking)
5. ✅ Letters Screen (monthly reflections)
6. ✅ Bottom Navigation (switch entre tabs)

---

## 📋 Tâches Détaillées

### Tâche 1: Smart Polling Service (1h)

**Fichier**: `lib/core/services/polling_service.dart`

```dart
class SmartPollingService {
  // Polling automatique chaque 3 secondes
  // Change detection sur 7 resource types
  // Refresh des données dans Riverpod
  
  Future<void> startPolling(String since);
  Future<void> stopPolling();
}
```

**Provider Riverpod**:
```dart
final pollingServiceProvider = Provider((ref) => SmartPollingService());
final lastSyncProvider = StateProvider<DateTime>((ref) => DateTime.now());
final changesProvider = FutureProvider<Map>((ref) async { ... });
```

**Tests**:
- [ ] Polling déclenche les 3 secondes
- [ ] Change detection fonctionne
- [ ] Riverpod state se met à jour

---

### Tâche 2: Q&A Models et Providers (1h)

**Fichier**: `lib/models/qna_models.dart`

```dart
class Question {
  int id;
  String text;
  String theme;
  String createdBy; // "alice" ou "bob"
  List<Answer> answers;
  DateTime createdAt;
}

class Answer {
  int id;
  int questionId;
  String user;
  String status; // ANSWERED, NEEDS_TIME, CLARIFY
  String text;
  DateTime updatedAt;
}
```

**Providers**: `lib/providers/qna_provider.dart`

```dart
final questionsProvider = FutureProvider<List<Question>>((ref) async { ... });
final createQuestionProvider = FutureProvider.family((ref, String text) async { ... });
final answerQuestionProvider = FutureProvider.family((ref, Answer) async { ... });
```

---

### Tâche 3: Q&A Screen (2h)

**Fichier**: `lib/features/qna/screens/qna_screen.dart`

```dart
class QnaScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ListView des questions
    // Chaque question affiche:
    //   - Texte de la question
    //   - Créateur (Alice ou Bob)
    //   - Réponses (afficher le statut + texte)
    // Bouton FAB pour créer une question
    // TextField en bas pour entrer la réponse
  }
}
```

**UX Flow**:
```
1. Afficher liste des questions
2. User clique sur question → voir les réponses
3. User peut ajouter sa réponse (si pas répondu)
4. User peut modifier sa réponse (si déjà répondu)
5. Tapper FAB → dialog "Nouvelle question"
```

---

### Tâche 4: Goals Models et Screen (1.5h)

**Fichier**: `lib/models/goals_models.dart`

```dart
class Goal {
  int id;
  String title;
  String whyForUs;
  String status; // ACTIVE, DONE, PAUSED
  DateTime? targetDate;
  List<GoalAction> actions;
}

class GoalAction {
  int id;
  String text;
  bool done;
}
```

**Screen**: `lib/features/goals/screens/goals_screen.dart`

```
- Afficher liste des buts (filtrés par status)
- Chaque but affiche:
  - Titre
  - Pourquoi c'est important
  - Status (badge ACTIVE/DONE/PAUSED)
  - Checkbox pour chaque action
- Bouton FAB → créer nouveau but
- Swipe ou clic → modifier le but
```

---

### Tâche 5: Check-ins Screen (1.5h)

**Fichier**: `lib/features/checkins/screens/checkins_screen.dart`

```dart
class CheckInScreen extends ConsumerWidget {
  // Afficher un formulaire pour faire un check-in:
  // - Date (aujourd'hui)
  // - Mood (1-10 slider)
  // - Stress (1-10 slider)
  // - Energy (1-10 slider)
  // - Note (TextField)
  // Bouton submit
  
  // Historique des check-ins des 7 derniers jours
}
```

**UX Flow**:
```
1. User voit formulaire check-in
2. Remplit mood/stress/energy (sliders)
3. Ajoute une note optionnelle
4. Clique "Enregistrer"
5. Voit l'historique des 7 jours avec graphiques
```

---

### Tâche 6: Letters Screen (1h)

**Fichier**: `lib/features/letters/screens/letters_screen.dart`

```dart
class LettersScreen extends ConsumerWidget {
  // Afficher la lettre du mois courant
  // Éditable si on est dans le même mois
  // Lecture seule si c'est un mois passé
  // Liste des lettres passées (scroll horizontal)
}
```

---

### Tâche 7: Bottom Navigation (1h)

**Fichier**: `lib/features/home/home_shell.dart`

```dart
class HomeShell extends ConsumerStatefulWidget {
  // BottomNavigationBar avec 5 tabs:
  // - Q&A (chat bubble icon)
  // - Goals (target icon)
  // - Check-ins (heart icon)
  // - Letters (envelope icon)
  // - Settings (gear icon)
  
  // PageView ou similar pour switch entre screens
}
```

---

## 🔄 Smart Polling Integration

Une fois SmartPollingService implémentée:

```dart
@override
void didChangeDependencies() {
  ref.read(pollingServiceProvider).startPolling(
    ref.read(lastSyncProvider).toIso8601String()
  );
  super.didChangeDependencies();
}

@override
void dispose() {
  ref.read(pollingServiceProvider).stopPolling();
  super.dispose();
}
```

Cela va:
1. Appeler `/api/sync/changes?since=...` chaque 3 secondes
2. Détecter les changements
3. Mettre à jour les providers Riverpod
4. Les screens observent les changes et se mettent à jour automatiquement

---

## 📊 Architecture Data Flow

```
Backend
  ↓
/api/sync/changes (chaque 3s)
  ↓
SmartPollingService
  ↓
Riverpod Providers (questionsProvider, goalsProvider, etc.)
  ↓
Screens observent les providers
  ↓
UI se met à jour automatiquement
```

---

## ✅ Checklist d'Implémentation

- [ ] SmartPollingService créée
- [ ] Polling déclenche le backend
- [ ] Change detection fonctionne
- [ ] Q&A Models + Providers
- [ ] Q&A Screen + CRUD
- [ ] Goals Models + Providers
- [ ] Goals Screen + CRUD
- [ ] Check-ins Screen + form
- [ ] Letters Screen + read/write
- [ ] Bottom Navigation
- [ ] Intégration du polling partout
- [ ] Tous les écrans se mettent à jour en live
- [ ] Error handling global
- [ ] Loading states partout
- [ ] Tests unitaires (optionnel)

---

## 🚀 Timeline Proposée

```
Jour 1 (4h):
- SmartPollingService
- Q&A Models + Providers + Screen

Jour 2 (4h):
- Goals Screen
- Check-ins Screen
- Letters Screen
- Bottom Navigation
- Testing + fixes
```

**Total**: 8 heures pour 1 dev

---

## 🎉 Après Phase 5

Le MVP sera **100% COMPLET** avec:
- ✅ Backend API (79/79 tests passing)
- ✅ Frontend Flutter (toutes les screens)
- ✅ Smart Polling (live data)
- ✅ Authentification
- ✅ Appairage Couple
- ✅ Q&A, Goals, Check-ins, Letters

**Prêt pour Phase 6 — Déploiement sur cPanel!** 🚀
