import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/logic/cubits/complaints/complaints_state.dart';

/// Cubit للشكاوى - يدير قائمة الشكاوى وإضافة/حذف
class ComplaintsCubit extends Cubit<ComplaintsState> {
  ComplaintsCubit() : super(const ComplaintsState());

  /// تحميل قائمة الشكاوى
  Future<void> loadComplaints() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      // TODO: استبدال بـ Repository call
      await Future.delayed(const Duration(seconds: 1));

      // بيانات تجريبية
      final complaints = [
        Complaint(
          id: '1',
          title: 'الشكوى',
          description: 'إنقطاع الانترنت عن الطابق الرابع',
          createdAt: DateTime.now(),
        ),
        Complaint(
          id: '2',
          title: 'الشكوى',
          description: 'تعطل المكيف في القاعة الرئيسية',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
      ];

      emit(state.copyWith(isLoading: false, complaints: complaints));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'فشل تحميل الشكاوى: $e'),
      );
    }
  }

  /// إضافة شكوى جديدة
  Future<void> addComplaint(String title, String description) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true));

      // TODO: استبدال بـ Repository call
      await Future.delayed(const Duration(seconds: 1));

      final newComplaint = Complaint(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: description,
        createdAt: DateTime.now(),
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          complaints: [...state.complaints, newComplaint],
          successMessage: 'تم إضافة الشكوى بنجاح',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'فشل إضافة الشكوى: $e',
        ),
      );
    }
  }

  /// حذف شكوى
  Future<void> removeComplaint(String id) async {
    try {
      // TODO: استبدال بـ Repository call
      final updatedComplaints =
          state.complaints.where((complaint) => complaint.id != id).toList();

      emit(
        state.copyWith(
          complaints: updatedComplaints,
          successMessage: 'تم حذف الشكوى',
        ),
      );
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل حذف الشكوى: $e'));
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
}
