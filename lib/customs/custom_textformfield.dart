import 'package:eg_passport_app/theme/app_colors.dart' show AppColors;
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final String title;
  final bool isRequired;
  final String hint;
  final IconData? hinticon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
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
    this.maxLength,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return  Column(
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
           maxLength: maxLength,
          onTap: onTap,
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.start,

            decoration: InputDecoration(
              filled: true,
            fillColor: Color(0xffF9FAFB),
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
     
    );
  }
}
