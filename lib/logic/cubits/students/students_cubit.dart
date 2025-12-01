import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../features/students/data/model/student_model.dart';
import 'students_state.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final ApiService apiServices;

  StudentsCubit({required this.apiServices}) : super(const StudentsState());

  /// تحميل الطلاب من الباك اند
  Future<void> loadStudents() async {
    try {
      emit(state.copyWith(isLoading: true, clearError: true));

      // الحصول على Token وإرساله مع الطلب
      final token = Prefs.getString('token');

      final data = await apiServices.get(
        endPoint: 'students',
        body: null,
        token: token,
      );

      final students = (data as List)
          .map<Student>((item) => Student.fromJson(item))
          .toList();

      emit(state.copyWith(isLoading: false, students: students));
    } catch (e) {
      emit(
        state.copyWith(isLoading: false, errorMessage: 'فشل تحميل الطلاب: $e'),
      );
    }
  }

  /// تطبيق الفلاتر
  void applyFilters({String? college, String? specialization}) {
    emit(
      state.copyWith(
        selectedCollege: college ?? state.selectedCollege,
        selectedSpecialization: specialization ?? state.selectedSpecialization,
      ),
    );
  }

  /// إعادة الفلاتر للوضع الافتراضي
  void resetFilters() {
    emit(
      state.copyWith(
        selectedCollege: 'الجامعة',
        selectedSpecialization: 'التخصص',
      ),
    );
  }
}
