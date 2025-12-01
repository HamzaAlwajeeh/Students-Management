import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_cubit.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CommitmentsPage extends StatefulWidget {
  const CommitmentsPage({super.key});

  @override
  State<CommitmentsPage> createState() => _CommitmentsPageState();
}

class _CommitmentsPageState extends State<CommitmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<CommitmentsCubit>().loadCommitments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with back button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D5A8F),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 24,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Logo
            const LogoWidget(size: 100, showText: true),
            const SizedBox(height: 24),

            // Title
            const Text(
              'الإلتزامات',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0D5A8F),
              ),
            ),
            const SizedBox(height: 8),

            // Divider
            Container(width: 200, height: 2, color: const Color(0xFF0D5A8F)),
            const SizedBox(height: 24),

            // Commitments List
            BlocBuilder<CommitmentsCubit, CommitmentsState>(
              builder: (context, state) {
                return state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.commitments.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCommitmentCard(
                              commitment: state.commitments[index],
                            ),
                          );
                        },
                      ),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommitmentCard({required Commitment commitment}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2196F3), Color(0xFF0D5A8F)],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            commitment.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 12),
          Text(
            commitment.description,
            style: TextStyle(fontSize: 15, color: Colors.white, height: 1.5),
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 12),
          Text(
            commitment.date.toString(),
            style: TextStyle(fontSize: 14, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
