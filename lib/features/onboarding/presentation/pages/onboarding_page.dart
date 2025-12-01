import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/constants/app_strings.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/core/widgets/animated_widgets.dart';
import 'package:almaali_university_center/features/onboarding/presentation/widgets/onboarding_content.dart';
import 'package:almaali_university_center/features/onboarding/presentation/widgets/page_indicator.dart';
import 'package:almaali_university_center/logic/cubits/onboarding/onboarding_cubit.dart';
import 'package:almaali_university_center/logic/cubits/onboarding/onboarding_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    final size = MediaQuery.of(context).size;

    final List<OnboardingData> pages = [
      OnboardingData(
        title: AppStrings.onboardingTitle1,
        description: AppStrings.onboardingDescription1,
      ),
      OnboardingData(
        title: AppStrings.onboardingTitle2,
        description: AppStrings.onboardingDescription2,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button
            FadeInWidget(
              delay: const Duration(milliseconds: 300),
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AnimatedButton(
                    onPressed: () {
                      Prefs.setBool('seenOnboarding', true);
                      context.go(AppRoutes.signIn);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        AppStrings.skip,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textLight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: cubit.pageController,
                onPageChanged: cubit.onPageChanged,
                itemCount: pages.length,
                itemBuilder: (context, index) {
                  return OnboardingContent(data: pages[index]);
                },
              ),
            ),

            // Page Indicators
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder:
                  (context, state) => SlideInWidget(
                    begin: const Offset(0, 0.3),
                    duration: const Duration(milliseconds: 400),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: PageIndicator(
                        currentPage: state.currentPage,
                        pageCount: pages.length,
                      ),
                    ),
                  ),
            ),

            // Start Button (only on last page)
            BlocBuilder<OnboardingCubit, OnboardingState>(
              builder:
                  (context, state) =>
                      state.isLastPage
                          ? SlideInWidget(
                            begin: const Offset(0, 0.5),
                            duration: const Duration(milliseconds: 500),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 24,
                              ),
                              child: AnimatedButton(
                                onPressed: () {
                                  context.go(AppRoutes.signIn);
                                  Prefs.setBool('seenOnboarding', true);
                                },
                                child: Container(
                                  width: size.width * 0.8,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.buttonPrimary,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  alignment: Alignment.center,
                                  child: const Text(
                                    AppStrings.start,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.textLight,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                          : const SizedBox(height: 80),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;

  OnboardingData({required this.title, required this.description});
}
