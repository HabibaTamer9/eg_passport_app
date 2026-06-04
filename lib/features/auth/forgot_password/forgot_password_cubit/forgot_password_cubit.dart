import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/features/auth/forgot_password/forgot_password_cubit/forgot_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Api/api_helper.dart';
import '../../../../core/Api/endpoint.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(ForgotPasswordInitial());

  String messageLanguage = ApiHelper.messageLanguage;
  String code = "";
  String phoneNumber = "";

  String _apiMessage(Map<String, dynamic> response) {
    final errors = response["errors"];
    if (errors.isNotEmpty) {
      return errors.first[messageLanguage] ?? "حدث خطأ في البيانات";
    }

    return response[messageLanguage] ?? "حدث خطأ غير متوقع";
  }

  Future<void> forgotPassword(String emailOrMobile) async {
    try {
      var response = await ApiHelper().postAuthAPI(Endpoint.forgotPassword, {
        "emailOrMobile": emailOrMobile,
      });

      if (response["success"] != true) {
        emit(ForgotPasswordFailure(_apiMessage(response)));
        return;
      }
      print("==================$response");

      code = response["data"]["developmentCode"].toString();
      phoneNumber = response["data"]["mobileNumber"].toString();
      emit(ForgotPasswordCode());
      return;
    } catch (e) {
      emit(ForgotPasswordFailure("errorMessages".tr()));
    }
  }

  void checkCode(String userCode) {
    if(userCode == code){
      emit(ForgotPasswordSuccess());
    }else{
      emit(ForgotPasswordFailure("الكود غير صحيح حاول مره اخري"));
    }
  }

  Future<void> resetPassword(
    String mobileNumber,
    String newPassword,
    String confirmPassword,
  ) async {
    emit(ResetPasswordLoading());
    try {
      var response = await ApiHelper().postAuthAPI(Endpoint.resetPassword, {
        "mobileNumber": mobileNumber,
        "code": code,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      });

      if (response["success"] != true) {
        emit(ResetPasswordFailure(_apiMessage(response)));
        return;
      }
      emit(ResetPasswordSuccess());
      return;
    } catch (e) {
      emit(ResetPasswordFailure("errorMessages".tr()));
    }
  }
}
