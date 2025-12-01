import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/violations_screen.dart';

class EditViolationScreen extends StatefulWidget {
  final ViolationItem violation;

  const EditViolationScreen({super.key, required this.violation});

  @override
  State<EditViolationScreen> createState() => _EditViolationScreenState();
}

class _EditViolationScreenState extends State<EditViolationScreen> {
  late TextEditingController _studentController;
  late TextEditingController _violationController;
  late TextEditingController _penaltyController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _studentController = TextEditingController(
      text: widget.violation.studentName,
    );
    _violationController = TextEditingController(
      text: widget.violation.violation,
    );
    _penaltyController = TextEditingController(
      text: widget.violation.penalty ?? '',
    );
    _notesController = TextEditingController(
      text: widget.violation.notes ?? '',
    );
  }

  @override
  void dispose() {
    _studentController.dispose();
    _violationController.dispose();
    _penaltyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_studentController.text.isEmpty ||
        _violationController.text.isEmpty ||
        _penaltyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Save changes logic here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حفظ التعديلات بنجاح'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                child: Text('تعديل مخالفة', style: AppTheme.adminPageTitle),
              ),

              // Divider
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: AppColors.primaryBlue,
              ),

              const SizedBox(height: 24),

              // Edit Form Card
              ViolationFormCard(
                children: [
                  ViolationInputField(
                    label: 'الطالـــب',
                    controller: _studentController,
                  ),
                  const SizedBox(height: 24),
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
                  const SizedBox(height: 24),
                  // Save Button inside card
                  Center(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.textLight,
                        foregroundColor: AppColors.primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        'حفظ التعديلات',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Back Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'رجـــوع',
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
