import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/features/admin/data/models/news_model.dart';
import 'package:almaali_university_center/logic/cubits/news/news_state.dart';

/// Cubit للأخبار - يدير قائمة الأخبار وعمليات CRUD
class NewsCubit extends Cubit<NewsState> {
  final ApiService apiService;

  NewsCubit({required this.apiService}) : super(const NewsState());

  /// تحميل قائمة الأخبار
  Future<void> loadNews() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      final token = Prefs.getString('token');
      final data = await apiService.get(
        endPoint: 'news',
        body: null,
        token: token,
      );

      final news = (data as List)
          .map<News>((item) => News.fromJson(item))
          .toList();

      emit(state.copyWith(isLoading: false, news: news));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        errorMessage: 'فشل تحميل الأخبار: $e',
      ));
    }
  }

  /// إضافة خبر جديد
  Future<bool> addNews({
    required String title,
    required String description,
  }) async {
    try {
      emit(state.copyWith(isSubmitting: true, clearError: true));

      final token = Prefs.getString('token');
      await apiService.post(
        endPoint: 'news',
        body: {
          'title': title,
          'description': description,
        },
        token: token,
      );

      emit(state.copyWith(
        isSubmitting: false,
        successMessage: 'تم إضافة الخبر بنجاح',
      ));

      await loadNews();
      return true;
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'فشل إضافة الخبر: $e',
      ));
      return false;
    }
  }

  /// حذف خبر
  Future<bool> deleteNews(int id) async {
    try {
      final token = Prefs.getString('token');
      await apiService.delete(
        endPoint: 'news/$id',
        token: token,
      );

      emit(state.copyWith(
        news: state.news.where((n) => n.id != id).toList(),
        successMessage: 'تم حذف الخبر بنجاح',
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(errorMessage: 'فشل حذف الخبر: $e'));
      return false;
    }
  }

  void clearSuccess() => emit(state.copyWith(clearSuccess: true));
  void clearError() => emit(state.copyWith(clearError: true));
}
