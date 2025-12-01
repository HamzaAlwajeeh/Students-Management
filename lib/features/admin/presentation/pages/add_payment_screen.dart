import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';
import 'package:almaali_university_center/features/students/data/model/student_model.dart';
import 'package:almaali_university_center/logic/cubits/students/students_cubit.dart';
import 'package:almaali_university_center/logic/cubits/students/students_state.dart';
import 'package:almaali_university_center/logic/cubits/payments/payments_cubit.dart';
import 'package:almaali_university_center/logic/cubits/payments/payments_state.dart';

class AddPaymentScreen extends StatefulWidget {
  const AddPaymentScreen({super.key});

  @override
  State<AddPaymentScreen> createState() => _AddPaymentScreenState();
}

class _AddPaymentScreenState extends State<AddPaymentScreen> {
  Student? _selectedStudent;
  final TextEditingController _nutritionController = TextEditingController();
  final TextEditingController _housingController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // تحميل قائمة الطلاب من API
    context.read<StudentsCubit>().loadStudents();
  }

  @override
  void dispose() {
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

  Future<void> _addPayment() async {
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

    // استدعاء API لإضافة الدفعة
    final success = await context.read<PaymentsCubit>().addPayment(
      studentId: _selectedStudent!.id,
      studentName: _selectedStudent!.name,
      foodPayment: int.tryParse(_nutritionController.text) ?? 0,
      housingPayment: int.tryParse(_housingController.text) ?? 0,
      paymentMonth: _monthController.text,
    );

    if (success && mounted) {
      setState(() {
        _selectedStudent = null;
        _nutritionController.clear();
        _housingController.clear();
        _totalController.clear();
        _monthController.clear();
      });
    }
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
              
              // Student Dropdown from API
              BlocBuilder<StudentsCubit, StudentsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Student>(
                        value: _selectedStudent,
                        hint: const Text(
                          'اختر الطالب',
                          style: TextStyle(color: Colors.white70),
                        ),
                        isExpanded: true,
                        dropdownColor: AppColors.primaryBlue,
                        icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                        items: state.students.map((student) {
                          return DropdownMenuItem<Student>(
                            value: student,
                            child: Text(
                              student.name,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedStudent = value;
                          });
                        },
                      ),
                    ),
                  );
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
                    label: 'الشهر',
                    controller: _monthController,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Add Button with loading state
              BlocConsumer<PaymentsCubit, PaymentsState>(
                listener: (context, state) {
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage!),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.read<PaymentsCubit>().clearSuccess();
                  }
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                    context.read<PaymentsCubit>().clearError();
                  }
                },
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting ? null : _addPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.textLight,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'إضافــــة',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textLight,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
