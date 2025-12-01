import 'package:equatable/equatable.dart';
import 'package:almaali_university_center/features/commitments/data/models/commitment_model.dart';

export 'package:almaali_university_center/features/commitments/data/models/commitment_model.dart';

/// حالة الالتزامات - صف واحد بسيط مع copyWith
class CommitmentsState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<Commitment> commitments;
  final String? errorMessage;
  final String? successMessage;

  const CommitmentsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.commitments = const [],
    this.errorMessage,
    this.successMessage,
  });

  CommitmentsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<Commitment>? commitments,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return CommitmentsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      commitments: commitments ?? this.commitments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, isSubmitting, commitments, errorMessage, successMessage];
}
