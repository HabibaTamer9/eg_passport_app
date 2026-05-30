import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String textName;
  final Color? textColor;

  final Color? backgroundColor;
  final IconData? icon;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.textName,
    this.textColor,
    this.backgroundColor =AppColors.primaryRedColor,
    this.icon,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    
    return Padding(
      padding: const EdgeInsets.only(left: 5,right: 5,top: 5),
      child: SizedBox(
        width: double.infinity,
        height: 40.h,
        child: ElevatedButton(
          onPressed: onPressed ?? () {},

          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor, // default color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: AppColors.primaryRedColor, width: 1),
            ),
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textName,
                style: Theme.of(context).textTheme.titleLarge!.copyWith(color: textColor ??Colors.white),
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