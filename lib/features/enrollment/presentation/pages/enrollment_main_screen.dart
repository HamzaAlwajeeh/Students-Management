import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/enrollment/presentation/pages/registration_screen.dart';

class EnrollmentMainScreen extends StatelessWidget {
  const EnrollmentMainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                // Logo
                const Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 24),
                  child: LogoWidget(size: 140, showText: true),
                ),

                // About Center Section
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'نبذة عن المركز :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // About Center Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2E7BA8), Color(0xFF0D5A8F)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'مركز المعالي الجامعي هو مركز تعليمي متخصص يهدف إلى تقديم خدمات تعليمية وتربوية متميزة للطلاب في مختلف التخصصات الأكاديمية',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textLight,
                      height: 1.8,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),

                const SizedBox(height: 32),

                // Partner Logos Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildPartnerLogo(),
                    _buildPartnerLogo(),
                    _buildPartnerLogo(),
                  ],
                ),

                const SizedBox(height: 32),

                // Center Features Section
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'مميزات المركز :',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGold,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Features Card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2E7BA8), Color(0xFF0D5A8F)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: const [
                      Text(
                        '• كادر تعليمي متميز ومؤهل',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLight,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        '• بيئة تعليمية محفزة ومناسبة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLight,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        '• خدمات طلابية متكاملة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLight,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Text(
                        '• أنشطة وفعاليات متنوعة',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textLight,
                          height: 1.8,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Enrollment Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegistrationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGold,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'الإلتحاق بالمركــز',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textLight,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPartnerLogo() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryBlue, width: 2),
      ),
      child: Center(
        child: Image.asset(
          'assets/images/sos_logo.png',
          width: 80,
          height: 80,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(
              Icons.school,
              size: 50,
              color: AppColors.primaryBlue,
            );
          },
        ),
      ),
    );
  }
}
