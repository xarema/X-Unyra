import 'package:json_annotation/json_annotation.dart';

part 'checkins_models.g.dart';

@JsonSerializable()
class CheckIn {
  final int id;
  final int couple;
  final String user;
  final DateTime date;
  final int mood; // 1-10
  final int stress; // 1-10
  final int energy; // 1-10
  final String note;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  CheckIn({
    required this.id,
    required this.couple,
    required this.user,
    required this.date,
    required this.mood,
    required this.stress,
    required this.energy,
    required this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) =>
      _$CheckInFromJson(json);

  Map<String, dynamic> toJson() => _$CheckInToJson(this);
}
