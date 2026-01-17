// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkins_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckIn _$CheckInFromJson(Map<String, dynamic> json) => CheckIn(
      id: json['id'] as int,
      couple: json['couple'] as int,
      user: json['user'] as String,
      date: DateTime.parse(json['date'] as String),
      mood: json['mood'] as int,
      stress: json['stress'] as int,
      energy: json['energy'] as int,
      note: json['note'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$CheckInToJson(CheckIn instance) => <String, dynamic>{
      'id': instance.id,
      'couple': instance.couple,
      'user': instance.user,
      'date': instance.date.toIso8601String(),
      'mood': instance.mood,
      'stress': instance.stress,
      'energy': instance.energy,
      'note': instance.note,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
