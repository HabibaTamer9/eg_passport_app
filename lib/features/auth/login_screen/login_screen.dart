import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/theme/app_colors.dart';
import 'package:eg_passport_app/features/auth/document_upload/document_upload.dart';
import 'package:eg_passport_app/features/auth/login_screen/login_cubit/login_cubit.dart';
import 'package:eg_passport_app/features/auth/login_screen/login_cubit/login_state.dart';
import 'package:eg_passport_app/features/auth/personal_info_screen/personal_info_ui.dart';
import 'package:eg_passport_app/features/main_screen/main_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/data/app_data.dart';
import '../widgets/background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/customs/custom_button.dart';
import '../../../core/customs/custom_textformfield.dart';
import '../register/register_screen.dart';
import '../forgot_password/forgot_password.dart';

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
  bool isVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => LoginCubit(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryRedColor,
                  ),
                ),
              );
            }
            if (state is LoginFailure) {
              Navigator.pop(context);

              _showApiDialog(title: 'error'.tr(), message: state.error);
            }
            if (state is LoginSuccess) {
              Navigator.pop(context); // يقفل اللودينج

              if (AppData.user.nationalID == null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => PersonalInfoScreen()),
                );
              } else if (AppData.user.documents!.isEmpty) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => DocumentUploadScreen()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => MainScreen()),
                );
              }
            }
          },
          builder: (context, state) {
            return Background(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Text(
                        'login'.tr(),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        'welcome_back'.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
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
                        obscureText: isVisible ? false : true,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'password_required'.tr();
                          }
                          return null;
                        },
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                          ),
                        ),
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
                                style: Theme.of(context).textTheme.titleMedium,
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
                              style: Theme.of(context).textTheme.titleMedium!
                                  .copyWith(color: AppColors.primaryRedColor),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      CustomButton(
                        textName: 'login'.tr(),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            context.read<LoginCubit>().login(
                              emailController.text,
                              passwordController.text,
                              context,
                            );
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
                            style: Theme.of(context).textTheme.titleMedium
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
                                color: Theme.of(context).cardColor,
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
                                    color: AppColors.primaryRedColor,
                                    size: 30.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'fingerprint'.tr(),
                                    style: Theme.of(context).textTheme.titleMedium
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
                                color: Theme.of(context).cardColor,
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
                                    color: AppColors.primaryRedColor,
                                    size: 30.sp,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Faceprint'.tr(),
                                    style: Theme.of(context).textTheme.titleMedium
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
                        style: Theme.of(context).textTheme.titleMedium
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
                          style: Theme.of(context).textTheme.titleMedium
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
            );
          },
        ),
      ),
    );
  }
}
