import 'package:json_annotation/json_annotation.dart';

part 'qna_models.g.dart';

@JsonSerializable()
class Question {
  final int id;
  final String text;
  final String theme;
  @JsonKey(name: 'created_by')
  final String createdBy;
  final List<Answer> answers;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Question({
    required this.id,
    required this.text,
    required this.theme,
    required this.createdBy,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Answer {
  final int id;
  final int question;
  final String user;
  final String status; // ANSWERED, NEEDS_TIME, CLARIFY
  final String text;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Answer({
    required this.id,
    required this.question,
    required this.user,
    required this.status,
    required this.text,
    required this.updatedAt,
  });

  factory Answer.fromJson(Map<String, dynamic> json) =>
      _$AnswerFromJson(json);

  Map<String, dynamic> toJson() => _$AnswerToJson(this);
}
