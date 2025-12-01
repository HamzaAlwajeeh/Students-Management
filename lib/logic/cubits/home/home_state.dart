import 'package:equatable/equatable.dart';

/// نموذج بيانات الخبر
class NewsItem {
  final String id;
  final String title;
  final String details;
  final DateTime createdAt;

  const NewsItem({
    required this.id,
    required this.title,
    required this.details,
    required this.createdAt,
  });
}

/// حالة الصفحة الرئيسية - صف واحد بسيط مع copyWith
class HomeState extends Equatable {
  final bool isLoading;
  final String userName;
  final String userSpecialization;
  final List<NewsItem> news;
  final int selectedNavIndex;
  final String? errorMessage;

  const HomeState({
    this.isLoading = false,
    this.userName = '',
    this.userSpecialization = '',
    this.news = const [],
    this.selectedNavIndex = 1,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    String? userName,
    String? userSpecialization,
    List<NewsItem>? news,
    int? selectedNavIndex,
    String? errorMessage,
    bool clearError = false,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      userSpecialization: userSpecialization ?? this.userSpecialization,
      news: news ?? this.news,
      selectedNavIndex: selectedNavIndex ?? this.selectedNavIndex,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    userName,
    userSpecialization,
    news,
    selectedNavIndex,
    errorMessage,
  ];
}
