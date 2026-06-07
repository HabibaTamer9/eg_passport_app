import 'package:eg_passport_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterItem extends StatelessWidget {
  final bool isSelected;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const FilterItem({
    super.key,
    required this.isSelected,
    required this.title,
    required this.icon, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80.0.h,
        width: 80.0.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryRedColor
                : AppColors.lightGreyColor,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24.sp,
                color: isSelected
                    ? AppColors.primaryRedColor
                    : AppColors.greyColor,
              ),
      
              SizedBox(height: 8.0.h),
      
              Text(
                title,
                style: isSelected
                    ? Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: AppColors.primaryRedColor,
                      )
                    : Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
