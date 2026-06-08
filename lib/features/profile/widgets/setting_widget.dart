import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/Api/api_helper.dart';
import 'package:eg_passport_app/core/customs/custom_button.dart';
import 'package:eg_passport_app/core/data/app_data.dart';
import 'package:eg_passport_app/features/auth/login_screen/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../change_password.dart';

class SettingWidget extends StatefulWidget {
  const SettingWidget({super.key});

  @override
  State<SettingWidget> createState() => _SettingWidgetState();
}

class _SettingWidgetState extends State<SettingWidget> {
  int? expandedIndex;

  Future<void> logout(context) async {

    try {
      var response = await ApiHelper().postAuthAPI("logout", {
        "refreshToken": ApiHelper.refreshToken
      });

      if (response["success"] != true) {
        print(response);
        return;
      }
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen()), (route) => false);
      return;
    } catch (e) {
      print("errorMessages".tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _customRow(
          context,
          index: 0,
          title: 'change_password'.tr(),
          icon: Icons.lock,
          onPressed: () {
            Navigator.push(context , MaterialPageRoute(builder: (context) => ChangePassword()));
          },
        ),
        _customRow(
          context,
          index: 1,
          title: 'print'.tr(),
          icon: Icons.fingerprint,
        ),
        _customRow(
          context,
          index: 2,
          title: 'language'.tr(),
          icon: Icons.language,
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  context.setLocale(const Locale('en'));
                  ApiHelper.messageLanguage = 'messageEn';
                  AppData.isArabic = false;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Text(
                      "English",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
                    ),
                    const Spacer(),
                    if (!AppData.isArabic)
                      Icon(
                        Icons.check,
                        size: 20.sp,
                        color: AppColors.greenColor,
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  context.setLocale(const Locale('ar'));
                  ApiHelper.messageLanguage = 'messageAr';
                  AppData.isArabic = true;
                  setState(() {});
                },
                child: Row(
                  children: [
                    Text(
                      "العربية",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
                    ),
                    const Spacer(),
                    if (AppData.isArabic)
                      Icon(
                        Icons.check,
                        size: 20.sp,
                        color: AppColors.greenColor,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        _customRow(
          context,
          index: 3,
          title: 'logout'.tr(),
          icon: Icons.logout,
          child: CustomButton(textName: "Logout", onPressed: () {
            logout(context);
          })
        ),
      ],
    );
  }

  Widget _customRow(
      BuildContext context, {
        required int index,
        required String title,
        required IconData icon,
        Widget? child,
        Function()? onPressed,
      }) {
    final bool isClicked = expandedIndex == index;

    return Column(
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.blackColor),
            const SizedBox(width: 8),
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
            ),
            const Spacer(),
              IconButton(
                icon: Icon(
                  isClicked
                      ? Icons.keyboard_arrow_down
                      : Icons.arrow_forward_ios,
                  size: 15.sp,
                  color: AppColors.blackColor,
                ),
                onPressed: () {
                  if(onPressed != null) onPressed();
                  setState(() {
                    expandedIndex =
                    expandedIndex == index ? null : index;
                  });
                },
              ),
          ],
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          child: isClicked
              ? Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 8,
            ),
            child: child,
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
