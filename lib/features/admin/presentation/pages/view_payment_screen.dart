import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/payments_screen.dart';

class ViewPaymentScreen extends StatelessWidget {
  final PaymentItem payment;

  const ViewPaymentScreen({super.key, required this.payment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LogoWidget(size: 120, showText: true),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('عرض الدفع', style: AppTheme.adminPageTitle),
              ),
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 24),
              ViolationFormCard(
                children: [
                  ViolationInputField(
                    label: 'الطالـــب',
                    initialValue: payment.studentName,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'رسوم التغذية',
                    initialValue: payment.nutrition.toStringAsFixed(0),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'رسوم التسكين',
                    initialValue: payment.housing.toStringAsFixed(0),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'الإجمالي',
                    initialValue: payment.total.toStringAsFixed(0),
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'المتبقي',
                    initialValue: payment.remaining?.toStringAsFixed(0) ?? '0',
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'الشهر',
                    initialValue: payment.month,
                    readOnly: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),
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
