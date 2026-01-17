import 'package:json_annotation/json_annotation.dart';

part 'goals_models.g.dart';

@JsonSerializable()
class Goal {
  final int id;
  final String title;
  @JsonKey(name: 'why_for_us')
  final String whyForUs;
  final String status; // ACTIVE, DONE, PAUSED
  @JsonKey(name: 'target_date')
  final DateTime? targetDate;
  final List<GoalAction> actions;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Goal({
    required this.id,
    required this.title,
    required this.whyForUs,
    required this.status,
    this.targetDate,
    required this.actions,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Goal.fromJson(Map<String, dynamic> json) => _$GoalFromJson(json);

  Map<String, dynamic> toJson() => _$GoalToJson(this);
}

@JsonSerializable()
class GoalAction {
  final int id;
  final String text;
  final bool done;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  GoalAction({
    required this.id,
    required this.text,
    required this.done,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GoalAction.fromJson(Map<String, dynamic> json) =>
      _$GoalActionFromJson(json);

  Map<String, dynamic> toJson() => _$GoalActionToJson(this);
}
