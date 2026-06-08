import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/core/customs/custom_button.dart';
import 'package:eg_passport_app/core/theme/app_colors.dart';
import 'package:eg_passport_app/features/auth/widgets/background.dart';
import 'package:eg_passport_app/features/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../cubit/otp_cubit.dart';
import '../cubit/otp_state.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    context.read<OtpCubit>().sendOtp();
  }

  String formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<OtpCubit>();

    return Scaffold(
      body: Background(
        currentIndex: 3,
        child: BlocBuilder<OtpCubit, OtpState>(
          builder: (context, state) {
            int timerSeconds = cubit.seconds;
            String errorText = "";

            if (state is OtpTimerRunning) {
              timerSeconds = state.seconds;
            }

            if (state is OtpError) {
              errorText = state.message;
            }

            if (state is OtpLocked) {
              errorText =
                  "${'otp_error'.tr()} ${state.lockMinutes} ${'minutes'.tr()}";
            }
            if (state is OtpSuccess) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
            }


            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sms_outlined, size: 70),

                  const SizedBox(height: 20),

                  Text(
                    'otp_code'.tr(),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                   Text(
                    'otp_desc'.tr(),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  /// OTP BOXES
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 45.w,
                        height: 65.h,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: TextField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Colors.grey.shade100,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            cubit.updateDigit(index, value);

                            if (value.isNotEmpty && index < 5) {
                              focusNodes[index + 1].requestFocus();
                            }

                            if (value.isEmpty && index > 0) {
                              focusNodes[index - 1].requestFocus();
                            }
                          },
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 25),

                  /// TIMER
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      formatTime(timerSeconds),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  /// ERROR
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

                  const SizedBox(height: 25),

                  /// VERIFY BUTTON
                  if (state is OtpLoading)
                    const CircularProgressIndicator()
                  else
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: CustomButton(
                        textName: 'otp_verify'.tr(),
                        onPressed: () {
                          cubit.verifyOtp();
                        },
                      ),
                    ),

                  const SizedBox(height: 12),

                  /// RESEND
                  TextButton(
                    onPressed: timerSeconds == 0
                        ? () {
                            for (final c in controllers) {
                              c.clear();
                            }
                            cubit.resendOtp();
                          }
                        : null,
                    child: Text('otp_resend'.tr() , style: TextStyle(
                      color: AppColors.primaryRedColor
                    )
                        ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
