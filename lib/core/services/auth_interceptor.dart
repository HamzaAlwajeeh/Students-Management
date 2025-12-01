import 'package:dio/dio.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/core/services/role_service.dart';
import 'package:almaali_university_center/core/routing/app_router.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';

/// Interceptor للمصادقة - يضيف Token تلقائياً ويعالج 401
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // إضافة Token تلقائياً لجميع الطلبات
    final token = Prefs.getString('token');
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // Token منتهي أو غير صالح - تسجيل الخروج وإعادة التوجيه
      _handleUnauthorized();
    }
    handler.next(err);
  }

  /// معالجة حالة عدم التصريح (401)
  Future<void> _handleUnauthorized() async {
    // مسح بيانات المستخدم
    await Prefs.removeString('token');
    await RoleService.clearUserData();
    
    // إعادة التوجيه لصفحة تسجيل الدخول
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      AppRouter.router.go(AppRoutes.signIn);
    }
  }
}
