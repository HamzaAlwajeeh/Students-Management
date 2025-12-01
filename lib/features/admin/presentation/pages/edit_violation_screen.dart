import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/admin/data/models/violation_model.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';
import 'package:almaali_university_center/logic/cubits/violations/violations_cubit.dart';

class EditViolationScreen extends StatefulWidget {
  final Violation violation;

  const EditViolationScreen({super.key, required this.violation});

  @override
  State<EditViolationScreen> createState() => _EditViolationScreenState();
}

class _EditViolationScreenState extends State<EditViolationScreen> {
  late TextEditingController _studentController;
  late TextEditingController _violationController;
  late TextEditingController _penaltyController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _studentController = TextEditingController(
      text: widget.violation.studentName ?? '',
    );
    _violationController = TextEditingController(
      text: widget.violation.title,
    );
    _penaltyController = TextEditingController(
      text: widget.violation.discipline,
    );
  }

  @override
  void dispose() {
    _studentController.dispose();
    _violationController.dispose();
    _penaltyController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_violationController.text.isEmpty ||
        _penaltyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await context.read<ViolationsCubit>().updateViolation(
      id: widget.violation.id,
      title: _violationController.text,
      discipline: _penaltyController.text,
    );

    setState(() => _isSubmitting = false);

    if (success && mounted) {
      Navigator.pop(context);
    }
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
                    readOnly: true,
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
                  // Save Button inside card
                  Center(
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _saveChanges,
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
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text(
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
