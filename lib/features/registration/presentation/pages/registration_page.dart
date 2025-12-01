import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/constants/app_strings.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/animated_widgets.dart';

class RegistrationPage extends StatelessWidget {
  const RegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

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
                    key: formKey,
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

                        // Form Fields
                        _buildTextField(AppStrings.fourthName),
                        const SizedBox(height: 20),
                        _buildTextField(AppStrings.universityInstitute),
                        const SizedBox(height: 20),
                        _buildTextField(AppStrings.specialization),
                        const SizedBox(height: 20),
                        _buildTextField(AppStrings.specialization),
                        const SizedBox(height: 20),
                        _buildTextField(AppStrings.mobileNumber),
                        const SizedBox(height: 20),
                        _buildTextField(AppStrings.fatherName),
                        const SizedBox(height: 20),
                        _buildTextField(AppStrings.fatherMobile),
                        const SizedBox(height: 20),
                        _buildTextField(AppStrings.skills),

                        const SizedBox(height: 32),

                        // Submit Button
                        AnimatedButton(
                          onPressed: () {
                            // Navigate to accepted or rejected screen
                            // For demo, randomly choose
                            context.push('/student-accepted');
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

  Widget _buildTextField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primaryGold, width: 2),
          ),
          child: const TextField(
            textAlign: TextAlign.right,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
