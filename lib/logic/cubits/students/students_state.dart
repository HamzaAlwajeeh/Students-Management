import 'package:equatable/equatable.dart';

import '../../../features/students/data/model/student_model.dart';

class StudentsState extends Equatable {
  final bool isLoading;
  final List<Student> students;
  final String selectedCollege;
  final String selectedSpecialization;
  final String? errorMessage;

  const StudentsState({
    this.isLoading = false,
    this.students = const [],
    this.selectedCollege = 'الجامعة',
    this.selectedSpecialization = 'التخصص',
    this.errorMessage,
  });

  /// قائمة الطلاب بعد تطبيق الفلاتر
  List<Student> get filteredStudents {
    return students.where((student) {
      final matchesCollege =
          selectedCollege == 'الجامعة' || student.college == selectedCollege;
      final matchesSpecialization =
          selectedSpecialization == 'التخصص' ||
          student.specialization == selectedSpecialization;
      return matchesCollege && matchesSpecialization;
    }).toList();
  }

  StudentsState copyWith({
    bool? isLoading,
    List<Student>? students,
    String? selectedCollege,
    String? selectedSpecialization,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StudentsState(
      isLoading: isLoading ?? this.isLoading,
      students: students ?? this.students,
      selectedCollege: selectedCollege ?? this.selectedCollege,
      selectedSpecialization:
          selectedSpecialization ?? this.selectedSpecialization,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    students,
    selectedCollege,
    selectedSpecialization,
    errorMessage,
  ];
}
