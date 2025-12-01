import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/student_dropdown.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';

class AddViolationScreen extends StatefulWidget {
  const AddViolationScreen({super.key});

  @override
  State<AddViolationScreen> createState() => _AddViolationScreenState();
}

class _AddViolationScreenState extends State<AddViolationScreen> {
  String? _selectedStudent;
  final TextEditingController _violationController = TextEditingController();
  final TextEditingController _penaltyController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Sample student list
  final List<String> _students = [
    'أحمد محمد علي',
    'محمد أحمد سعيد',
    'علي حسن محمد',
  ];

  @override
  void dispose() {
    _violationController.dispose();
    _penaltyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _addViolation() {
    if (_selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار الطالب'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_violationController.text.isEmpty || _penaltyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Add violation logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة المخالفة بنجاح'),
        backgroundColor: Colors.green,
      ),
    );

    // Clear form
    setState(() {
      _selectedStudent = null;
      _violationController.clear();
      _penaltyController.clear();
      _notesController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AdminAppBar(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Logo Section
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LogoWidget(size: 120, showText: true),
              ),

              // Title
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('إضافة مخالفة', style: AppTheme.adminPageTitle),
              ),

              // Divider
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: AppColors.primaryBlue,
              ),

              const SizedBox(height: 16),

              // Student Dropdown
              StudentDropdown(
                selectedStudent: _selectedStudent,
                students: _students,
                onChanged: (value) {
                  setState(() {
                    _selectedStudent = value;
                  });
                },
              ),

              const SizedBox(height: 8),

              // Violation Form Card
              ViolationFormCard(
                children: [
                  ViolationInputField(
                    label: 'المخالفــة',
                    controller: _violationController,
                  ),
                  const SizedBox(height: 24),
                  ViolationInputField(
                    label: 'العقوبـــة',
                    controller: _penaltyController,
                  ),
                  const SizedBox(height: 24),
                  ViolationInputField(
                    label: 'ملاحظـــات',
                    controller: _notesController,
                    maxLines: 5,
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Add Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addViolation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'إضافــــة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
