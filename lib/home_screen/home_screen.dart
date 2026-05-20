import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0.sp),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/egy.png"),
              ),
              SizedBox(width: 10.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("${'hello'.tr()} 👋", style: TextStyle(
                  color: Color(0xff44474E),
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                )), Text("احمد محمد علي", style: TextStyle(
                  color: Color(0xff44474E),
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ))],
              ),
            ],
          ),
          Container(
            width: 360.w,
            height: 302.h,
            margin: EdgeInsets.symmetric(vertical: 15.sp),
            padding: EdgeInsets.all(20.sp),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24.r),
              gradient: LinearGradient(
                colors: [Color(0xff1E293B), Color(0xff0F172A)],
                begin: Alignment.bottomRight,
                end: Alignment.topLeft,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            color: Color(0xffC09300).withOpacity(0.5),
                          ),
                          width: 30.w,
                          height: 30.h,
                          child: SvgPicture.asset("assets/SVG.png"),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          children: [
                            Text("جواز السفر الرقمي", style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            )),
                            Text("Digital Passport", style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w400,
                            )),
                          ],
                        )
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15.r),
                        color: Color(0xffC09300),
                      ),
                      width: 88.w,
                      height: 30.h,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.timer_outlined, color: Colors.white, size: 15.sp),
                          SizedBox(width: 5.w),
                          Text("قيد المراجعه", style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w500,
                          ))
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
