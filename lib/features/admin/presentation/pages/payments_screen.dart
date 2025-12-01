import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/features/admin/data/models/payment_model.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/view_payment_screen.dart';
import 'package:almaali_university_center/features/admin/presentation/pages/edit_payment_screen.dart';
import 'package:almaali_university_center/logic/cubits/payments/payments_cubit.dart';
import 'package:almaali_university_center/logic/cubits/payments/payments_state.dart';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // تحميل المدفوعات من API
    context.read<PaymentsCubit>().loadPayments();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _deletePayment(int id) {
    context.read<PaymentsCubit>().deletePayment(id);
  }

  List<Payment> _filterPayments(List<Payment> payments) {
    if (_searchQuery.isEmpty) return payments;
    return payments.where((p) => 
      (p.studentName?.contains(_searchQuery) ?? false) ||
      p.paymentMonth.contains(_searchQuery)
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: LogoWidget(size: 120, showText: true),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('عرض المدفوعات', style: AppTheme.adminPageTitle),
            ),
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 16),
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
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Payments List from API
            Expanded(
              child: BlocConsumer<PaymentsCubit, PaymentsState>(
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
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  final payments = _filterPayments(state.payments);
                  
                  if (payments.isEmpty) {
                    return const Center(
                      child: Text('لا توجد مدفوعات'),
                    );
                  }
                  
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final payment = payments[index];
                      return PaymentListCard(
                        payment: payment,
                        onView: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ViewPaymentScreen(payment: payment),
                            ),
                          );
                        },
                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditPaymentScreen(payment: payment),
                            ),
                          );
                        },
                        onDelete: () {
                          _deletePayment(payment.id);
                        },
                      );
                    },
                  );
                },
              ),
            ),
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
// Payment List Card Widget
// ============================================================================
class PaymentListCard extends StatelessWidget {
  final Payment payment;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PaymentListCard({
    super.key,
    required this.payment,
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
                      'الطالب: ${payment.studentName ?? 'غير محدد'}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'التغذية: ${payment.foodPayment}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'السكن: ${payment.housingPayment}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الإجمالي: ${payment.totalPayment}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textLight,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الشهر: ${payment.paymentMonth}',
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

// PaymentItem تم استبداله بـ Payment model من:
// lib/features/admin/data/models/payment_model.dart
