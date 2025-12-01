/// نموذج بيانات الخبر - متوافق مع API
class News {
  final int id;
  final String title;
  final String description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const News({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
    id: json['id'] as int,
    title: json['title'] as String? ?? '',
    description: json['description'] as String? ?? '',
    createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null 
        ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
  };

  News copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return News(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
