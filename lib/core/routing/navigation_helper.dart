import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';
import 'package:almaali_university_center/core/routing/app_router.dart';
import 'package:almaali_university_center/core/routing/route_guard.dart';
import 'package:almaali_university_center/core/services/role_service.dart';

/// مساعد التنقل - يوفر طرق سهلة للتنقل بين الشاشات باستخدام GoRouter
class NavigationHelper {
  /// الحصول على context من navigator key
  static BuildContext? get _context => rootNavigatorKey.currentContext;

  /// التنقل إلى مسار معين مع التحقق من الصلاحيات
  static Future<void> navigateTo(String routeName, {Object? extra}) async {
    if (_context == null) return;

    // احصل على الدور الحالي
    final currentRole = await RoleService.getRole();

    // تحقق من الصلاحيات
    if (!RouteGuard.hasPermission(currentRole, routeName)) {
      _showSnackBar('ليس لديك صلاحية للوصول إلى هذه الصفحة');
      return;
    }

    // قم بالتنقل
    _context!.push(routeName, extra: extra);
  }

  /// التنقل مع استبدال الشاشة الحالية
  static Future<void> navigateToReplacement(
    String routeName, {
    Object? extra,
  }) async {
    if (_context == null) return;

    final currentRole = await RoleService.getRole();

    if (!RouteGuard.hasPermission(currentRole, routeName)) {
      _showSnackBar('ليس لديك صلاحية للوصول إلى هذه الصفحة');
      return;
    }

    _context!.pushReplacement(routeName, extra: extra);
  }

  /// التنقل مع مسح جميع الشاشات السابقة
  static Future<void> navigateToAndClearStack(
    String routeName, {
    Object? extra,
  }) async {
    if (_context == null) return;

    final currentRole = await RoleService.getRole();

    if (!RouteGuard.hasPermission(currentRole, routeName)) {
      _showSnackBar('ليس لديك صلاحية للوصول إلى هذه الصفحة');
      return;
    }

    _context!.go(routeName, extra: extra);
  }

  /// التنقل إلى الصفحة الافتراضية بناءً على الدور
  static Future<void> navigateToHome() async {
    if (_context == null) return;

    final currentRole = await RoleService.getRole();
    final defaultRoute = RouteGuard.getDefaultRoute(currentRole);
    _context!.go(defaultRoute);
  }

  /// التنقل إلى صفحة تسجيل الدخول
  static void navigateToSignIn() {
    if (_context == null) return;
    _context!.go(AppRoutes.signIn);
  }

  /// التنقل إلى صفحة التسجيل
  static void navigateToSignUp() {
    if (_context == null) return;
    _context!.push(AppRoutes.signUp);
  }

  /// التنقل إلى صفحة الطلاب
  static Future<void> navigateToStudents() async {
    await navigateTo(AppRoutes.students);
  }

  /// التنقل إلى صفحة الشكاوى
  static Future<void> navigateToComplaints() async {
    await navigateTo(AppRoutes.complaints);
  }

  /// التنقل إلى صفحة الالتزامات
  static Future<void> navigateToCommitments() async {
    await navigateTo(AppRoutes.commitments);
  }

  /// التنقل إلى صفحة المخالفات
  static Future<void> navigateToViolations() async {
    await navigateTo(AppRoutes.violations);
  }

  /// التنقل إلى صفحة المدفوعات
  static Future<void> navigateToPayments() async {
    await navigateTo(AppRoutes.payments);
  }

  /// التنقل إلى صفحة حول التطبيق
  static Future<void> navigateToAbout() async {
    await navigateTo(AppRoutes.about);
  }

  /// التنقل إلى صفحة التسجيل
  static Future<void> navigateToRegistration() async {
    await navigateTo(AppRoutes.registration);
  }

  /// التنقل إلى صفحة القبول
  static Future<void> navigateToAccepted() async {
    await navigateTo(AppRoutes.studentAccepted);
  }

  /// التنقل إلى صفحة الرفض
  static Future<void> navigateToRejected() async {
    await navigateTo(AppRoutes.studentRejected);
  }

  /// التنقل إلى لوحة تحكم الإدارة
  static Future<void> navigateToAdminHome() async {
    await navigateTo(AppRoutes.adminHome);
  }

  /// الرجوع للصفحة السابقة
  static void goBack() {
    if (_context == null) return;
    if (_context!.canPop()) {
      _context!.pop();
    }
  }

  /// الرجوع إلى الصفحة الرئيسية
  static Future<void> goToHome() async {
    await navigateToHome();
  }

  /// تسجيل الخروج
  static Future<void> logout() async {
    if (_context == null) return;
    await RoleService.clearUserData();
    _context!.go(AppRoutes.onboarding);
  }

  /// عرض رسالة SnackBar
  static void _showSnackBar(String message) {
    if (_context == null) return;
    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// عرض رسالة نجاح
  static void showSuccessMessage(String message) {
    if (_context == null) return;
    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// عرض رسالة خطأ
  static void showErrorMessage(String message) {
    if (_context == null) return;
    ScaffoldMessenger.of(_context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
