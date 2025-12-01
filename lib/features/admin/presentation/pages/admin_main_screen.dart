import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';
import 'package:almaali_university_center/core/widgets/admin_card.dart';
import 'package:almaali_university_center/core/widgets/admin_bottom_nav.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/news_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/violation_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/payments_screen.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _currentIndex = 1; // Start at home (middle tab)

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    // Navigate to different screens
    switch (index) {
      case 0: // Violations
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ViolationScreen()),
        );
        break;
      case 1: // Home (stay on this screen)
        break;
      case 2: // Payments
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PaymentsScreen()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AdminAppBar(showBackButton: false),
      body: SafeArea(
        child: Column(
          children: [
            // Logo Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: LogoWidget(size: 120, showText: true),
            ),

            // Welcome Card
            AdminCard(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  Text(
                    'مرحبا ايها المشرف ...',
                    style: AppTheme.adminWelcomeTitle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'كيف حالك اليوم ؟؟',
                    style: AppTheme.adminWelcomeSubtitle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Latest News Section Title
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'اخر الاخبار :',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // News Card with Gradient
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFF2E7BA8), Color(0xFF0D5A8F)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: AppColors.textLight,
                                size: 24,
                              ),
                              onPressed: () {
                                // Delete news action
                              },
                            ),
                            const Expanded(
                              child: Text(
                                'العنوان',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textLight,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                          color: AppColors.textLight,
                          thickness: 1,
                          height: 24,
                        ),
                        const Text(
                          'التفاصيل',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textLight,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const NewsScreen()));
        },
        child: const Icon(Icons.add, size: 32),
      ),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}
