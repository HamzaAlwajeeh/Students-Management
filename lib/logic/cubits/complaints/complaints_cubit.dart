import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/core/services/role_service.dart';
import 'package:almaali_university_center/features/complaints/data/models/complaint_model.dart' as model;
import 'package:almaali_university_center/logic/cubits/complaints/complaints_state.dart';

/// Cubit للشكاوى - يدير قائمة الشكاوى وإضافة/حذف
class ComplaintsCubit extends Cubit<ComplaintsState> {
  final ApiService apiService;

  ComplaintsCubit({ApiService? apiService}) 
      : apiService = apiService ?? ApiService(),
        super(const ComplaintsState());

  /// تحميل قائمة الشكاوى
  Future<void> loadComplaints() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final token = Prefs.getString('token');
      final data = await apiService.get(
        endPoint: 'complaints',
        body: null,
        token: token,
      );

      final complaints = (data as List).map<Complaint>((item) {
        final apiComplaint = model.Complaint.fromJson(item);
        return Complaint(
          id: apiComplaint.id.toString(),
          title: 'شكوى',
          description: apiComplaint.description,
          createdAt: apiComplaint.createdAt ?? DateTime.now(),
        );
      }).toList();

      emit(state.copyWith(isLoading: false, complaints: complaints));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'فشل تحميل الشكاوى: $e'),
      );
    }
  }

  /// إضافة شكوى جديدة
  Future<bool> addComplaint(String title, String description) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true));

      final token = Prefs.getString('token');
      final userId = await RoleService.getUserId();
      final userName = await RoleService.getUserName();

      await apiService.post(
        endPoint: 'complaints',
        body: {
          'student_id': int.tryParse(userId ?? '0') ?? 0,
          'student_name': userName ?? '',
          'description': description,
        },
        token: token,
      );

      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'تم إضافة الشكوى بنجاح',
        ),
      );

      await loadComplaints();
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'فشل إضافة الشكوى: $e',
        ),
      );
      return false;
    }
  }

  /// حذف شكوى
  Future<bool> removeComplaint(String id) async {
    try {
      final token = Prefs.getString('token');
      await apiService.delete(
        endPoint: 'complaints/$id',
        token: token,
      );

      final updatedComplaints =
          state.complaints.where((complaint) => complaint.id != id).toList();

      emit(
        state.copyWith(
          complaints: updatedComplaints,
          successMessage: 'تم حذف الشكوى',
        ),
      );
      return true;
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل حذف الشكوى: $e'));
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
}
