import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/Api/api_helper.dart';
import 'package:eg_passport_app/core/Api/endpoint.dart';
import 'package:eg_passport_app/core/data/app_data.dart';
import '../../../core/models/user_model.dart';
import '../login_screen/widgets/background.dart';
import '../personal_info_screen/personal_info_ui.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/customs/custom_button.dart';
import '../../../core/customs/custom_textformfield.dart';
import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../login_screen/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = "registerScreen";

  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isChecked = false;
  String messageLanguage = ApiHelper.messageLanguage;
  String uId = "";

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
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

  void _saveAuthTokens(Map<String, dynamic> response) {
    final data = response["data"];
    if (data is Map) {
      ApiHelper.accessToken = data["accessToken"]?.toString();
      ApiHelper.refreshToken = data["refreshToken"]?.toString();
    }
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

  void getUser(var response) {
    AppData.user = UserModel(
      uID: response["data"]["userId"],
      name: response["data"]["fullName"],
      email: response["data"]["email"],
      phoneNumber: response["data"]["mobileNumber"],
    );
  }

  void register() async {
    try {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );
      var response = await ApiHelper().postAuthAPI(Endpoint.register, {
        "fullName": nameController.text.trim(),
        "email": emailController.text.trim(),
        "mobileNumber": phoneController.text.trim(),
        "password": passwordController.text.trim(),
        "confirmPassword": confirmPasswordController.text.trim(),
        "termsAccepted": isChecked,
      });
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();

      if (response["success"] != true) {
        await _showApiDialog(title: 'error'.tr(), message: _apiMessage(response));
        return;
      }

      _saveAuthTokens(response);
      await _showApiDialog(
        title: "تم",
        message: response[messageLanguage] ?? "تم إنشاء الحساب بنجاح",
      );
      uId = response["data"]["userId"];
      getUser(response);

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PersonalInfoScreen()),
      );
      return;
    } catch (e) {
      print("e:  $e");
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Center(
            child: Text(
              'errorMessage'.tr(),
              textAlign: TextAlign.center,
            ),
          ),
          actions: [
            CustomButton(
              textName: "OK",
              onPressed: () {
                Navigator.pop(context);
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),

          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),

                // title
                Text(
                  "انشاء حساب جديد",
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 5),

                // subtitle
                Text(
                  "انضم الي منصة الهوية الرقمية الذكية",
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 12),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        title: 'الاسم الكامل',
                        hint: 'ادخل اسمك رباعي',
                        isRequired: true,
                        controller: nameController,
                        hinticon: Icons.person_2_outlined,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return " من فضلك ادخل الاسم";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 2),

                      CustomTextFormField(
                        title: 'البريد الإلكتروني',
                        hint: 'ادخل البريد الإلكتروني',
                        isRequired: true,
                        controller: emailController,
                        hinticon: Icons.email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "ادخل البريد الإلكتروني";
                          }
                          if (!value.contains("@")) {
                            return "البريد الإلكتروني غير صحيح";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 2),

                      CustomTextFormField(
                        title: 'رقم الهاتف المحمول',
                        hint: 'ادخل رقم الهاتف المحمول',
                        isRequired: true,
                        controller: phoneController,
                        hinticon: Icons.phone,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return " من فضلك ادخل رقم الهاتف";
                          }
                          if (value.length != 11) {
                            return "لرقم الهاتف يجب أن يكون 11 رقم";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 2),

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

                      // checkbox
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: AppColors.greyColor,
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),

                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'أوافق على ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.blackColor,
                                          ),
                                    ),

                                    TextSpan(
                                      text: "الشروط والاحكام وسياسه الخصوصية",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            color: AppColors.primaryRedColor,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),
                    ],
                  ),
                ),

                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: CustomButton(
                    textName: "انشاء حساب",
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (!isChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("يجب الموافقة على الشروط والأحكام"),
                            ),
                          );
                          return;
                        }
                        register();
                      }
                    },
                    backgroundColor: AppColors.primaryRedColor,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.lightGreyColor,
                        thickness: 1,
                      ),
                    ),
                    Text(
                      " لديك حساب بالفعل ؟  ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.lightGreyColor,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: CustomButton(
                    textName: "تسجيل دخول",
                    textColor: AppColors.blackColor,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                      );
                    },
                    backgroundColor: AppColors.whiteColor,
                  ),
                ),

                const SizedBox(height: 10),
                SizedBox(
                  height: 60.h,
                  width: 360.w,
                  child: Image.asset(
                    "assets/images/back.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
