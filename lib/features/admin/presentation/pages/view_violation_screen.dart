import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/violations_screen.dart';

class ViewViolationScreen extends StatelessWidget {
  final ViolationItem violation;

  const ViewViolationScreen({super.key, required this.violation});

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
                child: Text('عرض مخالفة', style: AppTheme.adminPageTitle),
              ),

              // Divider
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: AppColors.primaryBlue,
              ),

              const SizedBox(height: 24),

              // Violation Details Card
              ViolationFormCard(
                children: [
                  ViolationInputField(
                    label: 'الطالـــب',
                    initialValue: violation.studentName,
                    readOnly: true,
                  ),
                  const SizedBox(height: 24),
                  ViolationInputField(
                    label: 'المخالفــة',
                    initialValue: violation.violation,
                    readOnly: true,
                  ),
                  const SizedBox(height: 24),
                  ViolationInputField(
                    label: 'العقوبـــة',
                    initialValue: violation.penalty ?? 'لم يتم تحديد العقوبة',
                    readOnly: true,
                  ),
                  const SizedBox(height: 24),
                  ViolationInputField(
                    label: 'ملاحظـــات',
                    initialValue: violation.notes ?? 'لا توجد ملاحظات',
                    readOnly: true,
                    maxLines: 5,
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
