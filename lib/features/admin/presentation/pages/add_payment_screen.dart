import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/student_dropdown.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  String? _selectedStudent;
  final TextEditingController _nutritionController = TextEditingController();
  final TextEditingController _housingController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _remainingController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();

  final List<String> _students = [
    'أحمد محمد علي',
    'محمد أحمد سعيد',
    'علي حسن محمد',
  ];

  @override
  void dispose() {
    _nutritionController.dispose();
    _housingController.dispose();
    _totalController.dispose();
    _remainingController.dispose();
    _monthController.dispose();
    super.dispose();
  }

  void _calculateTotal() {
    final nutrition = double.tryParse(_nutritionController.text) ?? 0;
    final housing = double.tryParse(_housingController.text) ?? 0;
    final total = nutrition + housing;
    _totalController.text = total.toStringAsFixed(0);
  }

  void _addPayment() {
    if (_selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار الطالب'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إضافة الدفع بنجاح'),
        backgroundColor: Colors.green,
      ),
    );

    setState(() {
      _selectedStudent = null;
      _nutritionController.clear();
      _housingController.clear();
      _totalController.clear();
      _remainingController.clear();
      _monthController.clear();
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
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: LogoWidget(size: 120, showText: true),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text('إضافة دفع', style: AppTheme.adminPageTitle),
              ),
              Container(
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: AppColors.primaryBlue,
              ),
              const SizedBox(height: 16),
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
              ViolationFormCard(
                children: [
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
                    label: 'المتبقي',
                    controller: _remainingController,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'الشهر',
                    controller: _monthController,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _addPayment,
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
