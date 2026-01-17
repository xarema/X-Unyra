class Answer {
  final String id;
  final int userId;
  final String status;
  final String text;
  final DateTime updatedAt;

  Answer({
    required this.id,
    required this.userId,
    required this.status,
    required this.text,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) {
    return Answer(
      id: json['id'].toString(),
      userId: (json['user_id'] as num).toInt(),
      status: (json['status'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }
}

class Question {
  final String id;
  final String theme;
  final String text;
  final int createdById;
  final DateTime updatedAt;
  final List<Answer> answers;

  Question({
    required this.id,
    required this.theme,
    required this.text,
    required this.createdById,
    required this.updatedAt,
    required this.answers,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    final answersJson = (json['answers'] as List? ?? []).cast<Map<String, dynamic>>();
    return Question(
      id: json['id'].toString(),
      theme: (json['theme'] ?? '').toString(),
      text: (json['text'] ?? '').toString(),
      createdById: (json['created_by_id'] as num).toInt(),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
      answers: answersJson.map(Answer.fromJson).toList(),
    );
  }
}
