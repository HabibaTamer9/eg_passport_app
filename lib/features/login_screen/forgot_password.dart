import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/customs/custom_button.dart';
import 'package:eg_passport_app/core/customs/custom_textformfield.dart';
import 'package:eg_passport_app/features/login_screen/widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final controller = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final keyboardType = TextInputType.emailAddress;
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: pageController,
          children: [
            Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextFormField(
                    title: 'email'.tr(),
                    hint: 'email_hint'.tr(),
                    controller: controller,
                    keyboardType: keyboardType,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'email_required'.tr();
                      }
                      return null;
                    },
                  ),
                  CustomButton(
                    textName: "Send code",
                    onPressed: () {
                      // if (formKey.currentState!.validate()) {
                        pageController.nextPage(
                          duration: Duration(seconds: 1),
                          curve: Curves.easeIn,
                        );
                      // }
                    },
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Enter the code sent to your email", style: Theme.of(context).textTheme.titleMedium),
                SizedBox(height: 20),
                Container(
                  child: Pinput(
                    length: 6,
                    onCompleted: (pin) {
                      print(pin);
                    },
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  textName: "Confirm",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    pageController.previousPage(
                      duration: Duration(seconds: 1),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Text("Resend code"),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                ),
                SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
