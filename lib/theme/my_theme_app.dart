import 'package:eg_passport_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyThemeApp {
  static ThemeData lightTheme = ThemeData(
      //fontFamily: 'Cairo',
    textTheme: TextTheme(
      //textLarge
      titleLarge: TextStyle(
          fontSize: 22,
        color: AppColors.blackColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w700,

      ),
      //titleMeduim
      titleMedium: TextStyle(
        fontSize: 15,
        color: AppColors.greyColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(
        // fontWeight: FontWeight.bold,
        fontSize: 16,
        color: AppColors.blackColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w700,

      ),
      bodyMedium: TextStyle(
        // fontWeight: FontWeight.bold,
          fontSize: 12,
          color: AppColors.blackColor,
        fontFamily: "Cairo",
        fontWeight: FontWeight.w700,

      ),
      bodySmall: TextStyle(
          fontSize: 12,
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