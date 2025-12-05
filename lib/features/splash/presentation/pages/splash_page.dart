import 'dart:developer';

import 'package:almaali_university_center/core/constants/user_role.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';
import 'package:almaali_university_center/core/routing/route_guard.dart';
import 'package:almaali_university_center/core/services/role_service.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/core/widgets/animated_widgets.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboarding();
  }

  Future<void> _navigateToOnboarding() async {
    String? token = Prefs.getString('token');
    bool? seenOnBoarding = Prefs.getBool('seenOnboarding');
    log('token in splash: $token');

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      if (seenOnBoarding != null && seenOnBoarding) {
        if (token != null && token.isNotEmpty) {
          // ISS-005 FIX: Check role and navigate to role-specific home
          final role = await RoleService.getRole();
          if (role != UserRole.unauthenticated) {
            final defaultRoute = RouteGuard.getDefaultRoute(role);
            log('Navigating to role-specific home: $defaultRoute for role: $role');
            context.go(defaultRoute);
          } else {
            // Token exists but no valid role - go to signin
            context.go(AppRoutes.signIn);
          }
        } else {
          context.go(AppRoutes.signIn);
        }
      } else {
        context.go(AppRoutes.onboarding);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleInWidget(
              duration: const Duration(milliseconds: 800),
              child: const LogoWidget(size: 200, showText: false),
            ),
            const SizedBox(height: 20),
            FadeInWidget(
              delay: const Duration(milliseconds: 500),
              duration: const Duration(milliseconds: 600),
              child: const LogoWidget(size: 0, showText: true),
            ),
          ],
        ),
      ),
    );
  }
}
