import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/models/passport_model.dart';
import 'package:eg_passport_app/core/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/data/app_data.dart';
import '../../../core/theme/app_colors.dart';

class PersonalInfo extends StatelessWidget {
  PersonalInfo({super.key});
  final UserModel user = AppData.user;
  final PassportModel passport = AppData.passport;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _customRow(context, 'full_name'.tr(), user.name , Icons.person),
        _customRow(context, 'user_email'.tr(), user.email, Icons.email),
        _customRow(context, 'phone_number'.tr(), user.phoneNumber, Icons.phone),
        _customRow(context, 'national_id'.tr() , user.nationalID!, Icons.credit_card),
        _customRow(context, 'address'.tr(), user.address!, Icons.location_on),
        _customRow(context, 'gender'.tr(), user.gender!, Icons.male),
        _customRow(context, 'dob'.tr(), user.dateOfBirth!, Icons.calendar_today),
        _customRow(context, 'nationality'.tr(), user.nationality!, Icons.flag),
        if (passport.passportNumber != null)
          _customRow(context, 'passport_number'.tr(), passport.passportNumber!, Icons.credit_card),
      ],
    );
  }

  Widget _customRow(BuildContext context, String title, String data , IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.blackColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.greyColor,
            fontSize: 14.sp,
          ),
        ),
        Spacer(),
        Text(
          data,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontSize: 14.sp),
        ),
      ],
    );
  }
}
