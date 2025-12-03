import 'package:almaali_university_center/core/constants/user_role.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';
import 'package:almaali_university_center/core/routing/route_guard.dart';
import 'package:almaali_university_center/core/services/role_service.dart';
import 'package:almaali_university_center/features/about/presentation/pages/about_page.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/admin_main_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/edit_commitment_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/news_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/payments_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/violations_screen.dart';
import 'package:almaali_university_center/features/auth/presentation/pages/register_page.dart';
import 'package:almaali_university_center/features/auth/presentation/pages/sign_in_page.dart';
import 'package:almaali_university_center/features/commitments/data/models/commitment_model.dart';
import 'package:almaali_university_center/features/commitments/presentation/pages/commitments_page.dart';
import 'package:almaali_university_center/features/complaints/presentation/pages/complaints_page.dart';
import 'package:almaali_university_center/features/home/presentation/pages/home_page.dart';
import 'package:almaali_university_center/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:almaali_university_center/features/registration/presentation/pages/registration_page.dart';
import 'package:almaali_university_center/features/registration/presentation/pages/student_accepted_page.dart';
import 'package:almaali_university_center/features/registration/presentation/pages/student_rejected_page.dart';
import 'package:almaali_university_center/features/splash/presentation/pages/splash_page.dart';
import 'package:almaali_university_center/features/students/presentation/pages/student_home_screen.dart';
import 'package:almaali_university_center/features/students/presentation/pages/students_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// مفتاح التنقل العام
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

/// إعدادات التوجيه باستخدام GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,

    /// حارس المسارات - يتحقق من الصلاحيات قبل السماح بالوصول
    redirect: (context, state) async {
      final currentPath = state.matchedLocation;

      // السماح بالوصول لصفحة البداية دائماً
      if (currentPath == AppRoutes.splash) {
        return null;
      }

      // الحصول على دور المستخدم الحالي
      final role = await RoleService.getRole();
      final isAuthenticated = role != UserRole.unauthenticated;

      // المسارات العامة المسموحة للجميع
      final publicRoutes = [
        AppRoutes.splash,
        AppRoutes.onboarding,
        AppRoutes.signIn,
        AppRoutes.signUp,
      ];

      // إذا كان المسار عام، السماح بالوصول
      if (publicRoutes.contains(currentPath)) {
        // إذا كان المستخدم مسجل دخول ويحاول الوصول لصفحة تسجيل الدخول/التسجيل، تحويله للصفحة الافتراضية
        if (isAuthenticated &&
            (currentPath == AppRoutes.signIn ||
                currentPath == AppRoutes.signUp)) {
          return RouteGuard.getDefaultRoute(role);
        }
        return null;
      }

      // إذا لم يكن مسجل دخول، إعادة توجيه لصفحة تسجيل الدخول
      if (!isAuthenticated) {
        return AppRoutes.signIn;
      }

      // التحقق من صلاحية الوصول للمسار
      if (!RouteGuard.hasPermission(role, currentPath)) {
        // إعادة توجيه للصفحة الافتراضية حسب الدور
        return RouteGuard.getDefaultRoute(role);
      }

      return null;
    },

    routes: [
      // ========== Auth Routes ==========
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const SplashPage(),
              TransitionType.fade,
            ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const OnboardingPage(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.signIn,
        name: 'signIn',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const SignInPage(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.signUp,
        name: 'signUp',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const RegisterPage(),
              TransitionType.slideFromRight,
            ),
      ),

      // ========== Enrollment Routes ==========
      GoRoute(
        path: AppRoutes.enrollment,
        name: 'enrollment',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const RegistrationPage(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.registration,
        name: 'registration',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const RegistrationPage(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.studentAccepted,
        name: 'studentAccepted',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const StudentAcceptedPage(),
              TransitionType.fade,
            ),
      ),
      GoRoute(
        path: AppRoutes.studentRejected,
        name: 'studentRejected',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const StudentRejectedPage(),
              TransitionType.fade,
            ),
      ),

      // ========== Student Routes ==========
      GoRoute(
        path: AppRoutes.studentHome,
        name: 'studentHome',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const StudentHomeScreen(),
              TransitionType.fade,
            ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const HomePage(),
              TransitionType.fade,
            ),
      ),
      GoRoute(
        path: AppRoutes.students,
        name: 'students',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const StudentsPage(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.complaints,
        name: 'complaints',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const ComplaintsPage(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.commitments,
        name: 'commitments',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const CommitmentsPage(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.violations,
        name: 'violations',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const ViolationsScreen(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.payments,
        name: 'payments',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const PaymentsScreen(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.about,
        name: 'about',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const AboutPage(),
              TransitionType.slideFromRight,
            ),
      ),

      // ========== Admin Routes ==========
      GoRoute(
        path: AppRoutes.adminHome,
        name: 'adminHome',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const AdminMainScreen(),
              TransitionType.fade,
            ),
      ),
      GoRoute(
        path: AppRoutes.adminViolations,
        name: 'adminViolations',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const ViolationsScreen(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.adminPayments,
        name: 'adminPayments',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const PaymentsScreen(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.adminNews,
        name: 'adminNews',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              const NewsScreen(),
              TransitionType.slideFromRight,
            ),
      ),
      GoRoute(
        path: AppRoutes.editCommitment,
        name: 'editCommitment',
        pageBuilder:
            (context, state) => _buildPageWithTransition(
              context,
              state,
              EditCommitmentScreen(
                commitment: Commitment(
                  title: '',
                  id: 1,
                  description: '',
                  date: '',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                ),
              ),
              TransitionType.slideFromRight,
            ),
      ),
    ],

    // صفحة الخطأ — تظهر رسالة مفيدة لو تم طلب مسار غير معرف
    errorPageBuilder:
        (context, state) => MaterialPage(
          key: state.pageKey,
          child: Scaffold(
            appBar: AppBar(title: const Text('صفحة غير موجودة')),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'الصفحة غير موجودة:\n${state.uri}\n\nتحقق من المسار أو صلاحيات المستخدم.',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
  );

  /// بناء صفحة مع انتقال مخصص
  static CustomTransitionPage _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
    TransitionType transitionType,
  ) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case TransitionType.fade:
            return FadeTransition(opacity: animation, child: child);
          case TransitionType.slideFromRight:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: child,
            );
          case TransitionType.slideFromLeft:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(-1.0, 0.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeInOut),
              ),
              child: child,
            );
          case TransitionType.slideFromBottom:
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 1.0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              ),
              child: child,
            );
          case TransitionType.scale:
            return ScaleTransition(scale: animation, child: child);
        }
      },
    );
  }
}

/// أنواع الانتقالات
enum TransitionType {
  fade,
  slideFromRight,
  slideFromLeft,
  slideFromBottom,
  scale,
}
