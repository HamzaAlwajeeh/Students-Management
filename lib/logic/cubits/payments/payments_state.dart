import 'package:equatable/equatable.dart';
import 'package:almaali_university_center/features/admin/data/models/payment_model.dart';

/// حالة المدفوعات
class PaymentsState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<Payment> payments;
  final String? errorMessage;
  final String? successMessage;

  const PaymentsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.payments = const [],
    this.errorMessage,
    this.successMessage,
  });

  PaymentsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Payment>? payments,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return PaymentsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      payments: payments ?? this.payments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    payments,
    errorMessage,
    successMessage,
  ];
}
