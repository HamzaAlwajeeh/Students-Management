import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AdminAppBar({
    super.key,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading:
          showBackButton
              ? Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_forward,
                      color: AppColors.textLight,
                    ),
                    onPressed:
                        onBackPressed ?? () => Navigator.of(context).pop(),
                  ),
                ),
              )
              : null,
      actions: [
        if (!showBackButton)
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8),
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                color: AppColors.primaryGold,
                size: 32,
              ),
              onPressed: () {
                // Menu action
              },
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
