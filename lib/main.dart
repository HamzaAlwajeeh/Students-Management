import 'package:almaali_university_center/core/constants/app_strings.dart';
import 'package:almaali_university_center/core/di/bloc_providers.dart';
import 'package:almaali_university_center/core/routing/app_router.dart';
import 'package:almaali_university_center/core/services/shared_pref.dart';
import 'package:almaali_university_center/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Prefs.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // استخدام BlocProviders المركزي لتوفير جميع Cubits
    return BlocProviders.wrapWithProviders(
      child: MaterialApp.router(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
