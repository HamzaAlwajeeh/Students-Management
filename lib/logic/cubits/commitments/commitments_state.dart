import 'package:equatable/equatable.dart';

/// نموذج بيانات الالتزام
class Commitment {
  final String id;
  final String title;
  final String description;
  final String date;

  const Commitment({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });
}

/// حالة الالتزامات - صف واحد بسيط مع copyWith
class CommitmentsState extends Equatable {
  final bool isLoading;
  final List<Commitment> commitments;
  final String? errorMessage;

  const CommitmentsState({
    this.isLoading = false,
    this.commitments = const [],
    this.errorMessage,
  });

  CommitmentsState copyWith({
    bool? isLoading,
    List<Commitment>? commitments,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CommitmentsState(
      isLoading: isLoading ?? this.isLoading,
      commitments: commitments ?? this.commitments,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [isLoading, commitments, errorMessage];
}
