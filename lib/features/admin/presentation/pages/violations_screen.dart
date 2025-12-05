import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/constants/user_role.dart';
import 'package:almaali_university_center/core/services/role_service.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/admin/data/models/violation_model.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/view_violation_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/edit_violation_screen.dart';
import 'package:almaali_university_center/logic/cubits/violations/violations_cubit.dart';
import 'package:almaali_university_center/logic/cubits/violations/violations_state.dart';

class ViolationsScreen extends StatefulWidget {
  const ViolationsScreen({super.key});

  @override
  State<ViolationsScreen> createState() => _ViolationsScreenState();
}

class _ViolationsScreenState extends State<ViolationsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    // تحميل المخالفات من API
    context.read<ViolationsCubit>().loadViolations();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
    // ISS-003 FIX: Check user role for RBAC
    _checkUserRole();
  }

  Future<void> _checkUserRole() async {
    final role = await RoleService.getRole();
    if (mounted) {
      setState(() {
        _isAdmin = role == UserRole.admin;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deleteViolation(int id) {
    context.read<ViolationsCubit>().deleteViolation(id);
  }

  List<Violation> _filterViolations(List<Violation> violations) {
    if (_searchQuery.isEmpty) return violations;
    return violations.where((v) => 
      (v.studentName?.contains(_searchQuery) ?? false) ||
      v.title.contains(_searchQuery)
    ).toList();
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

            // Violations List from API
            Expanded(
              child: BlocConsumer<ViolationsCubit, ViolationsState>(
                listener: (context, state) {
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage!),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.read<ViolationsCubit>().clearSuccess();
                  }
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                    context.read<ViolationsCubit>().clearError();
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final violations = _filterViolations(state.violations);
                  
                  if (violations.isEmpty) {
                    return const Center(
                      child: Text('لا توجد مخالفات'),
                    );
                  }
                  
                  // ISS-006 FIX: Use PageStorageKey to preserve scroll position
                  return ListView.builder(
                    key: const PageStorageKey<String>('violations_list'),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: violations.length,
                    itemBuilder: (context, index) {
                      final violation = violations[index];
                      return ViolationListCard(
                        violation: violation,
                        isAdmin: _isAdmin,
                        onView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewViolationScreen(
                                violation: violation,
                              ),
                            ),
                          );
                        },
                        onEdit: _isAdmin ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditViolationScreen(
                                violation: violation,
                              ),
                            ),
                          );
                        } : null,
                        onDelete: _isAdmin ? () {
                          _deleteViolation(violation.id);
                        } : null,
                      );
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
  final Violation violation;
  final VoidCallback onView;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool isAdmin;

  const ViolationListCard({
    super.key,
    required this.violation,
    required this.onView,
    this.onEdit,
    this.onDelete,
    this.isAdmin = false,
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
            // Action Buttons - ISS-003 FIX: Conditionally show Edit/Delete for Admin only
            Column(
              children: [
                _ActionButton(
                  key: const Key('view_violation_btn'),
                  icon: Icons.visibility_outlined,
                  label: 'عرض',
                  onPressed: onView,
                ),
                if (isAdmin && onEdit != null) ...[
                  const SizedBox(height: 8),
                  _ActionButton(
                    key: const Key('edit_violation_btn'),
                    icon: Icons.edit_outlined,
                    label: 'تعديل',
                    onPressed: onEdit!,
                  ),
                ],
                if (isAdmin && onDelete != null) ...[
                  const SizedBox(height: 8),
                  _ActionButton(
                    key: const Key('delete_violation_btn'),
                    icon: Icons.delete_outline,
                    label: 'حـذف',
                    onPressed: onDelete!,
                  ),
                ],
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
                      'الطالب: ${violation.studentName ?? 'غير محدد'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'المخالفة: ${violation.title}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'العقوبة: ${violation.discipline}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
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
    super.key,
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

// ViolationItem تم استبداله بـ Violation model من:
// lib/features/admin/data/models/violation_model.dart
