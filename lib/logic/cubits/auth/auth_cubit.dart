import 'dart:developer';

import 'package:almaali_university_center/core/constants/user_role.dart';
import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/role_service.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/features/auth/data/models/user.dart';
import 'package:almaali_university_center/logic/cubits/auth/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit للمصادقة - يدير حالة تسجيل الدخول والتسجيل
class AuthCubit extends Cubit<AuthState> {
  ApiService apiService = ApiService();
  AuthCubit() : super(const AuthState());

  /// تبديل رؤية كلمة المرور
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  /// تبديل رؤية تأكيد كلمة المرور
  void toggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }

  /// تسجيل الدخول
  Future<bool> signIn(String email, String password) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      var data = await apiService.post(
        endPoint: 'login',
        body: {'user_email': email, 'user_password': password},
        token: null,
      );

      User user = User.fromJson(data['user']);
      Prefs.setString('token', data['access_token']);

      String token = Prefs.getString('token');
      if (user.id != null) await RoleService.saveUserId(user.id.toString());
      if (user.userEmail != null) {
        await RoleService.saveUserName(user.userEmail!);
      }

      // حفظ الدور
      if (user.userRole != null) {
        UserRole role = UserRoleExtension.fromString(user.userRole!);
        await RoleService.saveRole(role);
        print("User role saved: ${role.toStringValue()}");
      }

      log('=============================> $token');
      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'تم تسجيل الدخول بنجاح',
          isAuthenticated: true,
          userEmail: data['user']['user_email'],
        ),
      );

      return true;
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'فشل تسجيل الدخول: $e'),
      );
      return false;
    }
  }

  /// إنشاء حساب جديد
  Future<bool> signUp(
    String email,
    String password,
    String confirmPassword,
  ) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      // محاكاة استدعاء API
      await Future.delayed(const Duration(seconds: 2));

      var data = await apiService.post(
        endPoint: 'signup',
        body: {
          'user_email': email,
          'user_password': password,
          "user_password_confirmation": confirmPassword,
        },
        token: null,
      );
      // List<Operation> operations = [];

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'تم إنشاء الحساب بنجاح',
        ),
      );

      return true;
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'فشل إنشاء الحساب: $e'),
      );
      return false;
    }
  }

  /// إعادة تعيين الحالة
  void reset() {
    emit(const AuthState());
  }

  /// مسح رسالة الخطأ
  void clearError() {
    emit(state.copyWith(errorMessage: null));
  }

  /// مسح رسالة النجاح
  void clearSuccess() {
    emit(state.copyWith(successMessage: null));
  }
}
