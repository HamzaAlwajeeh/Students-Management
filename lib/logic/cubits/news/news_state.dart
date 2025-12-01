import 'package:equatable/equatable.dart';
import 'package:almaali_university_center/features/admin/data/models/news_model.dart';

/// حالة الأخبار
class NewsState extends Equatable {
  final bool isLoading;
  final bool isSubmitting;
  final List<News> news;
  final String? errorMessage;
  final String? successMessage;

  const NewsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.news = const [],
    this.errorMessage,
    this.successMessage,
  });

  NewsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    List<News>? news,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return NewsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      news: news ?? this.news,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    isSubmitting,
    news,
    errorMessage,
    successMessage,
  ];
}
