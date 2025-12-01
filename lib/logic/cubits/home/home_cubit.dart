import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/features/admin/data/models/news_model.dart';
import 'package:almaali_university_center/logic/cubits/home/home_state.dart';

/// Cubit للصفحة الرئيسية - يدير بيانات المستخدم والأخبار
class HomeCubit extends Cubit<HomeState> {
  final ApiService apiService;

  HomeCubit({required this.apiService}) : super(const HomeState());

  /// تحميل بيانات الصفحة الرئيسية
  Future<void> loadHomeData() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      // جلب بيانات المستخدم من SharedPreferences
      final userEmail = Prefs.getString('user_email') ?? '';
      final userName = Prefs.getString('user_name') ?? userEmail;
      final userSpecialization = Prefs.getString('user_specialization') ?? '';

      // جلب الأخبار من API
      final token = Prefs.getString('token');
      final data = await apiService.get(
        endPoint: 'news',
        body: null,
        token: token,
      );

      final newsList = (data as List)
          .map<News>((item) => News.fromJson(item))
          .toList();

      // تحويل News إلى NewsItem للتوافق مع HomeState
      final news = newsList.map((n) => NewsItem(
        id: n.id.toString(),
        title: n.title,
        details: n.description,
        createdAt: n.createdAt ?? DateTime.now(),
      )).toList();

      emit(
        state.copyWith(
          isLoading: false,
          userName: userName,
          userSpecialization: userSpecialization,
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
