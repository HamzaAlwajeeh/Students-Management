import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/view_violation_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/edit_violation_screen.dart';

class ViolationsScreen extends StatefulWidget {
  const ViolationsScreen({super.key});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<ViolationItem> _violations = [];

  @override
  void initState() {
    super.initState();
    _loadViolations();
  }

  void _loadViolations() {
    // Sample data
    setState(() {
      _violations = [
        ViolationItem(
          id: '1',
          studentName: 'أحمد محمد علي',
          violation: 'التخلف عن صلاة الفجر',
        ),
        ViolationItem(
          id: '2',
          studentName: 'محمد أحمد سعيد',
          violation: 'التأخر عن الحصة',
        ),
        ViolationItem(
          id: '3',
          studentName: 'علي حسن محمد',
          violation: 'عدم ارتداء الزي الرسمي',
        ),
      ];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deleteViolation(String id) {
    setState(() {
      _violations.removeWhere((v) => v.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف المخالفة'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Logo Section
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: LogoWidget(size: 120, showText: true),
            ),

            // Title
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('عرض المخالفات', style: AppTheme.adminPageTitle),
            ),

            // Divider
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.primaryBlue,
            ),

            const SizedBox(height: 16),

            // Search Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primaryGold,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: AppColors.textLight,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        color: AppColors.textLight,
                        fontSize: 16,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'البحث باسمه الطالب',
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

            const SizedBox(height: 16),

            // Violations List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _violations.length,
                itemBuilder: (context, index) {
                  return ViolationListCard(
                    violation: _violations[index],
                    onView: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => ViewViolationScreen(
                                violation: _violations[index],
                              ),
                        ),
                      );
                    },
                    onEdit: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => EditViolationScreen(
                                violation: _violations[index],
                              ),
                        ),
                      );
                    },
                    onDelete: () {
                      _deleteViolation(_violations[index].id);
                    },
                  );
                },
              ),
            ),

            // Back Button
            Padding(
              padding: const EdgeInsets.all(24),
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
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Violation List Card Widget
// ============================================================================
class ViolationListCard extends StatelessWidget {
  final ViolationItem violation;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ViolationListCard({
    super.key,
    required this.violation,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2E7BA8), Color(0xFF0D5A8F)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Action Buttons
            Column(
              children: [
                _ActionButton(
                  icon: Icons.visibility_outlined,
                  label: 'عرض',
                  onPressed: onView,
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  icon: Icons.edit_outlined,
                  label: 'تعديل',
                  onPressed: onEdit,
                ),
                const SizedBox(height: 8),
                _ActionButton(
                  icon: Icons.delete_outline,
                  label: 'حـذف',
                  onPressed: onDelete,
                ),
              ],
            ),

            const SizedBox(width: 16),

            // Violation Details
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'الطالب: ${violation.studentName}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'المخالفة: ${violation.violation}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Action Button Widget
// ============================================================================
class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textLight,
        foregroundColor: AppColors.primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 4),
          Icon(icon, size: 18),
        ],
      ),
    );
  }
}

// ============================================================================
// Violation Item Model
// ============================================================================
class ViolationItem {
  final String id;
  final String studentName;
  final String violation;
  final String? penalty;
  final String? notes;

  ViolationItem({
    required this.id,
    required this.studentName,
    required this.violation,
    this.penalty,
    this.notes,
  });
}
