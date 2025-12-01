import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_cubit.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_state.dart';

class CommitmentsScreen extends StatefulWidget {
  const CommitmentsScreen({super.key});

  @override
  State<CommitmentsScreen> createState() => _CommitmentsScreenState();
}

class _CommitmentsScreenState extends State<CommitmentsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CommitmentsCubit>().loadCommitments();
  }

  void _deleteCommitment(int id) {
    context.read<CommitmentsCubit>().deleteCommitment(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AdminAppBar(showBackButton: true),
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: LogoWidget(size: 120, showText: true),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text('الإلتزامات', style: AppTheme.adminPageTitle),
            ),
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: BlocConsumer<CommitmentsCubit, CommitmentsState>(
                listener: (context, state) {
                  if (state.successMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.successMessage!),
                        backgroundColor: Colors.green,
                      ),
                    );
                    context.read<CommitmentsCubit>().clearSuccess();
                  }
                  if (state.errorMessage != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.errorMessage!),
                        backgroundColor: Colors.red,
                      ),
                    );
                    context.read<CommitmentsCubit>().clearError();
                  }
                },
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (state.commitments.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد التزامات',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    );
                  }
                  
                  return RefreshIndicator(
                    onRefresh: () => context.read<CommitmentsCubit>().refresh(),
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.commitments.length,
                      itemBuilder: (context, index) {
                        final commitment = state.commitments[index];
                        return CommitmentCard(
                          commitment: commitment,
                          onDelete: () => _deleteCommitment(commitment.id),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Commitment Card Widget
// ============================================================================
class CommitmentCard extends StatelessWidget {
  final Commitment commitment;
  final VoidCallback onDelete;

  const CommitmentCard({
    super.key,
    required this.commitment,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                    Icons.delete_outline,
                    color: AppColors.primaryGold,
                    size: 28,
                  ),
                  onPressed: onDelete,
                ),
                Expanded(
                  child: Text(
                    commitment.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              commitment.description,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
                height: 1.6,
              ),
              textAlign: TextAlign.right,
            ),
            if (commitment.date != null) ...[
              const SizedBox(height: 12),
              Text(
                commitment.date!,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textLight,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
