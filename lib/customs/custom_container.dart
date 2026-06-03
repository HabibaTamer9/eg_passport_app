import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons, Theme;

import '../theme/app_colors.dart';

class CustomContainer extends StatelessWidget {
  final String title;
  final IconData icon;
  CustomContainer({required this.title,required this.icon});



  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40,
      margin: EdgeInsets.only(left: 15,right: 15,top: 5),
      decoration: BoxDecoration(
        color: AppColors.lightGreyColor,
        borderRadius: BorderRadius.circular(12)),
      child:Padding(padding: EdgeInsetsGeometry.symmetric(horizontal: 12),
      child:Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        textDirection: TextDirection.ltr,
        children: [
           Icon(Icons.arrow_forward_ios,size: 20,color:AppColors.blackColor),
          Spacer(),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(width: 8),

          Icon(
            icon,
            size: 20,
            color: AppColors.blackColor,
          ),

        ],

      ))
    );
  }
}
