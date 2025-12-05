import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:almaali_university_center/core/routing/route_guard.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/constants/app_strings.dart';
import 'package:almaali_university_center/core/constants/app_assets.dart';
import 'package:almaali_university_center/core/constants/user_role.dart';
import 'package:almaali_university_center/core/services/role_service.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/animated_widgets.dart';

class StudentAcceptedPage extends StatelessWidget {
  const StudentAcceptedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Logo
              ScaleInWidget(
                duration: const Duration(milliseconds: 600),
                child: const LogoWidget(size: 140, showText: true),
              ),

              // Accept Icon and Message
              Column(
                children: [
                  // Accept Icon
                  ScaleInWidget(
                    delay: const Duration(milliseconds: 300),
                    duration: const Duration(milliseconds: 800),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Image.asset(
                          AppAssets.accept,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Message
                  FadeInWidget(
                    delay: const Duration(milliseconds: 600),
                    child: const Text(
                      AppStrings.accepted,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlue,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              // Enter Button
              FadeInWidget(
                delay: const Duration(milliseconds: 800),
                child: AnimatedButton(
                  key: const Key('enter_home_btn'),
                  onPressed: () async {
                    // ISS-004 FIX: Set user role to student before navigating
                    await RoleService.saveRole(UserRole.student);
                    if (context.mounted) {
                      // Navigate to student home
                      final target = RouteGuard.getDefaultRoute(UserRole.student);
                      context.go(target);
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
                      AppStrings.enter,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
