import 'package:eg_passport_app/theme/app_colors.dart' show AppColors;
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.items,
    this.onChanged,
    required this.hint,
    this.hinticon,
    this.value,
    this.validator,
  });

  final List<DropdownMenuItem<String>> items;
  final void Function(String?)? onChanged;
  final String hint;
  final IconData? hinticon;
  final String? value;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF9FAFB),
        hintText: hint,
        hintStyle: Theme.of(context).textTheme.bodySmall,

        prefixIcon: hinticon != null
            ? Icon(hinticon, color: AppColors.greyColor, size: 22)
            : null,

        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),

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
      validator: validator,
      initialValue: value,
      items: items,
      onChanged: onChanged,
    );
  }
}
