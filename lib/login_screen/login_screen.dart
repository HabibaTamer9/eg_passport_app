import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/customs/custom_button.dart';
import 'package:eg_passport_app/customs/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.33,
            child: Image.asset('assets/Group 1.png', fit: BoxFit.fill),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.29,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(top: 20.h, left: 15.w, right: 15.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: SingleChildScrollView(
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
                          Text(
                            'forget_password'.tr(),
                            style: TextStyle(
                              color: Color(0xffB21A1A),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      CustomButton(textName: 'login'.tr(),onPressed: (){
                        if (_formKey.currentState!.validate()) {
                          print("login");
                        }
                      },),
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
                                )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.fingerprint, color: Color(0xffB21A1A), size: 30.sp),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'fingerprint'.tr(),
                                    style: TextStyle(
                                      color: Color(0xff6B7280),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  ]
                              ),
                            ),
                          ),
                          SizedBox(width: 5.w),Expanded(
                            child: Container(
                              height: 60.h,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.grey.shade400,
                                  width: 1.0,
                                )
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.face_6, color: Color(0xffB21A1A), size: 30.sp),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Faceprint'.tr(),
                                    style: TextStyle(
                                      color: Color(0xff6B7280),
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),

                                  ]
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
                      SizedBox(height: 2.h),
                      Text('register'.tr(),style: TextStyle(
                        color: Color(0xffB21A1A),
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w500,
                      ),),
                      SizedBox(
                        height: 60.h,
                        width: 360.w,
                        child: Image.asset("assets/back.png", fit: BoxFit.cover),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
