class CheckIn {
  final String id;
  final DateTime date;
  final int mood;
  final int stress;
  final int energy;
  final String note;

  CheckIn({
    required this.id,
    required this.date,
    required this.mood,
    required this.stress,
    required this.energy,
    required this.note,
  });

  factory CheckIn.fromJson(Map<String, dynamic> json) {
    return CheckIn(
      id: json['id'].toString(),
      date: DateTime.parse(json['date'].toString()),
      mood: (json['mood'] as num).toInt(),
      stress: (json['stress'] as num).toInt(),
      energy: (json['energy'] as num).toInt(),
      note: (json['note'] ?? '').toString(),
    );
  }
}
