import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/customs/custom_button.dart';
import 'package:eg_passport_app/core/customs/custom_textformfield.dart';
import 'package:eg_passport_app/features/auth/forgot_password/forgot_password_cubit/forgot_password_cubit.dart';
import 'package:eg_passport_app/features/auth/forgot_password/forgot_password_cubit/forgot_password_state.dart';
import 'package:eg_passport_app/features/auth/login_screen/login_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/Api/api_helper.dart';
import '../widgets/background.dart';
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
  String errorText = "";

  @override
  void dispose() {
    controller.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
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
          CustomButton(textName: "OK", onPressed: () => Navigator.pop(context)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ForgotPasswordCubit(),
        child: BlocBuilder<ForgotPasswordCubit, ForgotPasswordState>(
          builder: (context, state) {
            var cubit = context.read<ForgotPasswordCubit>();
            if (state is ForgotPasswordLoading) {
              showDialog(
                context: context,
                builder: (context) => Center(child: CircularProgressIndicator()),
              );
            }
            if (state is ForgotPasswordFailure) {
              errorText = state.error;
              setState(() {
              });
            }
            if (state is ForgotPasswordCode) {
              pageController.nextPage(
                duration: Duration(seconds: 1),
                curve: Curves.easeIn,
              );
            }
            if (state is ForgotPasswordSuccess) {
              pageController.nextPage(
                duration: Duration(seconds: 1),
                curve: Curves.easeIn,
              );
            }
            if (state is ResetPasswordLoading) {
              showDialog(
                context: context,
                builder: (context) => Center(child: CircularProgressIndicator()),
              );
            }
            if (state is ResetPasswordSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
            if (state is ResetPasswordFailure) {
              _showApiDialog(title: 'error'.tr(), message: state.error);
            }

            return Background(
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
                            cubit.forgotPassword(controller.text);
                          },
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.sms_outlined, size: 70),
                      Text("Enter the code sent to your email or phone number"),
                      const SizedBox(height: 15),
                      Pinput(
                        keyboardType: TextInputType.number,
                        length: 6,
                        onCompleted: (pin) {
                          cubit.checkCode(pin);
                        },
                      ),
                      const SizedBox(height: 15),
                      if (errorText.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade300),
                          ),
                          child: Text(
                            errorText,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Column(
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

                      CustomButton(
                        textName: "Reset Password",
                        onPressed: () {
                          cubit.resetPassword(
                            controller.text,
                            passwordController.text,
                            confirmPasswordController.text,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
