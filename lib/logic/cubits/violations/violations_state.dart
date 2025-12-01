import 'package:equatable/equatable.dart';
import 'package:almaali_university_center/features/admin/data/models/violation_model.dart';

/// حالة المخالفات
class ViolationsState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<Violation> violations;
  final String? errorMessage;
  final String? successMessage;

  const ViolationsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.violations = const [],
    this.errorMessage,
    this.successMessage,
  });

  ViolationsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Violation>? violations,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ViolationsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      violations: violations ?? this.violations,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    violations,
    errorMessage,
    successMessage,
  ];
}
