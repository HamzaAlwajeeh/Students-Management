import 'package:dio/dio.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/core/services/role_service.dart';
import 'package:almaali_university_center/core/routing/app_router.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';

/// Interceptor للمصادقة - يضيف Token تلقائياً ويعالج 401 مع Token Refresh
class AuthInterceptor extends Interceptor {
  final Dio _dio;
  bool _isRefreshing = false;
  
  AuthInterceptor(this._dio);
  
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
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // محاولة تجديد Token
      final refreshed = await _tryRefreshToken();
      
      if (refreshed) {
        // إعادة الطلب الأصلي بالـ Token الجديد
        try {
          final token = Prefs.getString('token');
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          // فشل إعادة الطلب - تسجيل الخروج
          await _handleUnauthorized();
        }
      } else {
        // فشل تجديد Token - تسجيل الخروج
        await _handleUnauthorized();
      }
    }
    handler.next(err);
  }

  /// محاولة تجديد Token
  Future<bool> _tryRefreshToken() async {
    // منع التجديد المتكرر
    if (_isRefreshing) return false;
    _isRefreshing = true;
    
    try {
      final refreshToken = Prefs.getString('refresh_token');
      
      // إذا لم يوجد refresh token، لا يمكن التجديد
      if (refreshToken == null || refreshToken.isEmpty) {
        _isRefreshing = false;
        return false;
      }
      
      // استدعاء API لتجديد Token
      final response = await _dio.post(
        'refresh',
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {'Accept': 'application/json'},
        ),
      );
      
      if (response.statusCode == 200 && response.data != null) {
        final newToken = response.data['token'] ?? response.data['access_token'];
        final newRefreshToken = response.data['refresh_token'];
        
        if (newToken != null) {
          await Prefs.setString('token', newToken);
          if (newRefreshToken != null) {
            await Prefs.setString('refresh_token', newRefreshToken);
          }
          _isRefreshing = false;
          return true;
        }
      }
      
      _isRefreshing = false;
      return false;
    } catch (e) {
      _isRefreshing = false;
      return false;
    }
  }

  /// معالجة حالة عدم التصريح (401)
  Future<void> _handleUnauthorized() async {
    // مسح بيانات المستخدم
    await Prefs.removeString('token');
    await Prefs.removeString('refresh_token');
    await RoleService.clearUserData();
    
    // إعادة التوجيه لصفحة تسجيل الدخول
    final context = rootNavigatorKey.currentContext;
    if (context != null) {
      AppRouter.router.go(AppRoutes.signIn);
    }
  }
}
