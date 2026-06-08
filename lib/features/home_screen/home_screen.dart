import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/data/app_data.dart';
import 'package:eg_passport_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  int currentIndex = 1;

  List<String> state = [
    'request',
    'under_review',
    'approved',
    'request_done',
  ];

  Color getColor(int index) {
    currentIndex = getState();
    if(currentIndex == -1){
      return AppColors.primaryRedColor;
    }
    if (index == currentIndex) {
      return Color(0xffC09300);
    }
    if (index < currentIndex) {
      return Color(0xff16A34A);
    }
    return Colors.grey;
  }



  int getState(){
    var state = AppData.user.state;
    if (state == "PendingReview"){
      return 1;
    }
    if (state == "Approved"){
      return 2;
    }
    if (state == "Rejected"){
      return -1;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    print(AppData.user.state);
    if(currentIndex == -1){
      return Scaffold(
        body: Column(
          children: [
            Icon(Icons.error_outline , color: AppColors.primaryRedColor , size: 50.sp,),
            SizedBox(height: 10.h),
            Text(
              'error'.tr(),
              style: TextStyle(
                color: AppColors.primaryRedColor,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              AppData.user.rejectReason!,
              style: TextStyle(
                color: AppColors.greyColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.0.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage("https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png"),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${'hello'.tr()} 👋",
                      style: TextStyle(
                        color: Color(0xff44474E),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      AppData.user.name,
                      style: TextStyle(
                        color: Color(0xff44474E),
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              width: 360.w,
              margin: EdgeInsets.symmetric(vertical: 15.sp),
              padding: EdgeInsets.all(15.sp),
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
                            padding: EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              color: Color(0xffC09300).withOpacity(0.3),
                            ),
                            width: 30.w,
                            height: 30.h,
                            child: Image.asset("assets/images/SVG.png"),
                          ),
                          SizedBox(width: 8.w),

                          Column(
                            children: [
                              Text(
                                "جواز السفر الرقمي",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "Digital Passport",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.r),
                          color: Color(0xffC09300),
                        ),
                        padding: EdgeInsets.all(5),
                        height: 30.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              color: Colors.white,
                              size: 15.sp,
                            ),
                            SizedBox(width: 5.w),
                            Text(
                              'under_review'.tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 100.w,
                        height: 130.h,
                        decoration: BoxDecoration(
                          color: AppColors.lightGreyColor,
                          border: Border.all(color: Color(0xff44474E)),
                          borderRadius: BorderRadius.circular(12.r),
                          image: DecorationImage(
                            image: NetworkImage("https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 120.w,
                            child: Text(
                              AppData.user.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            "مواطن مصري",
                            style: TextStyle(
                              color: AppColors.lightGreyColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "Egyptian citizen",
                            style: TextStyle(
                              color: AppColors.lightGreyColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            'app_number'.tr(),
                            style: TextStyle(
                              color: AppColors.lightGreyColor,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(
                            width: 120.w,
                            child: Text(
                              AppData.user.appNumber!,
                              style: TextStyle(
                                color: Color(0xffC09300),
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 65.w,
                        height: 70.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          image: DecorationImage(
                            image: AssetImage("assets/images/qr.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Divider(thickness: 1, color: AppColors.greyColor),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${'expire'.tr()} 2:25",
                        style: TextStyle(
                          color: AppColors.greyColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white30,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.refresh, color: Colors.white),
                            Text(
                              'refresh'.tr(),
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsetsGeometry.symmetric(
                vertical: 10.h,
                horizontal: 5.w,
              ),
              padding: EdgeInsetsGeometry.only(top: 10.h),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGreyColor,
                    blurRadius: 10,
                    blurStyle: BlurStyle.outer,
                    spreadRadius: 1,
                  ),
                ],
              ),
              width: 360.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'request_state'.tr(),
                    style: TextStyle(
                      color: Color(0xff44474E),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.all(8.sp),
                                  width: 25.w,
                                  height: 25.h,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: getColor(index),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: AppColors.whiteColor,
                                    size: 15.sp,
                                  ),
                                ),
                                Text(
                                  state[index].tr(),
                                  style: TextStyle(
                                    color: getColor(index),
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            if (index != 3)
                              Container(
                                width: 28.w,
                                height: 2,
                                color: getColor(index),
                                margin: EdgeInsets.only(
                                  bottom: 55.h,
                                  left: 5.w,
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            Text(
              'fast_procedures'.tr(),
              style: TextStyle(
                color: Color(0xff002147),
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.qr_code, size: 25.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      "QR",
                      style: TextStyle(
                        color: Color(0xff002147),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.insert_drive_file_outlined,
                        size: 25.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'details'.tr(),
                      style: TextStyle(
                        color: Color(0xff002147),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.download, size: 25.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'download_pdf'.tr(),
                      style: TextStyle(
                        color: Color(0xff002147),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.help, size: 25.sp),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'help'.tr(),
                      style: TextStyle(
                        color: Color(0xff002147),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
