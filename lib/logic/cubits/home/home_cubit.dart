import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/logic/cubits/home/home_state.dart';

/// Cubit للصفحة الرئيسية - يدير بيانات المستخدم والأخبار
class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  /// تحميل بيانات الصفحة الرئيسية
  Future<void> loadHomeData() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      // TODO: استبدال بـ Repository call
      await Future.delayed(const Duration(seconds: 1));

      // بيانات تجريبية
      final news = [
        NewsItem(
          id: '1',
          title: 'العنوان',
          details: 'التفاصيل',
          createdAt: DateTime.now(),
        ),
        NewsItem(
          id: '2',
          title: 'العنوان',
          details: 'التفاصيل',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        NewsItem(
          id: '3',
          title: 'العنوان',
          details: 'التفاصيل',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ];

      emit(
        state.copyWith(
          isLoading: false,
          userName: 'عبدالله سالم باوزير',
          userSpecialization: 'تقنية معلومات',
          news: news,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'فشل تحميل البيانات: $e',
        ),
      );
    }
  }

  /// تغيير التبويب المحدد في شريط التنقل
  void setNavIndex(int index) {
    emit(state.copyWith(selectedNavIndex: index));
  }

  /// إعادة تحميل البيانات
  Future<void> refresh() async {
    await loadHomeData();
  }
}
