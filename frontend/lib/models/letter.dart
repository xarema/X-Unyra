class Letter {
  final String id;
  final String month;
  final String content;
  final DateTime updatedAt;

  Letter({required this.id, required this.month, required this.content, required this.updatedAt});

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      id: json['id'].toString(),
      month: (json['month'] ?? '').toString(),
      content: (json['content'] ?? '').toString(),
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }
}
