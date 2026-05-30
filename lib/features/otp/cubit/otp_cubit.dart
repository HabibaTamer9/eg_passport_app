import 'package:flutter_bloc/flutter_bloc.dart';

import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  int seconds = 300;
  int attempts = 0;
  bool isLocked = false;

  List<String> otp = List.filled(6, "");

  void startTimer() async {
    emit(OtpTimerRunning(seconds));

    while (seconds > 0) {
      await Future.delayed(Duration(seconds: 1));
      seconds--;
      emit(OtpTimerRunning(seconds));
    }

    emit(OtpError("OTP expired"));
  }

  void updateDigit(int index, String value) {
    otp[index] = value;
  }

  String getOtpCode() {
    return otp.join();
  }

  void verifyOtp() {
    String code = getOtpCode();

    if (isLocked) {
      emit(OtpLocked(10));
      return;
    }

    if (code.length < 6) {
      emit(OtpError("Enter full OTP"));
      return;
    }

    emit(OtpLoading());

    // fake validation (backend later)
    if (code == "123456") {
      emit(OtpSuccess());
    } else {
      attempts++;

      if (attempts >= 3) {
        isLocked = true;
        emit(OtpLocked(10));
      } else {
        emit(OtpError("Invalid OTP"));
      }
    }
  }

  void resendOtp() {
    seconds = 300;
    otp = List.filled(6, "");
    startTimer();
  }
}
