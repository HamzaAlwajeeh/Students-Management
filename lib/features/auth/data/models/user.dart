class User {
  int? id;
  String? userEmail;
  String? userRole;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.userEmail,
    this.userRole,
    this.createdAt,
    this.updatedAt,
  });

  @override
  String toString() {
    return 'User(id: $id, userEmail: $userEmail, userRole: $userRole, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json['id'] as int?,
    userEmail: json['user_email'] as String?,
    userRole: json['user_role'] as String?,
    createdAt:
        json['created_at'] == null
            ? null
            : DateTime.parse(json['created_at'] as String),
    updatedAt:
        json['updated_at'] == null
            ? null
            : DateTime.parse(json['updated_at'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_email': userEmail,
    'user_role': userRole,
    'created_at': createdAt?.toIso8601String(),
    'updated_at': updatedAt?.toIso8601String(),
  };
}
