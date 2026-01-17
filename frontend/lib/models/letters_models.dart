import 'package:json_annotation/json_annotation.dart';

part 'letters_models.g.dart';

@JsonSerializable()
class Letter {
  final int id;
  final int couple;
  final String month; // YYYY-MM
  final String content;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Letter({
    required this.id,
    required this.couple,
    required this.month,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Letter.fromJson(Map<String, dynamic> json) =>
      _$LetterFromJson(json);

  Map<String, dynamic> toJson() => _$LetterToJson(this);

  /// Retourne true si la lettre est du mois courant
  bool get isCurrentMonth {
    final now = DateTime.now();
    final currentMonth = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    return month == currentMonth;
  }

  /// Retourne true si la lettre peut être éditée
  bool get isEditable => isCurrentMonth;
}
