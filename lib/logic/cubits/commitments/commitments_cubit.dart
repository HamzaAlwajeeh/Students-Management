import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit للالتزامات - يدير قائمة الالتزامات
class CommitmentsCubit extends Cubit<CommitmentsState> {
  final ApiService apiService;

  CommitmentsCubit({ApiService? apiService}) 
      : apiService = apiService ?? ApiService(),
        super(const CommitmentsState());

  /// تحميل قائمة الالتزامات
  Future<void> loadCommitments() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final token = Prefs.getString('token');

      var data = await apiService.get(
        endPoint: 'responsibilities',
        body: null,
        token: token,
      );

      List<Commitment> commitments =
          (data as List).map<Commitment>((item) => Commitment.fromJson(item)).toList();

      emit(state.copyWith(isLoading: false, commitments: commitments));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'فشل تحميل الالتزامات: $e',
        ),
      );
    }
  }

  /// إضافة التزام جديد
  Future<bool> addCommitment({
    required String title,
    required String description,
    String? date,
  }) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));

      final token = Prefs.getString('token');

      await apiService.post(
        endPoint: 'responsibilities',
        body: {
          'title': title,
          'description': description,
          if (date != null) 'date': date,
        },
        token: token,
      );

      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'تم إضافة الالتزام بنجاح',
      ));

      // إعادة تحميل القائمة
      await loadCommitments();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'فشل إضافة الالتزام: $e',
      ));
      return false;
    }
  }

  /// تعديل التزام
  Future<bool> updateCommitment({
    required int id,
    required String title,
    required String description,
    String? date,
  }) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true));

      final token = Prefs.getString('token');

      await apiService.put(
        endPoint: 'responsibilities/$id',
        body: {
          'title': title,
          'description': description,
          if (date != null) 'date': date,
        },
        token: token,
      );

      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'تم تعديل الالتزام بنجاح',
      ));

      await loadCommitments();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'فشل تعديل الالتزام: $e',
      ));
      return false;
    }
  }

  /// حذف التزام
  Future<bool> deleteCommitment(int id) async {
    try {
      final token = Prefs.getString('token');

      await apiService.delete(
        endPoint: 'responsibilities/$id',
        token: token,
      );

      final updatedCommitments =
          state.commitments.where((c) => c.id != id).toList();

      emit(state.copyWith(
        commitments: updatedCommitments,
        successMessage: 'تم حذف الالتزام بنجاح',
      ));

      return true;
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل حذف الالتزام: $e'));
      return false;
    }
  }

  /// مسح رسالة النجاح
  void clearSuccess() {
    emit(state.copyWith(clearSuccess: true));
  }

  /// مسح رسالة الخطأ
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  /// إعادة تحميل الالتزامات
  Future<void> refresh() async {
    await loadCommitments();
  }
}
