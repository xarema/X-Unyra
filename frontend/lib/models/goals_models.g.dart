// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goals_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Goal _$GoalFromJson(Map<String, dynamic> json) => Goal(
      id: json['id'] as int,
      title: json['title'] as String,
      whyForUs: json['why_for_us'] as String,
      status: json['status'] as String,
      targetDate: json['target_date'] == null
          ? null
          : DateTime.parse(json['target_date'] as String),
      actions: (json['actions'] as List<dynamic>)
          .map((e) => GoalAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$GoalToJson(Goal instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'why_for_us': instance.whyForUs,
      'status': instance.status,
      'target_date': instance.targetDate?.toIso8601String(),
      'actions': instance.actions,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

GoalAction _$GoalActionFromJson(Map<String, dynamic> json) => GoalAction(
      id: json['id'] as int,
      text: json['text'] as String,
      done: json['done'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$GoalActionToJson(GoalAction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'done': instance.done,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
