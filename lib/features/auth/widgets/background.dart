import 'package:eg_passport_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Background extends StatelessWidget {
  Background({super.key, required this.child, this.currentIndex = 0});

  final Widget child;
  final int currentIndex;

  final List<String> title = [
    "انشاء حساب",
    "البيانات الشخصيه",
    "رفع المستندات",
    "التحقق",
  ];

  Color getColor(int index) {
    if (index == currentIndex) {
      return AppColors.primaryRedColor;
    }
    if (index < currentIndex) {
      return Colors.green;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.33,
          child: Image.asset('assets/images/Group 1.png', fit: BoxFit.fill),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.29,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                if (currentIndex != 0)
                  SizedBox(
                    height: 60.h,
                    width: double.infinity,
                    child: Center(
                      child: ListView.builder(
                        itemCount: 4,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, i) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: 30.h,
                                    width: 30.w,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: getColor(i),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "${i + 1}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    title[i],
                                    style: TextStyle(
                                      color: getColor(i),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10.sp,
                                    ),
                                  ),
                                ],
                              ),
                              if (i != 3)
                                Container(
                                  width: 30.w,
                                  height: 2,
                                  color: getColor(i),
                                  margin: EdgeInsets.only(
                                    bottom: 30.h,
                                    left: 5.w,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                Expanded(
                    child: child),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
