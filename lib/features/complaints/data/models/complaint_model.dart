/// نموذج بيانات الشكوى - متوافق مع API
class Complaint {
  final int id;
  final int studentId;
  final String description;
  final String? studentName;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Complaint({
    required this.id,
    required this.studentId,
    required this.description,
    this.studentName,
    this.createdAt,
    this.updatedAt,
  });

  factory Complaint.fromJson(Map<String, dynamic> json) => Complaint(
    id: json['id'] as int,
    studentId: json['student_id'] is int 
        ? json['student_id'] as int 
        : int.tryParse(json['student_id'].toString()) ?? 0,
    description: json['description'] as String? ?? '',
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
    'description': description,
  };

  Complaint copyWith({
    int? id,
    int? studentId,
    String? description,
    String? studentName,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Complaint(
      id: id ?? this.id,
      studentId: studentId ?? this.studentId,
      description: description ?? this.description,
      studentName: studentName ?? this.studentName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
