import 'package:equatable/equatable.dart';

/// حالة المصادقة - صف واحد بسيط مع copyWith
/// الحالات: loading, success, failure كحقول بسيطة
class AuthState extends Equatable {
  final bool isLoading;
  final bool isSuccess;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isAuthenticated;
  final String? errorMessage;
  final String? successMessage;
  final String? userEmail;
  final String? userName;

  const AuthState({
    this.isLoading = false,
    this.isSuccess = false,
    this.isPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.successMessage,
    this.userEmail,
    this.userName,
  });

  /// هل هناك خطأ؟
  bool get hasError => errorMessage != null;

  /// هل العملية ناجحة؟
  bool get hasSuccess => successMessage != null;

  AuthState copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isAuthenticated,
    String? errorMessage,
    String? successMessage,
    String? userEmail,
    String? userName,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage:
          clearSuccess ? null : (successMessage ?? this.successMessage),
      userEmail: userEmail ?? this.userEmail,
      userName: userName ?? this.userName,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSuccess,
    isPasswordVisible,
    isConfirmPasswordVisible,
    isAuthenticated,
    errorMessage,
    successMessage,
    userEmail,
    userName,
  ];
}
