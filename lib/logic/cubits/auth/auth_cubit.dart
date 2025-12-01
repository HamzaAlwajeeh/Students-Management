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

      await apiService.post(
        endPoint: 'signup',
        body: {
          'user_email': email,
          'user_password': password,
          'user_password_confirmation': confirmPassword,
        },
        token: null,
      );

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

  /// تسجيل طالب جديد في المركز
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    required String address,
    required String specialization,
    String? university,
    String? fatherName,
    String? fatherPhone,
    String? skills,
  }) async {
    try {
      emit(state.copyWith(isLoading: true, errorMessage: null));

      var data = await apiService.post(
        endPoint: 'register',
        body: {
          'student_name': name,
          'student_phone': phone,
          'student_city': address,
          'student_major': specialization,
          'student_university': university ?? '',
          'father_name': fatherName ?? '',
          'father_phone': fatherPhone ?? '',
          'skills': skills ?? '',
        },
        token: null,
      );

      emit(
        state.copyWith(
          isLoading: false,
          successMessage: 'تم تقديم طلب التسجيل بنجاح',
        ),
      );

      return {'success': true, 'data': data};
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'فشل تقديم طلب التسجيل: $e',
        ),
      );
      return {'success': false, 'error': e.toString()};
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
