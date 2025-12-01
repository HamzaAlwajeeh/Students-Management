import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/logic/cubits/auth/auth_cubit.dart';
import 'package:almaali_university_center/logic/cubits/auth/auth_state.dart';
import 'package:almaali_university_center/logic/cubits/home/home_cubit.dart';
import 'package:almaali_university_center/logic/cubits/home/home_state.dart';
import 'package:almaali_university_center/logic/cubits/students/students_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1; // Home is selected by default

  @override
  void initState() {
    super.initState();
    // تحميل بيانات الصفحة الرئيسية عند فتح الصفحة
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      endDrawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            // Top bar with menu button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 40),
                  const Spacer(),
                  Builder(
                    builder:
                        (context) => IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: AppColors.primaryGold,
                            size: 32,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                        ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Logo
                    const LogoWidget(size: 100, showText: true),
                    const SizedBox(height: 32),

                    // Greeting Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 32,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGold,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              return Text(
                                'مرحبا / ${state.userEmail}',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              );
                            },
                          ),
                          SizedBox(height: 16),
                          Text(
                            'كيف حالك اليوم ؟؟',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Latest News Title
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'اخر الاخبار :',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // News Cards from API
                    BlocBuilder<HomeCubit, HomeState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.errorMessage != null) {
                          return Center(
                            child: Text(
                              state.errorMessage!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        if (state.news.isEmpty) {
                          return const Center(
                            child: Text('لا توجد أخبار حالياً'),
                          );
                        }
                        return Column(
                          children: state.news.map((newsItem) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: _buildNewsCard(newsItem.title, newsItem.details),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildNewsCard(String title, String details) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF2196F3), Color(0xFF0D5A8F)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, color: Colors.white.withOpacity(0.5)),
          const SizedBox(height: 8),
          Text(
            details,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF0D5A8F),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            icon: Icons.shopping_bag_outlined,
            label: 'المدفوعات',
            index: 0,
          ),
          _buildNavItem(icon: Icons.home_outlined, label: 'الرئيسية', index: 1),
          _buildNavItem(
            icon: Icons.gavel_outlined,
            label: 'المخالفات',
            index: 2,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        if (index == 2) {
          context.push(AppRoutes.violations);
        } else if (index == 0) {
          context.push(AppRoutes.payments);
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2196F3), Color(0xFF0D5A8F)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 40),
              // Profile Section
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
              const SizedBox(height: 16),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return Text(
                    state.userName.isNotEmpty ? state.userName : 'مستخدم',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(height: 4),
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.white.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      state.userSpecialization.isNotEmpty 
                          ? state.userSpecialization 
                          : 'غير محدد',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              // Menu Items
              _buildDrawerItem(
                icon: Icons.person_outline,
                label: 'الطــــلاب',
                onTap: () {
                  BlocProvider.of<StudentsCubit>(context).loadStudents();
                  Navigator.pop(context);
                  context.push(AppRoutes.students);
                },
              ),
              _buildDrawerItem(
                icon: Icons.report_problem_outlined,
                label: 'الشكاوي',
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.complaints);
                },
              ),
              _buildDrawerItem(
                icon: Icons.assignment_outlined,
                label: 'الإلتزامات',
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.commitments);
                },
              ),
              _buildDrawerItem(
                icon: Icons.info_outline,
                label: 'عن التطبيق',
                onTap: () {
                  Navigator.pop(context);
                  context.push(AppRoutes.about);
                },
              ),
              _buildDrawerItem(
                icon: Icons.logout_outlined,
                label: 'تسجيل الخروج',
                onTap: () {
                  Navigator.pop(context);
                  context.pushReplacement(AppRoutes.signIn);
                  Prefs.removeString('token');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.white.withOpacity(0.3), width: 1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 16),
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF0D5A8F), size: 24),
            ),
          ],
        ),
      ),
    );
  }
}
