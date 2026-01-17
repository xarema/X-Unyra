// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letters_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Letter _$LetterFromJson(Map<String, dynamic> json) => Letter(
      id: json['id'] as int,
      couple: json['couple'] as int,
      month: json['month'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$LetterToJson(Letter instance) => <String, dynamic>{
      'id': instance.id,
      'couple': instance.couple,
      'month': instance.month,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
