import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/customs/custom_button.dart';
import 'package:eg_passport_app/core/customs/custom_textformfield.dart';
import 'package:eg_passport_app/features/auth/login_screen/login_screen.dart';
import '../../../core/Api/api_helper.dart';
import '../../../core/Api/endpoint.dart';
import 'widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final controller = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final keyboardType = TextInputType.emailAddress;

  final pageController = PageController();

  String messageLanguage = ApiHelper.messageLanguage;
  String code = "";
  String phoneNumber = "";
  @override
  void dispose() {
    controller.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  String _apiMessage(Map<String, dynamic> response) {
    final errors = response["errors"];
    if (errors.isNotEmpty) {
      return errors.first[messageLanguage] ?? "حدث خطأ في البيانات";
    }

    return response[messageLanguage] ?? "حدث خطأ غير متوقع";
  }

  Future<void> _showApiDialog({
    required String title,
    required String message,
  }) async {
    if (!mounted) return;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CustomButton(textName: "OK", onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  Future<void> forgotPassword() async {
    try {
      var response = await ApiHelper().postAuthAPI(Endpoint.forgotPassword, {
        "emailOrMobile": controller.text.trim(),
      });

      if (response["success"] != true) {
        await _showApiDialog(title: 'error'.tr(), message: _apiMessage(response));
        return;
      }

      code = response["data"]["developmentCode"].toString();
      phoneNumber = response["data"]["mobileNumber"].toString();
      pageController.nextPage(
        duration: Duration(seconds: 1),
        curve: Curves.easeIn,
      );
      return;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              'errorMessages'.tr(),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            CustomButton(
              textName: "OK",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }
  Future<void> resetPassword() async {
    try {
      var response = await ApiHelper().postAuthAPI(Endpoint.resetPassword, {
        "mobileNumber": "string",
        "code": code,
        "newPassword": passwordController.text,
        "confirmPassword": confirmPasswordController.text
      });

      if (response["success"] != true) {
        await _showApiDialog(title: 'error'.tr(), message: _apiMessage(response));
        return;
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      return;
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              'errorMessages'.tr(),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            CustomButton(
              textName: "OK",
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }
  }

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
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Enter the code sent to your email or phone number"),
                  const SizedBox(height: 15),
                  Pinput(
                    length: 6,
                    onCompleted: (pin) {
                      forgotPassword();

                    },
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Text("New Password"),
                  const SizedBox(height: 15),
                  CustomTextFormField(
                    title: 'كلمة المرور',
                    hint: 'ادخل كلمة المرور',
                    controller: passwordController,
                    hinticon: Icons.lock,
                    isRequired: true,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return " من فضلك ادخل كلمة المرور";
                      }
                      if (value.length < 8) {
                        return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
                      }
                      if (!RegExp(r'[A-Z]').hasMatch(value)) {
                        return "كلمة المرور يجب أن تحتوي على حرف كبير";
                      }
                      if (!RegExp(r'[0-9]').hasMatch(value)) {
                        return "كلمة المرور يجب أن تحتوي على رقم";
                      }
                      if (!RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
                        return "كلمة المرور يجب أن تحتوي على رمز خاص مثل @";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 2),

                  CustomTextFormField(
                    title: 'تاكيد كلمة المرور',
                    hint: 'اعد ادخال كلمة المرور',
                    controller: confirmPasswordController,
                    hinticon: Icons.lock,
                    isRequired: true,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return " من فضلك ادخل كلمة المرور";
                      }
                      if (value != passwordController.text) {
                        return "كلمة المرور غير متطابقة";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 3),

                  CustomButton(textName: "Reset Password", onPressed: () {
                    resetPassword();
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
