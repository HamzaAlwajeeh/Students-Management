import 'package:equatable/equatable.dart';

/// نموذج بيانات الشكوى
class Complaint {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;

  const Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
  });
}

/// حالة الشكاوى - صف واحد بسيط مع copyWith
class ComplaintsState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<Complaint> complaints;
  final String? errorMessage;
  final String? successMessage;

  const ComplaintsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.complaints = const [],
    this.errorMessage,
    this.successMessage,
  });

  ComplaintsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Complaint>? complaints,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ComplaintsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      complaints: complaints ?? this.complaints,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    complaints,
    errorMessage,
    successMessage,
  ];
}
