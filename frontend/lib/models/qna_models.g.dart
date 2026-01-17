// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qna_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Question _$QuestionFromJson(Map<String, dynamic> json) => Question(
      id: json['id'] as int,
      text: json['text'] as String,
      theme: json['theme'] as String,
      createdBy: json['created_by'] as String,
      answers: (json['answers'] as List<dynamic>)
          .map((e) => Answer.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$QuestionToJson(Question instance) => <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'theme': instance.theme,
      'created_by': instance.createdBy,
      'answers': instance.answers,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

Answer _$AnswerFromJson(Map<String, dynamic> json) => Answer(
      id: json['id'] as int,
      question: json['question'] as int,
      user: json['user'] as String,
      status: json['status'] as String,
      text: json['text'] as String,
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$AnswerToJson(Answer instance) => <String, dynamic>{
      'id': instance.id,
      'question': instance.question,
      'user': instance.user,
      'status': instance.status,
      'text': instance.text,
      'updated_at': instance.updatedAt.toIso8601String(),
    };
