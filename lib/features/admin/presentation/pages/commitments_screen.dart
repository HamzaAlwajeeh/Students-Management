import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';

class CommitmentsScreen extends StatefulWidget {
  const CommitmentsScreen({super.key});

  @override
  State<CommitmentsScreen> createState() => _CommitmentsScreenState();
}

class _CommitmentsScreenState extends State<CommitmentsScreen> {
  List<CommitmentItem> _commitments = [];

  @override
  void initState() {
    super.initState();
    _loadCommitments();
  }

  void _loadCommitments() {
    setState(() {
      _commitments = [
        CommitmentItem(
          id: '1',
          title: 'حلقات الفجر',
          description:
              'يجب على جميع الطلاب الإلتزام بحلقات الفجر لمدة ساعتان بعد الفجر وسيتم التحضير فيها',
          date: '21/10/2025',
        ),
        CommitmentItem(
          id: '2',
          title: 'حلقات الفجر',
          description:
              'يجب على جميع الطلاب الإلتزام بحلقات الفجر لمدة ساعتان بعد الفجر وسيتم التحضير فيها',
          date: '21/10/2025',
        ),
        CommitmentItem(
          id: '3',
          title: 'حلقات الفجر',
          description:
              'يجب على جميع الطلاب الإلتزام بحلقات الفجر لمدة ساعتان بعد الفجر وسيتم التحضير فيها',
          date: '21/10/2025',
        ),
      ];
    });
  }

  void _deleteCommitment(String id) {
    setState(() {
      _commitments.removeWhere((c) => c.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم حذف الإلتزام'),
        backgroundColor: Colors.green,
      ),
    );
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
              child: Text('الإرتزامات', style: AppTheme.adminPageTitle),
            ),
            Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              color: AppColors.primaryBlue,
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _commitments.length,
                itemBuilder: (context, index) {
                  return CommitmentCard(
                    commitment: _commitments[index],
                    onDelete: () {
                      _deleteCommitment(_commitments[index].id);
                    },
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
  final CommitmentItem commitment;
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
                Text(
                  commitment.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textLight,
                  ),
                  textAlign: TextAlign.right,
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
            const SizedBox(height: 12),
            Text(
              commitment.date,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Commitment Item Model
// ============================================================================
class CommitmentItem {
  final String id;
  final String title;
  final String description;
  final String date;

  CommitmentItem({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
  });
}
