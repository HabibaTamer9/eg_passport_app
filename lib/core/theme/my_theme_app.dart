
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class MyThemeApp {
  static ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.whiteColor,
      cardColor: AppColors.whiteColor,
    textTheme: TextTheme(
      titleLarge: TextStyle(
          fontSize: 18.sp,
        color: AppColors.lightTextColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontSize: 15.sp,
        color: AppColors.greyColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontSize: 16.sp,
        color: AppColors.blackColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w700,

      ),
      bodyMedium: TextStyle(
          fontSize: 14.sp,
          color: AppColors.blackColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w700,

      ),
      bodySmall: TextStyle(
          fontSize: 12.sp,
          color: AppColors.greyColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w400,
      ),
    )
  );
}