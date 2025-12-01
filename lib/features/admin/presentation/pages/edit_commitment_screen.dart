import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/core/widgets/admin_app_bar.dart';
import 'package:almaali_university_center/features/admin/presentation/widgets/violation_form_card.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_cubit.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_state.dart';

class EditCommitmentScreen extends StatefulWidget {
  final Commitment commitment;

  const EditCommitmentScreen({super.key, required this.commitment});

  @override
  State<EditCommitmentScreen> createState() => _EditCommitmentScreenState();
}

class _EditCommitmentScreenState extends State<EditCommitmentScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.commitment.title);
    _descriptionController = TextEditingController(
      text: widget.commitment.description,
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء ملء جميع الحقول'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await context.read<CommitmentsCubit>().updateCommitment(
      id: widget.commitment.id,
      title: _titleController.text,
      description: _descriptionController.text,
    );

    if (success && mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AdminAppBar(showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
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
              ViolationFormCard(
                children: [
                  TextField(
                    controller: _titleController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textLight,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'عنوان الالتزام',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    textAlign: TextAlign.right,
                    maxLines: 5,
                    style: const TextStyle(
                      color: AppColors.textLight,
                      fontSize: 16,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'تفاصيل الالتزام',
                      labelStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // زر التعديل مع حالة التحميل
              BlocConsumer<CommitmentsCubit, CommitmentsState>(
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.isSubmitting ? null : _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGold,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state.isSubmitting
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: AppColors.textLight,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'تعديل',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textLight,
                                ),
                              ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
