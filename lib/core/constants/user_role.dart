/// User roles in the application
enum UserRole {
  /// Unauthenticated user (first time opening app)
  unauthenticated,

  /// Student role - can view own data, other students, complaints, violations, payments
  student,

  /// Admin role - full access to all management screens
  admin,
}

/// Extension to convert role to/from string for storage
extension UserRoleExtension on UserRole {
  String toStringValue() {
    switch (this) {
      case UserRole.unauthenticated:
        return 'unauthenticated';
      case UserRole.student:
        return 'student';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'admin':
        return UserRole.admin;
      default:
        return UserRole.unauthenticated;
    }
  }
}
