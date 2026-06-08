import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/data/app_data.dart';
import '../../core/theme/app_colors.dart';

class DigitalPassportScreen extends StatefulWidget {
  DigitalPassportScreen({super.key});

  @override
  State<DigitalPassportScreen> createState() => _DigitalPassportScreenState();
}

class _DigitalPassportScreenState extends State<DigitalPassportScreen> {
  final UserModel user = AppData.user;

  bool isVerified = false;

  @override
  Widget build(BuildContext context) {
    if (!AppData.passport.success) {
      return Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.contact_mail_outlined,
                size: 100.sp,
                color: AppColors.primaryRedColor,
              ),
              Text(
                AppData.isArabic
                    ? AppData.passport.messageAr
                    : AppData.passport.messageEn,
                style: TextStyle(
                  color: AppColors.primaryRedColor,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(
              'passport'.tr(),
              style: TextStyle(
                color: Color(0xff44474E),
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'passport_desc'.tr(),
              style: TextStyle(
                color: Color(0xff44474E),
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
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
                            image: NetworkImage(
                              "https://cdn.pixabay.com/photo/2023/02/18/11/00/icon-7797704_640.png",
                            ),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppData.user.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
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
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildProfileInfoItem(
                                context,
                                label: 'nationality'.tr(),
                                value: user.nationality!,
                              ),
                              SizedBox(width: 20.w),
                              _buildProfileInfoItem(
                                context,
                                label: 'dob'.tr(),
                                value: user.dateOfBirth!,
                              ),
                            ],
                          ),
                          SizedBox(height: 15.h),
                          _buildProfileInfoItem(
                            context,
                            label: 'passport_number'.tr(),
                            value: user.appNumber!,
                          ),
                        ],
                      ),
                      Container(
                        width: 120.w,
                        height: 110.h,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildProfileInfoItem(
                        context,
                        label: 'release_date'.tr(),
                        value: user.dateOfBirth!,
                      ),
                      _buildProfileInfoItem(
                        context,
                        label: 'expire_date'.tr(),
                        value: user.dateOfBirth!,
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
                        padding: EdgeInsets.all(2),
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
            SizedBox(height: 15.h),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.lightGreyColor,
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'verification_level'.tr(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.darkBlueColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isVerified ? Icons.check_circle : Icons.error_outline,
                        color: isVerified
                            ? AppColors.greenColor
                            : Colors.orange,
                        size: 30,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isVerified ? 'verified'.tr() : 'not_verified'.tr(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isVerified
                              ? AppColors.greenColor
                              : Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isVerified
                        ? 'verified_message'.tr()
                        : 'not_verified_message'.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.darkBlueColor,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    isVerified
                        ? 'digital_passport_message'.tr()
                        : 'digital_passport_message_not'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.greyColor,
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

  Widget _buildProfileInfoItem(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.greyColor,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: AppColors.whiteColor),
        ),
      ],
    );
  }
}
