import 'package:eg_passport_app/core/Api/api_helper.dart';
import 'package:eg_passport_app/core/data/app_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Api/endpoint.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  int seconds = 300;
  int attempts = 0;
  bool isLocked = false;
  String rightCode = "";

  List<String> otp = List.filled(6, "");

  String _apiMessage(Map<String, dynamic> response) {
    final errors = response["errors"];
    if (errors.isNotEmpty) {
      return errors.first[ApiHelper.messageLanguage] ?? "حدث خطأ في البيانات";
    }

    return response[ApiHelper.messageLanguage] ?? "حدث خطأ غير متوقع";
  }


  Future<void> sendOtp()async {
    try {
      if (AppData.user.otpAlreadySent) {
        rightCode = AppData.user.developmentOtpCode ?? "";
        startTimer();
        return;
      }

      var response = await ApiHelper().postAPI(Endpoint.sendOTP, {
        "mobileNumber": AppData.user.phoneNumber,
        "purpose": "Register"
      });

      if (response["success"] != true) {
        emit(OtpError(_apiMessage(response)));
        return;
      }
      print(response);
      rightCode = response["data"]?["developmentCode"]?.toString() ?? "";
      AppData.user.developmentOtpCode = rightCode;
      AppData.user.otpAlreadySent = true;
      startTimer();
      return;
    }catch (e){
      emit(OtpError(e.toString()));
    }
  }



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

  Future<void> verifyOtp() async {
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

    try {
      final response = await ApiHelper().postAPI(Endpoint.verifyOTP, {
        "mobileNumber": AppData.user.phoneNumber,
        "code": code,
        "purpose": "Register",
        if (AppData.user.applicationId != null)
          "applicationId": AppData.user.applicationId,
      });

      print(response);

      if (response["success"] == true) {
        emit(OtpSuccess());
        return;
      }

      attempts++;
      if (attempts >= 3) {
        isLocked = true;
        emit(OtpLocked(10));
      } else {
        emit(OtpError(_apiMessage(response)));
      }
    } catch (e) {
      emit(OtpError(e.toString()));
    }

  }

  Future<void> resendOtp() async {
    seconds = 300;
    otp = List.filled(6, "");
    AppData.user.otpAlreadySent = false;
    final response = await ApiHelper().postAPI(Endpoint.resendOTP, {
      "mobileNumber": AppData.user.phoneNumber,
      "purpose": "Register"
    });

    rightCode = response["data"]?["developmentCode"]?.toString() ?? "";
    AppData.user.developmentOtpCode = rightCode;
    print(rightCode);
    AppData.user.otpAlreadySent = true;
    startTimer();
  }
}
