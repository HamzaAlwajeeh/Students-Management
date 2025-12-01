import 'package:almaali_university_center/core/constants/app_colors.dart';
import 'package:almaali_university_center/core/routing/app_routes.dart';
import 'package:almaali_university_center/core/widgets/animated_widgets.dart';
import 'package:almaali_university_center/core/widgets/logo_widget.dart';
import 'package:almaali_university_center/logic/cubits/auth/auth_cubit.dart';
import 'package:almaali_university_center/logic/cubits/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late GlobalKey<FormState> formKey;
  late ScrollController scrollController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late FocusNode emailFocus;
  late FocusNode passwordFocus;
  late FocusNode confirmPasswordFocus;

  @override
  void initState() {
    super.initState();
    formKey = GlobalKey<FormState>();
    scrollController = ScrollController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    confirmPasswordFocus = FocusNode();

    // استمع لتغييرات التركيز لتمرير الحقل المركّز فوق الكيبورد
    emailFocus.addListener(() => _ensureFieldVisible(emailFocus));
    passwordFocus.addListener(() => _ensureFieldVisible(passwordFocus));
    confirmPasswordFocus.addListener(
      () => _ensureFieldVisible(confirmPasswordFocus),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }

  /// تمرير الحقل المركّز ليظهر فوق الكيبورد
  void _ensureFieldVisible(FocusNode focusNode) {
    if (focusNode.hasFocus) {
      Future.delayed(const Duration(milliseconds: 300), () {
        Scrollable.ensureVisible(
          focusNode.context!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      // ✅ حل مشكلة الكيبورد: تغيير حجم الواجهة عند ظهور الكيبورد
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        // ✅ الحفاظ على المسافة من الأسفل حتى عند ظهور الكيبورد
        maintainBottomViewPadding: true,
        child: GestureDetector(
          // ✅ إغلاق الكيبورد عند النقر خارج الحقول
          behavior: HitTestBehavior.translucent,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                controller: scrollController,
                // ✅ منع الـ overscroll
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  // ✅ ضمان أن المحتوى يملأ الشاشة على الأقل
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        // ========== زر الرجوع ==========
                        FadeInWidget(
                          duration: const Duration(milliseconds: 400),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: GestureDetector(
                                onTap: () {
                                  context.pushReplacement(AppRoutes.onboarding);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                  child: const Icon(
                                    Icons.arrow_back,
                                    color: AppColors.textLight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ========== الشعار ==========
                        ScaleInWidget(
                          duration: const Duration(milliseconds: 600),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: LogoWidget(size: 120, showText: true),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ========== محتوى النموذج ==========
                        Expanded(
                          child: SlideInWidget(
                            begin: const Offset(0, 0.3),
                            duration: const Duration(milliseconds: 700),
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryBlue,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 32),

                                    // العنوان
                                    const Text(
                                      'تسجيل الدخول',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textLight,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),

                                    const SizedBox(height: 24),

                                    // ========== النموذج ==========
                                    Expanded(
                                      child: SingleChildScrollView(
                                        physics: const ClampingScrollPhysics(),
                                        // ✅ إضافة padding ديناميكي بناءً على ارتفاع الكيبورد
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom:
                                                keyboardHeight > 0
                                                    ? keyboardHeight + 16
                                                    : 0,
                                          ),
                                          child: Form(
                                            key: formKey,
                                            child: Column(
                                              children: [
                                                // ========== حقل البريد الإلكتروني ==========
                                                FadeInWidget(
                                                  delay: const Duration(
                                                    milliseconds: 300,
                                                  ),
                                                  child: TextFormField(
                                                    controller: emailController,
                                                    focusNode: emailFocus,
                                                    keyboardType:
                                                        TextInputType
                                                            .emailAddress,
                                                    textInputAction:
                                                        TextInputAction.next,
                                                    onFieldSubmitted: (_) {
                                                      passwordFocus
                                                          .requestFocus();
                                                    },
                                                    decoration: InputDecoration(
                                                      hintText:
                                                          'البريد الإلكتروني',
                                                      hintStyle:
                                                          const TextStyle(
                                                            color:
                                                                AppColors
                                                                    .textHint,
                                                          ),
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      border: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              12,
                                                            ),
                                                        borderSide:
                                                            BorderSide.none,
                                                      ),
                                                      contentPadding:
                                                          const EdgeInsets.symmetric(
                                                            horizontal: 16,
                                                            vertical: 14,
                                                          ),
                                                      prefixIcon: const Icon(
                                                        Icons.email_outlined,
                                                        color:
                                                            AppColors
                                                                .primaryGold,
                                                      ),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'الرجاء إدخال البريد الإلكتروني';
                                                      }
                                                      if (!value.contains(
                                                        '@',
                                                      )) {
                                                        return 'البريد الإلكتروني غير صحيح';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),

                                                const SizedBox(height: 16),

                                                // ========== حقل كلمة المرور ==========
                                                BlocBuilder<
                                                  AuthCubit,
                                                  AuthState
                                                >(
                                                  builder: (context, state) {
                                                    return FadeInWidget(
                                                      delay: const Duration(
                                                        milliseconds: 400,
                                                      ),
                                                      child: TextFormField(
                                                        controller:
                                                            passwordController,
                                                        focusNode:
                                                            passwordFocus,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        onFieldSubmitted: (_) {
                                                          FocusScope.of(
                                                            context,
                                                          ).unfocus();
                                                        },
                                                        // ✅ إخفاء/إظهار كلمة المرور
                                                        obscureText:
                                                            !state
                                                                .isPasswordVisible,
                                                        decoration: InputDecoration(
                                                          hintText:
                                                              'كلمة المرور',
                                                          hintStyle:
                                                              const TextStyle(
                                                                color:
                                                                    AppColors
                                                                        .textHint,
                                                              ),
                                                          filled: true,
                                                          fillColor:
                                                              Colors.white,
                                                          border: OutlineInputBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  12,
                                                                ),
                                                            borderSide:
                                                                BorderSide.none,
                                                          ),
                                                          contentPadding:
                                                              const EdgeInsets.symmetric(
                                                                horizontal: 16,
                                                                vertical: 14,
                                                              ),
                                                          prefixIcon: const Icon(
                                                            Icons.lock_outlined,
                                                            color:
                                                                AppColors
                                                                    .primaryGold,
                                                          ),
                                                          suffixIcon: IconButton(
                                                            icon: Icon(
                                                              state.isPasswordVisible
                                                                  ? Icons
                                                                      .visibility
                                                                  : Icons
                                                                      .visibility_off,
                                                              color:
                                                                  AppColors
                                                                      .textHint,
                                                            ),
                                                            onPressed:
                                                                () =>
                                                                    context
                                                                        .read<
                                                                          AuthCubit
                                                                        >()
                                                                        .togglePasswordVisibility(),
                                                          ),
                                                        ),
                                                        validator: (value) {
                                                          if (value == null ||
                                                              value.isEmpty) {
                                                            return 'الرجاء إدخال كلمة المرور';
                                                          }
                                                          if (value.length <
                                                              6) {
                                                            return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),

                                                const SizedBox(height: 28),

                                                // ========== زر التسجيل ==========
                                                BlocConsumer<
                                                  AuthCubit,
                                                  AuthState
                                                >(
                                                  listener: (context, state) {
                                                    if (state.successMessage !=
                                                        null) {
                                                      context.go(
                                                        AppRoutes.home,
                                                      );
                                                    }
                                                    if (state.errorMessage !=
                                                        null) {
                                                      ScaffoldMessenger.of(
                                                        context,
                                                      ).showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            state.errorMessage!,
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  },
                                                  builder: (context, state) {
                                                    return FadeInWidget(
                                                      delay: const Duration(
                                                        milliseconds: 600,
                                                      ),
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        height: 56,
                                                        child: ElevatedButton(
                                                          onPressed:
                                                              state.isLoading
                                                                  ? null
                                                                  : () async {
                                                                    FocusScope.of(
                                                                      context,
                                                                    ).unfocus();
                                                                    if (formKey
                                                                        .currentState!
                                                                        .validate()) {
                                                                      final success = await context
                                                                          .read<
                                                                            AuthCubit
                                                                          >()
                                                                          .signIn(
                                                                            emailController.text,
                                                                            passwordController.text,
                                                                          );
                                                                      if (success &&
                                                                          context
                                                                              .mounted) {
                                                                        // UserRole
                                                                        // role =
                                                                        //     await RoleService.getRole();

                                                                        // final defaultRoute =
                                                                        //     RouteGuard.getDefaultRoute(
                                                                        //       role,
                                                                        //     );
                                                                        // context.go(
                                                                        //   defaultRoute,
                                                                        // );

                                                                        context.go(
                                                                          AppRoutes
                                                                              .home,
                                                                        );
                                                                      }
                                                                    }
                                                                  },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                AppColors
                                                                    .primaryGold,
                                                            disabledBackgroundColor:
                                                                AppColors
                                                                    .primaryGold
                                                                    .withOpacity(
                                                                      0.6,
                                                                    ),
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                            ),
                                                          ),
                                                          child:
                                                              state.isLoading
                                                                  ? const SizedBox(
                                                                    height: 24,
                                                                    width: 24,
                                                                    child: CircularProgressIndicator(
                                                                      valueColor: AlwaysStoppedAnimation<
                                                                        Color
                                                                      >(
                                                                        Colors
                                                                            .white,
                                                                      ),
                                                                      strokeWidth:
                                                                          2,
                                                                    ),
                                                                  )
                                                                  : const Text(
                                                                    'تسجيل الدخول',
                                                                    style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),

                                                const SizedBox(height: 16),

                                                // ========== رابط إنشاء حساب ==========
                                                FadeInWidget(
                                                  delay: const Duration(
                                                    milliseconds: 700,
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      GestureDetector(
                                                        onTap:
                                                            () => context.push(
                                                              AppRoutes.signUp,
                                                            ),
                                                        child: const Text(
                                                          'انشاء حساب',
                                                          style: TextStyle(
                                                            color:
                                                                AppColors
                                                                    .primaryGold,
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Text(
                                                        ' ليس لديك حساب بالفعل؟',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .textLight,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(height: 24),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
