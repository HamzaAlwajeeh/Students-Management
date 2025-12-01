/// نموذج بيانات الطالب - متوافق مع API
class Student {
  final int id;
  final int? userId;
  final String name;
  final String? phone;
  final String university;
  final String major;
  final String? city;
  final String? fatherName;
  final String? fatherPhone;
  final String? skills;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Student({
    required this.id,
    this.userId,
    required this.name,
    this.phone,
    required this.university,
    required this.major,
    this.city,
    this.fatherName,
    this.fatherPhone,
    this.skills,
    this.createdAt,
    this.updatedAt,
  });

  /// Getters للتوافق مع الكود القديم
  String get specialization => major;
  String get college => university;

  factory Student.fromJson(Map<String, dynamic> json) => Student(
    id: json['id'] as int,
    userId: json['user_id'] as int?,
    name: json['student_name'] as String? ?? '',
    phone: json['student_phone'] as String?,
    university: json['student_university'] as String? ?? '',
    major: json['student_major'] as String? ?? '',
    city: json['student_city'] as String?,
    fatherName: json['father_name'] as String?,
    fatherPhone: json['father_phone'] as String?,
    skills: json['skills'] as String?,
    createdAt: json['created_at'] != null 
        ? DateTime.tryParse(json['created_at'].toString()) : null,
    updatedAt: json['updated_at'] != null 
        ? DateTime.tryParse(json['updated_at'].toString()) : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'student_name': name,
    'student_phone': phone,
    'student_university': university,
    'student_major': major,
    'student_city': city,
    'father_name': fatherName,
    'father_phone': fatherPhone,
    'skills': skills,
  };

  Student copyWith({
    int? id,
    int? userId,
    String? name,
    String? phone,
    String? university,
    String? major,
    String? city,
    String? fatherName,
    String? fatherPhone,
    String? skills,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Student(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      university: university ?? this.university,
      major: major ?? this.major,
      city: city ?? this.city,
      fatherName: fatherName ?? this.fatherName,
      fatherPhone: fatherPhone ?? this.fatherPhone,
      skills: skills ?? this.skills,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
