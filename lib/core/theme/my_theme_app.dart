
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

class MyThemeApp {
  static ThemeData lightTheme = ThemeData(

      //fontFamily: 'Cairo',
    textTheme: TextTheme(
      //textLarge
      titleLarge: TextStyle(
          fontSize: 18.sp,
        color: AppColors.blackColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w700,

      ),
      //titleMeduim
      titleMedium: TextStyle(
        fontSize: 15.sp,
        color: AppColors.greyColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        // fontWeight: FontWeight.bold,
        fontSize: 16.sp,
        color: AppColors.blackColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w700,

      ),
      bodyMedium: TextStyle(
        // fontWeight: FontWeight.bold,
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
      /*
      //textMeduim
      bodyMedium: TextStyle(
       // fontWeight: FontWeight.bold,
        fontSize: 20,
        color: AppColors.whiteColor
      ),
      //textSmall



      //titleSmall
      titleSmall: TextStyle(
      )

*/

    )


  );


}