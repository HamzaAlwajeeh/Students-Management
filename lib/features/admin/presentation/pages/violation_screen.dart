import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';
import 'package:almaali_university_center/core/widgets/admin_card.dart';
import 'package:almaali_university_center/core/widgets/admin_bottom_nav.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/admin_main_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/payments_screen.dart';

class ViolationScreen extends StatefulWidget {
  const ViolationScreen({super.key});

  @override
  State<ViolationScreen> createState() => _ViolationScreenState();
}

class _ViolationScreenState extends State<ViolationScreen> {
  int _currentIndex = 0; // Violations tab
  bool _hasViolations = true; // Toggle between states
  String _searchQuery = '';

  void _onNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    // Navigate to different screens
    switch (index) {
      case 0: // Violations (stay on this screen)
        break;
      case 1: // Home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminMainScreen()),
        );
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
      appBar: const AdminAppBar(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            // Logo Section
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: LogoWidget(size: 120, showText: true),
            ),

            // Title
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                _hasViolations ? 'المخالفات' : 'الاخبار',
                style: AppTheme.adminPageTitle,
              ),
            ),

            // Divider
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.primaryBlue,
            ),

            const SizedBox(height: 16),

            // Content - either violations list or no violations view
            Expanded(
              child:
                  _hasViolations
                      ? const ViolationsListView()
                      : NoViolationsView(
                        searchQuery: _searchQuery,
                        onSearchChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: AdminBottomNav(
        currentIndex: _currentIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

// ============================================================================
// Violations List View - Shows when there are violations
// ============================================================================
class ViolationsListView extends StatelessWidget {
  const ViolationsListView({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample violation data
    final violations = List.generate(
      4,
      (index) => ViolationData(
        number: 1,
        type: 'التخلف عن صلاة الفجر',
        penalty: 'حرمان من وجبة الغداء لمدة يومين',
      ),
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: violations.length,
      itemBuilder: (context, index) {
        return ViolationCard(violation: violations[index]);
      },
    );
  }
}

// ============================================================================
// No Violations View - Shows when there are no violations
// ============================================================================
class NoViolationsView extends StatelessWidget {
  final String searchQuery;
  final ValueChanged<String> onSearchChanged;

  const NoViolationsView({
    super.key,
    required this.searchQuery,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.primaryGold,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, color: AppColors.textLight, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  onChanged: onSearchChanged,
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'البحث باسم الطالب',
                    hintStyle: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 40),

        // No Violations Icon and Message
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.primaryBlue, width: 8),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 8,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        transform: Matrix4.rotationZ(-0.785398), // -45 degrees
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'لاتوجد مخالفات بعد',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGold,
                ),
              ),
            ],
          ),
        ),

        // Add Button
        Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add violation action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGold,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
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
      ],
    );
  }
}

// ============================================================================
// Violation Card Widget
// ============================================================================
class ViolationCard extends StatelessWidget {
  final ViolationData violation;

  const ViolationCard({super.key, required this.violation});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'رقم المخالفة : ${violation.number}',
            style: AppTheme.adminCardTitle,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 12),
          Text(
            'المخالفة : ${violation.type}',
            style: AppTheme.adminCardBody,
            textAlign: TextAlign.right,
          ),
          const SizedBox(height: 8),
          Text(
            'العقوبة :${violation.penalty}',
            style: AppTheme.adminCardBody,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// Violation Data Model
// ============================================================================
class ViolationData {
  final int number;
  final String type;
  final String penalty;

  ViolationData({
    required this.number,
    required this.type,
    required this.penalty,
  });
}
