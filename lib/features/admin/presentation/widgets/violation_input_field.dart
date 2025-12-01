import 'package:flutter/material.dart';
import 'package:almaali_university_center/core/constants/app_colors.dart';

/// Input field styled for violation forms (white text on blue gradient)
class ViolationInputField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final int maxLines;
  final bool readOnly;
  final String? initialValue;
  final ValueChanged<String>? onChanged;

  const ViolationInputField({
    super.key,
    required this.label,
    this.controller,
    this.maxLines = 1,
    this.readOnly = false,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: AppColors.textLight,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 8),
        controller != null
            ? TextField(
              controller: controller,
              readOnly: readOnly,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.textLight, fontSize: 16),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.textLight,
                    width: 1.5,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.textLight,
                    width: 1.5,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textLight, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            )
            : TextFormField(
              initialValue: initialValue,
              readOnly: readOnly,
              textAlign: TextAlign.right,
              maxLines: maxLines,
              onChanged: onChanged,
              style: const TextStyle(color: AppColors.textLight, fontSize: 16),
              decoration: const InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.textLight,
                    width: 1.5,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.textLight,
                    width: 1.5,
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.textLight, width: 2),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
            ),
      ],
    );
  }
}
