import 'package:almaali_university_center/core/services/api_services.dart';
import 'package:almaali_university_center/logic/cubits/auth/auth_cubit.dart';
import 'package:almaali_university_center/logic/cubits/commitments/commitments_cubit.dart';
import 'package:almaali_university_center/logic/cubits/complaints/complaints_cubit.dart';
import 'package:almaali_university_center/logic/cubits/home/home_cubit.dart';
import 'package:almaali_university_center/logic/cubits/news/news_cubit.dart';
import 'package:almaali_university_center/logic/cubits/onboarding/onboarding_cubit.dart';
import 'package:almaali_university_center/logic/cubits/payments/payments_cubit.dart';
import 'package:almaali_university_center/logic/cubits/students/students_cubit.dart';
import 'package:almaali_university_center/logic/cubits/violations/violations_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// توفير جميع الـ Cubits للتطبيق
/// كل Feature رئيسية لها Cubit واحد فقط
class BlocProviders {
  /// قائمة جميع الـ BlocProviders
  static List<BlocProvider> get providers => [
    // Auth Feature
    BlocProvider<AuthCubit>(create: (context) => AuthCubit()),
    // Onboarding Feature
    BlocProvider<OnboardingCubit>(create: (context) => OnboardingCubit()),
    // Home Feature
    BlocProvider<HomeCubit>(
      create: (context) => HomeCubit(apiService: ApiService()),
    ),
    // Students Feature
    BlocProvider<StudentsCubit>(
      create: (context) => StudentsCubit(apiServices: ApiService()),
    ),
    // Complaints Feature
    BlocProvider<ComplaintsCubit>(
      create: (context) => ComplaintsCubit(apiService: ApiService()),
    ),
    // Commitments Feature
    BlocProvider<CommitmentsCubit>(
      create: (context) => CommitmentsCubit(apiService: ApiService()),
    ),
    // Violations Feature
    BlocProvider<ViolationsCubit>(
      create: (context) => ViolationsCubit(apiService: ApiService()),
    ),
    // Payments Feature
    BlocProvider<PaymentsCubit>(
      create: (context) => PaymentsCubit(apiService: ApiService()),
    ),
    // News Feature
    BlocProvider<NewsCubit>(
      create: (context) => NewsCubit(apiService: ApiService()),
    ),
  ];

  /// Widget يغلف التطبيق بجميع الـ Providers
  static Widget wrapWithProviders({required Widget child}) {
    return MultiBlocProvider(providers: providers, child: child);
  }
}
