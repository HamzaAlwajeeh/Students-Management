/// نموذج بيانات المخالفة - متوافق مع API
class Violation {
  final int id;
  final int studentId;
  final String title;
  final String discipline;
  final String? studentName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Violation({
    required this.id,
    required this.studentId,
    required this.title,
    required this.discipline,
    this.studentName,
    this.createdAt,
    this.updatedAt,
  });

  factory Violation.fromJson(Map<String, dynamic> json) => Violation(
    id: json['id'] as int,
    studentId: json['student_id'] is int 
        ? json['student_id'] as int 
        : int.tryParse(json['student_id'].toString()) ?? 0,
    title: json['title'] as String? ?? '',
    discipline: json['discipline'] as String? ?? '',
    studentName: json['student'] != null 
        ? json['student']['student_name'] as String? 
        : null,
    createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null 
        ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'student_id': studentId,
    'title': title,
    'discipline': discipline,
  };

  Violation copyWith({
    int? id,
    int? studentId,
    String? title,
    String? discipline,
    String? studentName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Violation(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      title: title ?? this.title,
      discipline: discipline ?? this.discipline,
      studentName: studentName ?? this.studentName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
