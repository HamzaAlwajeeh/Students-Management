import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';

/// Gold dropdown for student selection
class StudentDropdown extends StatelessWidget {
  final String? selectedStudent;
  final ValueChanged<String?>? onChanged;
  final List<String> students;

  const StudentDropdown({
    super.key,
    this.selectedStudent,
    this.onChanged,
    this.students = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primaryGold,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedStudent,
          hint: const Text(
            'الطالـــب',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textLight,
            ),
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.textLight,
            size: 28,
          ),
          isExpanded: true,
          dropdownColor: AppColors.primaryGold,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
          onChanged: onChanged,
          items:
              students.map((String student) {
                return DropdownMenuItem<String>(
                  value: student,
                  alignment: Alignment.centerRight,
                  child: Text(student),
                );
              }).toList(),
        ),
      ),
    );
  }
}
