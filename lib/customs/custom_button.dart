import 'package:flutter/material.dart';
import 'package:eg_passport_app/theme/my_theme_app.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String textName;

  final Color? backgroundColor;
  final IconData? icon;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.textName,
    this.backgroundColor,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
      child: SizedBox(
        width: double.infinity,
        height: 40,
        child: ElevatedButton(
          onPressed: onPressed ?? () {},

          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor ?? AppColors.primaryRedColor, // default color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.red, width: 0.5),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textName,
                style: MyThemeApp.lightTheme.textTheme.titleLarge,
              ),

              // 🔥 icon optional
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: Colors.white),
              ],
            ],
          ),
        ),
      ),
    );
  }
}