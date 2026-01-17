/// Modèle Question
class Question {
  final String id;
  final String theme;
  final String text;
  final String createdByUsername;
  final List<Answer> answers;
  final DateTime createdAt;
  final DateTime updatedAt;

  Question({
    required this.id,
    required this.theme,
    required this.text,
    required this.createdByUsername,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      theme: json['theme'] ?? '',
      text: json['text'],
      createdByUsername: json['created_by_username'] ?? '',
      answers: (json['answers'] as List?)
              ?.map((a) => Answer.fromJson(a))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Modèle Answer
class Answer {
  final String id;
  final int userId;
  final String username;
  final String status;
  final String text;
  final DateTime updatedAt;

  Answer({
    required this.id,
    required this.userId,
    required this.username,
    required this.status,
    required this.text,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'],
      userId: json['user_id'],
      username: json['username'] ?? '',
      status: json['status'],
      text: json['text'] ?? '',
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Modèle Goal
class Goal {
  final String id;
  final String title;
  final String whyForUs;
  final String status;
  final DateTime? targetDate;
  final List<GoalAction> actions;
  final DateTime createdAt;
  final DateTime updatedAt;

  Goal({
    required this.id,
    required this.title,
    required this.whyForUs,
    required this.status,
    required this.targetDate,
    required this.actions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    return Goal(
      id: json['id'],
      title: json['title'],
      whyForUs: json['why_for_us'] ?? '',
      status: json['status'],
      targetDate: json['target_date'] != null
          ? DateTime.parse(json['target_date'])
          : null,
      actions: (json['actions'] as List?)
              ?.map((a) => GoalAction.fromJson(a))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Modèle GoalAction
class GoalAction {
  final String id;
  final String text;
  final bool done;
  final DateTime createdAt;
  final DateTime updatedAt;

  GoalAction({
    required this.id,
    required this.text,
    required this.done,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GoalAction.fromJson(Map<String, dynamic> json) {
    return GoalAction(
      id: json['id'],
      text: json['text'],
      done: json['done'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Modèle CheckIn
class CheckIn {
  final String id;
  final DateTime date;
  final int mood;
  final int stress;
  final int energy;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  CheckIn({
    required this.id,
    required this.date,
    required this.mood,
    required this.stress,
    required this.energy,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'],
      date: DateTime.parse(json['date']),
      mood: json['mood'],
      stress: json['stress'],
      energy: json['energy'],
      note: json['note'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Modèle Letter
class Letter {
  final String id;
  final String month;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Letter({
    required this.id,
    required this.month,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      id: json['id'],
      month: json['month'],
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

/// Modèle pour les changements détectés (smart polling)
class SyncChanges {
  final DateTime serverTime;
  final DateTime since;
  final Map<String, List<Change>> changes;

  SyncChanges({
    required this.serverTime,
    required this.since,
    required this.changes,
  });

  factory SyncChanges.fromJson(Map<String, dynamic> json) {
    final changesMap = <String, List<Change>>{};
    final rawChanges = json['changes'] as Map<String, dynamic>;

    rawChanges.forEach((key, value) {
      changesMap[key] = (value as List)
          .map((c) => Change.fromJson(c))
          .toList();
    });

    return SyncChanges(
      serverTime: DateTime.parse(json['server_time']),
      since: DateTime.parse(json['since']),
      changes: changesMap,
    );
  }
}

/// Modèle pour un changement individuel
class Change {
  final String id;
  final DateTime updatedAt;

  Change({
    required this.id,
    required this.updatedAt,
  });

  factory Change.fromJson(Map<String, dynamic> json) {
    return Change(
      id: json['id'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
