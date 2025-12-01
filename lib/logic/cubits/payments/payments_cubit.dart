import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/features/admin/data/models/payment_model.dart';
import 'package:almaali_university_center/logic/cubits/payments/payments_state.dart';

/// Cubit للمدفوعات - يدير قائمة المدفوعات وعمليات CRUD
class PaymentsCubit extends Cubit<PaymentsState> {
  final ApiService apiService;

  PaymentsCubit({required this.apiService}) : super(const PaymentsState());

  /// تحميل قائمة المدفوعات
  Future<void> loadPayments() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final token = Prefs.getString('token');
      final data = await apiService.get(
        endPoint: 'payments',
        body: null,
        token: token,
      );

      final payments = (data as List)
          .map<Payment>((item) => Payment.fromJson(item))
          .toList();

      emit(state.copyWith(isLoading: false, payments: payments));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'فشل تحميل المدفوعات: $e',
      ));
    }
  }

  /// إضافة دفعة جديدة
  Future<bool> addPayment({
    required int studentId,
    required String studentName,
    required int foodPayment,
    required int housingPayment,
    required String paymentMonth,
  }) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true));

      final token = Prefs.getString('token');
      await apiService.post(
        endPoint: 'payments',
        body: {
          'student_id': studentId,
          'student_name': studentName,
          'food_payment': foodPayment,
          'housing_payment': housingPayment,
          'payment_month': paymentMonth,
        },
        token: token,
      );

      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'تم إضافة الدفعة بنجاح',
      ));

      await loadPayments();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'فشل إضافة الدفعة: $e',
      ));
      return false;
    }
  }

  /// تحديث دفعة
  Future<bool> updatePayment({
    required int id,
    int? studentId,
    int? foodPayment,
    int? housingPayment,
    String? paymentMonth,
  }) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true));

      final token = Prefs.getString('token');
      final body = <String, dynamic>{};
      if (studentId != null) body['student_id'] = studentId;
      if (foodPayment != null) body['food_payment'] = foodPayment;
      if (housingPayment != null) body['housing_payment'] = housingPayment;
      if (paymentMonth != null) body['payment_month'] = paymentMonth;

      await apiService.put(
        endPoint: 'payments/$id',
        body: body,
        token: token,
      );

      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'تم تحديث الدفعة بنجاح',
      ));

      await loadPayments();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'فشل تحديث الدفعة: $e',
      ));
      return false;
    }
  }

  /// حذف دفعة
  Future<bool> deletePayment(int id) async {
    try {
      final token = Prefs.getString('token');
      await apiService.delete(
        endPoint: 'payments/$id',
        token: token,
      );

      emit(state.copyWith(
        payments: state.payments.where((p) => p.id != id).toList(),
        successMessage: 'تم حذف الدفعة بنجاح',
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل حذف الدفعة: $e'));
      return false;
    }
  }

  void clearSuccess() => emit(state.copyWith(clearSuccess: true));
  void clearError() => emit(state.copyWith(clearError: true));
}
