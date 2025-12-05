import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/constants/app_strings.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/animated_widgets.dart';

// ISS-007 FIX: Convert to StatefulWidget for proper form validation
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _fourthNameController = TextEditingController();
  final _universityController = TextEditingController();
  final _specializationController = TextEditingController();
  final _mobileController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _fatherMobileController = TextEditingController();
  final _skillsController = TextEditingController();

  @override
  void dispose() {
    _fourthNameController.dispose();
    _universityController.dispose();
    _specializationController.dispose();
    _mobileController.dispose();
    _fatherNameController.dispose();
    _fatherMobileController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    return null;
  }

  String? _validateMobile(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'هذا الحقل مطلوب';
    }
    if (!RegExp(r'^[0-9]{9,15}$').hasMatch(value.trim())) {
      return 'رقم الهاتف غير صحيح';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Back Button
              FadeInWidget(
                duration: const Duration(milliseconds: 400),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedButton(
                      onPressed: () => context.pop(),
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Logo
              ScaleInWidget(
                duration: const Duration(milliseconds: 600),
                child: const LogoWidget(size: 100, showText: true),
              ),

              const SizedBox(height: 24),

              // Registration Form Container
              SlideInWidget(
                begin: const Offset(0, 0.3),
                duration: const Duration(milliseconds: 700),
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF1E88E5), Color(0xFF0D5A8F)],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Title
                        const Text(
                          AppStrings.registrationTitle,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 8),

                        // Subtitle
                        const Text(
                          AppStrings.registrationSubtitle,
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: 32),

                        // Form Fields with validation
                        _buildTextField(
                          label: AppStrings.fourthName,
                          controller: _fourthNameController,
                          validator: _validateRequired,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: AppStrings.universityInstitute,
                          controller: _universityController,
                          validator: _validateRequired,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: AppStrings.specialization,
                          controller: _specializationController,
                          validator: _validateRequired,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: AppStrings.mobileNumber,
                          controller: _mobileController,
                          validator: _validateMobile,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: AppStrings.fatherName,
                          controller: _fatherNameController,
                          validator: _validateRequired,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: AppStrings.fatherMobile,
                          controller: _fatherMobileController,
                          validator: _validateMobile,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        _buildTextField(
                          label: AppStrings.skills,
                          controller: _skillsController,
                        ),

                        const SizedBox(height: 32),

                        // Submit Button with validation
                        AnimatedButton(
                          key: const Key('submit_registration_btn'),
                          onPressed: () {
                            // ISS-007 FIX: Validate form before submission
                            if (_formKey.currentState!.validate()) {
                              context.push('/student-accepted');
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppColors.primaryGold,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              AppStrings.send,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
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

  // ISS-007 FIX: Updated _buildTextField with validation support
  Widget _buildTextField({
    required String label,
    TextEditingController? controller,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (validator != null)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGold, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.primaryGold, width: 3),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 3),
            ),
            errorStyle: const TextStyle(color: Colors.yellow),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
