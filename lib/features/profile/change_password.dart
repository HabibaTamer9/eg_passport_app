import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/customs/custom_button.dart';
import 'package:eg_passport_app/features/auth/widgets/background.dart';
import 'package:flutter/material.dart';

import '../../core/Api/api_helper.dart';
import '../../core/Api/endpoint.dart';
import '../../core/customs/custom_textformfield.dart';

class ChangePassword extends StatelessWidget {
  ChangePassword({super.key});
  final currentController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Future<void> changePassword(context) async {

    try {
      var response = await ApiHelper().postAuthAPI("change-password", {
        "currentPassword": currentController.text,
        "newPassword": passwordController.text,
        "confirmPassword": confirmPasswordController.text
      });

      if (response["success"] != true) {
        print(response);
        return;
      }
      Navigator.pop(context);
      return;
    } catch (e) {
      print("errorMessages".tr());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(child: SingleChildScrollView(
        child: Column(
          children: [
            Text('change_password'.tr() , style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(height: 15),
            CustomTextFormField(
              title: 'password'.tr(),
              hint: 'password_hint'.tr(),
              controller: currentController,
              hinticon: Icons.lock,
              isRequired: true,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'password_required'.tr();
                }
                return null;
              },
            ),
            CustomTextFormField(
              title: 'password'.tr(),
              hint: 'password_hint'.tr(),
              controller: passwordController,
              hinticon: Icons.lock,
              isRequired: true,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'password_required'.tr();
                }
                if (value.length < 8) {
                  return 'password_error_1'.tr();
                }
                if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return 'password_error_2'.tr();
                }
                if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return 'password_error_3'.tr();
                }
                if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
                  return 'password_error_4'.tr();
                }
                return null;
              },
            ),
        
            const SizedBox(height: 2),
        
            CustomTextFormField(
              title: 'confirm_password'.tr(),
              hint: 'confirm_password_hint'.tr(),
              controller: confirmPasswordController,
              hinticon: Icons.lock,
              isRequired: true,
              obscureText: true,
              keyboardType: TextInputType.visiblePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'confirm_password_required'.tr();
                }
                if (value != passwordController.text) {
                  return 'confirm_password_error'.tr();
                }
                return null;
              },
            ),
            const SizedBox(height: 3),
            CustomButton(textName: 'change_password'.tr(),
            onPressed: (){
              changePassword(context);
            },
            )
          ],
        ),
      )),
    );
  }
}
