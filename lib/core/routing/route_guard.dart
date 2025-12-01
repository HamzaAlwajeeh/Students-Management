import 'package:almaali_university_center/core/constants/user_role.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';

/// حارس المسارات - يتحكم في الوصول بناءً على الدور
class RouteGuard {
  /// قائمة المسارات المسموحة لكل دور
  static final Map<UserRole, List<String>> rolePermissions = {
    UserRole.student: [
      AppRoutes.studentHome,
      AppRoutes.home,
      AppRoutes.students,
      AppRoutes.complaints,
      AppRoutes.commitments,
      AppRoutes.violations,
      AppRoutes.payments,
      AppRoutes.about,
      AppRoutes.signIn,
      AppRoutes.signUp,
      AppRoutes.onboarding,
      AppRoutes.enrollment,
      AppRoutes.registration,
      AppRoutes.studentAccepted,
      AppRoutes.studentRejected,
    ],
    UserRole.admin: [
      AppRoutes.adminHome,
      AppRoutes.home,
      AppRoutes.adminViolations,
      AppRoutes.adminPayments,
      AppRoutes.adminNews,
      AppRoutes.editCommitment,
      AppRoutes.signIn,
      AppRoutes.signUp,
      AppRoutes.onboarding,
    ],
    UserRole.unauthenticated: [
      AppRoutes.splash,
      AppRoutes.onboarding,
      AppRoutes.signIn,
      AppRoutes.signUp,
      AppRoutes.enrollment,
      AppRoutes.registration,
      AppRoutes.studentAccepted,
      AppRoutes.studentRejected,
    ],
  };

  /// احصل على الصفحة الافتراضية بناءً على الدور
  static String getDefaultRoute(UserRole role) {
    switch (role) {
      case UserRole.student:
        return AppRoutes.studentHome;
      case UserRole.admin:
        return AppRoutes.adminHome;
      case UserRole.unauthenticated:
        return AppRoutes.onboarding;
    }
  }

  /// تحقق من أن المستخدم لديه صلاحية للوصول إلى مسار معين
  static bool hasPermission(UserRole role, String routeName) {
    return rolePermissions[role]?.contains(routeName) ?? false;
  }

  /// احصل على جميع المسارات المسموحة للدور
  static List<String> getPermittedRoutes(UserRole role) {
    return rolePermissions[role] ?? [];
  }

  /// تحقق من أن المسار عام (متاح لجميع الأدوار)
  static bool isPublicRoute(String routeName) {
    return rolePermissions.values.every((routes) => routes.contains(routeName));
  }
}
