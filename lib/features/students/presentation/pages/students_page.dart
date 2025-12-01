import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/students/data/model/student_model.dart';
import 'package:almaali_university_center/logic/cubits/students/students_cubit.dart';
import 'package:almaali_university_center/logic/cubits/students/students_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class StudentsPage extends StatefulWidget {
  const StudentsPage({super.key});

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {
  String selectedCollege = 'الجامعة';
  String selectedSpecialization = 'التخصص';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D5A8F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Logo
            const LogoWidget(size: 100, showText: true),
            const SizedBox(height: 24),

            // Title
            const Text(
              'الطــــلاب',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D5A8F),
              ),
            ),
            const SizedBox(height: 24),

            // Expanded BlocBuilder
            Expanded(
              child: BlocBuilder<StudentsCubit, StudentsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state.students.isEmpty) {
                    return const Center(child: Text('لا يوجد طلاب'));
                  }

                  // إعداد قوائم الفلاتر
                  final colleges = [
                    'الجامعة',
                    ...state.students.map((s) => s.college).toSet(),
                  ];
                  final specializations = [
                    'التخصص',
                    ...state.students.map((s) => s.specialization).toSet(),
                  ];

                  // تطبيق الفلاتر
                  var filteredStudents = state.students;
                  if (selectedCollege != 'الجامعة') {
                    filteredStudents =
                        filteredStudents
                            .where((s) => s.college == selectedCollege)
                            .toList();
                  }
                  if (selectedSpecialization != 'التخصص') {
                    filteredStudents =
                        filteredStudents
                            .where(
                              (s) => s.specialization == selectedSpecialization,
                            )
                            .toList();
                  }

                  return Column(
                    children: [
                      // Filters Row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildDropdown(
                                value: selectedSpecialization,
                                items: specializations,
                                onChanged: (value) {
                                  setState(() {
                                    selectedSpecialization = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdown(
                                value: selectedCollege,
                                items: colleges,
                                onChanged: (value) {
                                  setState(() {
                                    selectedCollege = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // List of students
                      Expanded(
                        child:
                            filteredStudents.isEmpty
                                ? const Center(child: Text('لا يوجد طلاب'))
                                : ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  itemCount: filteredStudents.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: _buildStudentCard(
                                        student: filteredStudents[index],
                                      ),
                                    );
                                  },
                                ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0D5A8F),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
          dropdownColor: const Color(0xFF0D5A8F),
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items:
              items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item, textAlign: TextAlign.right),
                );
              }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStudentCard({required Student student}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGold,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'الاسم: ${student.name}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'التخصص: ${student.specialization}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
