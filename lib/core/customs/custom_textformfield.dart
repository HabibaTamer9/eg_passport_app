import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final String title;
  final bool isRequired;
  final String hint;
  final IconData? hinticon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? suffixIcon;
  final int? maxLength;
  final VoidCallback? onTap;

  const CustomTextFormField({
    super.key,
    required this.title,
    this.isRequired = false,
    required this.hint,
    this.hinticon,
    required this.controller,
    this.validator,
    this.obscureText = false,
    required this.keyboardType,
    this.suffixIcon,
    this.maxLength,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 2,
        bottom: 8,
        left: 5,
        right: 5,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontStyle: Theme.of(context).textTheme.bodyMedium?.fontStyle,

                ),
              ),
              const SizedBox(width: 8),
              if (isRequired)
                const Icon(Icons.star, color: Colors.red, size: 10),
            ],
          ),

          const SizedBox(height: 8),

          // TextField
          TextFormField(
            controller: controller,
            validator: validator,
            obscureText: obscureText,
            keyboardType: keyboardType,

            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,
            maxLength: maxLength,
            onTap: onTap,

            decoration: InputDecoration(

              suffixIcon: suffixIcon != null
                  ? Icon(
                suffixIcon,
                color: AppColors.greyColor,
                size: 22,
              )
                  : null,
              hintText: hint,
              hintStyle:Theme.of(context).textTheme.bodySmall,

              prefixIcon: hinticon != null
                  ? Icon(
                hinticon,
                color: AppColors.greyColor,
                size: 22,
              )
                  : null,

              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 8,
              ),

              //  default state
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 1.5,
                  color: AppColors.lightGreyColor,
                ),
              ),

              //  when focused
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 1.5,
                  color: AppColors.lightGreyColor,
                ),
              ),

              //  when error
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 1.5,
                  color: AppColors.primaryRedColor,
                ),
              ),

              //  when error + focus
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 1.5,
                  color: AppColors.lightGreyColor,
                ),
              ),

              // fallback border
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  width: 2,
                  color: AppColors.primaryRedColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}