import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_input_field.dart';
import 'package:almaali_university_center/features/enrollment/presentation/pages/accepted_screen.dart';
import 'package:almaali_university_center/logic/cubits/auth/auth_cubit.dart';
import 'package:almaali_university_center/logic/cubits/auth/auth_state.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _specializationController =
      TextEditingController();
  final TextEditingController _universityController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _specializationController.dispose();
    _universityController.dispose();
    super.dispose();
  }

  Future<void> _submitRegistration() async {
    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _addressController.text.isEmpty ||
        _specializationController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء جميع الحقول المطلوبة'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // استدعاء API للتسجيل
    final result = await context.read<AuthCubit>().register(
      name: _nameController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      specialization: _specializationController.text,
      university: _universityController.text,
    );

    if (!mounted) return;

    if (result['success'] == true) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => AcceptedScreen(studentName: _nameController.text),
        ),
      );
    } else {
      // في حالة الفشل، عرض رسالة الخطأ
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'فشل تقديم الطلب'),
          backgroundColor: Colors.red,
        ),
      );
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
                child: Text(
                  'التسجيل في المركز',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                  ),
                ),
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
                    label: 'الاسم الكامل *',
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'رقم الهاتف *',
                    controller: _phoneController,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'المدينة / العنوان *',
                    controller: _addressController,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'التخصص *',
                    controller: _specializationController,
                  ),
                  const SizedBox(height: 20),
                  ViolationInputField(
                    label: 'الجامعة',
                    controller: _universityController,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isLoading ? null : _submitRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.textLight,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'تقديم الطلب',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textLight,
                                ),
                              ),
                      ),
                    );
                  },
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
