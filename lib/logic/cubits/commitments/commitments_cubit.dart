import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit للالتزامات - يدير قائمة الالتزامات
class CommitmentsCubit extends Cubit<CommitmentsState> {
  final ApiService apiService;

  CommitmentsCubit({ApiService? apiService}) 
      : apiService = apiService ?? ApiService(),
        super(const CommitmentsState());

  /// تحميل قائمة الالتزامات
  Future<void> loadCommitments() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      // الحصول على Token وإرساله مع الطلب
      final token = Prefs.getString('token');

      var data = await apiService.get(
        endPoint: 'responsibilities',
        body: null,
        token: token,
      );

      List<Commitment> commitments =
          (data as List).map<Commitment>((item) {
            return Commitment(
              id: item['id'].toString(),
              title: item['title'] ?? '',
              description: item['description'] ?? '',
              date: item['date'] ?? '',
            );
          }).toList();

      emit(state.copyWith(isLoading: false, commitments: commitments));
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: 'فشل تحميل الالتزامات: $e',
        ),
      );
    }
  }

  /// إعادة تحميل الالتزامات
  Future<void> refresh() async {
    await loadCommitments();
  }
}
