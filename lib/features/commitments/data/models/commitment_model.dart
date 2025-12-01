/// نموذج بيانات الالتزام - متوافق مع API
class Commitment {
  final int id;
  final String title;
  final String description;
  final String? date;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Commitment({
    required this.id,
    required this.title,
    required this.description,
    this.date,
    this.createdAt,
    this.updatedAt,
  });

  factory Commitment.fromJson(Map<String, dynamic> json) => Commitment(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    date: json['date'] as String?,
    createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null 
        ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    if (date != null) 'date': date,
  };

  Commitment copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Commitment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Commitment(id: $id, title: $title)';
}
