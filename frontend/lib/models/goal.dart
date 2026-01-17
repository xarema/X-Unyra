class GoalAction {
  final String id;
  final String text;
  final bool done;

  GoalAction({required this.id, required this.text, required this.done});

  factory GoalAction.fromJson(Map<String, dynamic> json) {
    return GoalAction(
      id: json['id'].toString(),
      text: (json['text'] ?? '').toString(),
      done: (json['done'] ?? false) as bool,
    );
  }
}

class Goal {
  final String id;
  final String title;
  final String whyForUs;
  final String status;
  final List<GoalAction> actions;

  Goal({
    required this.id,
    required this.title,
    required this.whyForUs,
    required this.status,
    required this.actions,
  });

  factory Goal.fromJson(Map<String, dynamic> json) {
    final actionsJson = (json['actions'] as List? ?? []).cast<Map<String, dynamic>>();
    return Goal(
      id: json['id'].toString(),
      title: (json['title'] ?? '').toString(),
      whyForUs: (json['why_for_us'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      actions: actionsJson.map(GoalAction.fromJson).toList(),
    );
  }
}
