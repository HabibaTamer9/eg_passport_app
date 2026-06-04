import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class CustomDropDown extends StatelessWidget {
  final List<DropdownMenuItem<String>> items;
  final void Function(String?)? onChanged;
  final String hint;
  final IconData? hinticon;
  final String? value;
  final String? Function(String?)? validator;
  const CustomDropDown({
    super.key,
    required this.items,
    this.onChanged,
    required this.hint,
    this.hinticon,
    this.value,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField(
      isExpanded: true,
      dropdownColor: Colors.white,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xffF9FAFB),
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
      value: value,

      items: items,
      onChanged: onChanged,
    );
  }
}