import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_assets.dart';
import 'package:almaali_university_center/core/constants/app_strings.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';

class LogoWidget extends StatelessWidget {
  final double size;
  final bool showText;

  const LogoWidget({super.key, this.size = 200, this.showText = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          AppAssets.logo,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            AppStrings.appName,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryBlue,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            AppStrings.appNameEnglish,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
              color: AppColors.primaryGold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
