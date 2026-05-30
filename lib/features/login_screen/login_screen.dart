import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/Api/api_helper.dart';
import 'package:eg_passport_app/core/Api/endpoint.dart';
import 'package:eg_passport_app/features/login_screen/widgets/background.dart';
import 'package:eg_passport_app/features/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/customs/custom_button.dart';
import '../../core/customs/custom_textformfield.dart';
import '../register/register_screen.dart';
import 'forgot_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isRemember = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> login()async {
    try {
      var response = await ApiHelper().postAuthAPI(Endpoint.login, {
        "emailOrMobile": emailController.text,
        "password": passwordController.text
      });
      String message = "";
      print(response);
      if (!response["success"]) {
        var errors = response["errors"];
        if (errors.isNotEmpty) {
          message = errors[0]["messageAr"];
        } else {
          message = response["messageAr"];
        }
        showDialog(context: context, builder: (context) =>
            AlertDialog(
              title: Text("خطأ"),
              content: Text(message),
              actions: [
                CustomButton(textName: "OK", onPressed: () {
                  Navigator.pop(context);
                },)
              ],
            ));
      } else {
        showDialog(context: context, builder: (context) =>
            AlertDialog(
              title: Text("تم"),
              content: Text("${response}"),
              actions: [
                CustomButton(textName: "OK", onPressed: () {
                  Navigator.pop(context);
                },)
              ],
            ));
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MainScreen()));

      }
    }catch (e){
      showDialog(context: context, builder: (context) =>
          AlertDialog(
            title: Center(child: Text("حدث خطأ ما من فضلك حاول مره اخرى لاحقا",textAlign: TextAlign.center,)),
            actions: [
              CustomButton(textName: "OK", onPressed: () {
                Navigator.pop(context);
              },)
            ],
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Background(
        child:  SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'login'.tr(),
                    style: TextStyle(
                      color: Color(0xff111827),
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'welcome_back'.tr(),
                    style: TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomTextFormField(
                    hinticon: Icons.person,
                    title: 'email'.tr(),
                    hint: 'email_hint'.tr(),
                    controller: emailController,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'email_required'.tr();
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  CustomTextFormField(
                    hinticon: Icons.lock,
                    title: 'password'.tr(),
                    hint: 'password_hint'.tr(),
                    controller: passwordController,
                    obscureText: true,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'password_required'.tr();
                      }
                      return null;
                    },
                    suffixIcon: Icons.visibility,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: isRemember,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            side: BorderSide(
                              color: Color(0xff6B7280),
                              width: 2.0,
                            ),
                            onChanged: (val) {
                              setState(() {
                                isRemember = val!;
                              });
                            },
                            checkColor: Colors.white,
                            activeColor: Color(0xffB21A1A),
                          ),
                          Text(
                            'remember_me'.tr(),
                            style: TextStyle(
                              color: Color(0xff6B7280),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPassword(),
                            ),
                          );
                        },
                        child: Text(
                        'forget_password'.tr(),
                        style: TextStyle(
                          color: Color(0xffB21A1A),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  CustomButton(
                    textName: 'login'.tr(),
                    onPressed: () async{
                     if (_formKey.currentState!.validate()) {
                      await login();
                     }
                    },
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade400,
                          thickness: 1,
                          endIndent: 10,
                        ),
                      ),

                      Text(
                        'continue'.tr(),
                        style: TextStyle(
                          color: Color(0xff6B7280),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      Expanded(
                        child: Divider(
                          color: Colors.grey.shade400,
                          thickness: 1,
                          indent: 10,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.fingerprint,
                                color: Color(0xffB21A1A),
                                size: 30.sp,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'fingerprint'.tr(),
                                style: TextStyle(
                                  color: Color(0xff6B7280),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      Expanded(
                        child: Container(
                          height: 60.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 1.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.face_6,
                                color: Color(0xffB21A1A),
                                size: 30.sp,
                              ),
                              SizedBox(width: 10.w),
                              Text(
                                'Faceprint'.tr(),
                                style: TextStyle(
                                  color: Color(0xff6B7280),
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'don\'t_have_account'.tr(),
                    style: TextStyle(
                      color: Color(0xff6B7280),
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'register'.tr(),
                      style: TextStyle(
                        color: Color(0xffB21A1A),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
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
