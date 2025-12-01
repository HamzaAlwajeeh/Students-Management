import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/features/admin/data/models/violation_model.dart';
import 'package:almaali_university_center/logic/cubits/violations/violations_state.dart';

/// Cubit للمخالفات - يدير قائمة المخالفات وعمليات CRUD
class ViolationsCubit extends Cubit<ViolationsState> {
  final ApiService apiService;

  ViolationsCubit({required this.apiService}) : super(const ViolationsState());

  /// تحميل قائمة المخالفات
  Future<void> loadViolations() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final token = Prefs.getString('token');
      final data = await apiService.get(
        endPoint: 'violations',
        body: null,
        token: token,
      );

      final violations = (data as List)
          .map<Violation>((item) => Violation.fromJson(item))
          .toList();

      emit(state.copyWith(isLoading: false, violations: violations));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'فشل تحميل المخالفات: $e',
      ));
    }
  }

  /// إضافة مخالفة جديدة
  Future<bool> addViolation({
    required int studentId,
    required String studentName,
    required String title,
    required String discipline,
  }) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true));

      final token = Prefs.getString('token');
      await apiService.post(
        endPoint: 'violations',
        body: {
          'student_id': studentId,
          'student_name': studentName,
          'title': title,
          'discipline': discipline,
        },
        token: token,
      );

      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'تم إضافة المخالفة بنجاح',
      ));

      // إعادة تحميل القائمة
      await loadViolations();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'فشل إضافة المخالفة: $e',
      ));
      return false;
    }
  }

  /// تحديث مخالفة
  Future<bool> updateViolation({
    required int id,
    int? studentId,
    String? title,
    String? discipline,
  }) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true));

      final token = Prefs.getString('token');
      final body = <String, dynamic>{};
      if (studentId != null) body['student_id'] = studentId;
      if (title != null) body['title'] = title;
      if (discipline != null) body['discipline'] = discipline;

      await apiService.put(
        endPoint: 'violations/$id',
        body: body,
        token: token,
      );

      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'تم تحديث المخالفة بنجاح',
      ));

      await loadViolations();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'فشل تحديث المخالفة: $e',
      ));
      return false;
    }
  }

  /// حذف مخالفة
  Future<bool> deleteViolation(int id) async {
    try {
      final token = Prefs.getString('token');
      await apiService.delete(
        endPoint: 'violations/$id',
        token: token,
      );

      emit(state.copyWith(
        violations: state.violations.where((v) => v.id != id).toList(),
        successMessage: 'تم حذف المخالفة بنجاح',
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل حذف المخالفة: $e'));
      return false;
    }
  }

  void clearSuccess() => emit(state.copyWith(clearSuccess: true));
  void clearError() => emit(state.copyWith(clearError: true));
}
