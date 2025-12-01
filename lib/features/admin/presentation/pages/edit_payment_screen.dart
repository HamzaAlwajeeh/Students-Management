import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/admin/data/models/payment_model.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';
import 'package:almaali_university_center/logic/cubits/payments/payments_cubit.dart';

class EditPaymentScreen extends StatefulWidget {
  final Payment payment;

  const EditPaymentScreen({super.key, required this.payment});

  @override
  State<EditPaymentScreen> createState() => _EditPaymentScreenState();
}

class _EditPaymentScreenState extends State<EditPaymentScreen> {
  late TextEditingController _studentController;
  late TextEditingController _nutritionController;
  late TextEditingController _housingController;
  late TextEditingController _totalController;
  late TextEditingController _monthController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _studentController = TextEditingController(
      text: widget.payment.studentName ?? '',
    );
    _nutritionController = TextEditingController(
      text: widget.payment.foodPayment.toString(),
    );
    _housingController = TextEditingController(
      text: widget.payment.housingPayment.toString(),
    );
    _totalController = TextEditingController(
      text: widget.payment.totalPayment.toString(),
    );
    _monthController = TextEditingController(text: widget.payment.paymentMonth);
  }

  @override
  void dispose() {
    _studentController.dispose();
    _nutritionController.dispose();
    _housingController.dispose();
    _totalController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final nutrition = int.tryParse(_nutritionController.text) ?? 0;
    final housing = int.tryParse(_housingController.text) ?? 0;
    final total = nutrition + housing;
    _totalController.text = total.toString();
  }

  Future<void> _saveChanges() async {
    if (_nutritionController.text.isEmpty ||
        _housingController.text.isEmpty ||
        _monthController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final success = await context.read<PaymentsCubit>().updatePayment(
      id: widget.payment.id,
      foodPayment: int.tryParse(_nutritionController.text) ?? 0,
      housingPayment: int.tryParse(_housingController.text) ?? 0,
      paymentMonth: _monthController.text,
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LogoWidget(size: 120, showText: true),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('تعديل الدفع', style: AppTheme.adminPageTitle),
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
                    controller: _studentController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'رسوم التغذية',
                    controller: _nutritionController,
                    onChanged: (_) => _calculateTotal(),
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'رسوم التسكين',
                    controller: _housingController,
                    onChanged: (_) => _calculateTotal(),
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'الإجمالي',
                    controller: _totalController,
                    readOnly: true,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'الشهر',
                    controller: _monthController,
                  ),
                  const SizedBox(height: 24),
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
