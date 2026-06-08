import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/features/notification_screen/data/notification_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Api/api_helper.dart';
import '../../../../core/Api/endpoint.dart';
import '../../../../core/data/app_data.dart';
import '../../../../core/models/document_model.dart';
import '../../../../core/models/passport_model.dart';
import '../../../../core/models/user_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  String messageLanguage = ApiHelper.messageLanguage;

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

  Future<void> login(String email, String password, BuildContext context) async {
    emit(LoginLoading());
    showDialog(
      context: context,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      var response = await ApiHelper().postAuthAPI(Endpoint.login, {
        "emailOrMobile": email,
        "password": password,
      });
      print("======================login : $response");

      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }

      _saveAuthTokens(response);
      AppData.user = UserModel.fromJson(response["data"]);

      //getAdminApplications();
      await getProfile();
      await getApplications();
      await getPassport();

     Future.delayed(Duration(seconds: 1),()=>emit(LoginSuccess()));


    } catch (e) {
      print("====================error $e");
      emit(LoginFailure("errorMessage".tr()));
    }
  }

  Future<void> getPassport() async {
    try {
      var response = await ApiHelper().getAPI(
        "/api/wallet",
      );
      AppData.passport = PassportModel.fromJson(response);
      print("======================wallet : $response");
    } catch (e) {
      print("=========================error $e");
    }
  }
  //
  // Future<void> getAdminApplications() async {
  //   try {
  //     var response = await ApiHelper().getAPI(
  //       "/api/admin/applications",
  //     );
  //     if (response["success"] != true) {
  //       emit(LoginFailure(_apiMessage(response)));
  //       return;
  //     }
  //    print("======================applications : $response");
  //     AppData.user.applicationId = response["data"]["items"][0]["id"];
  //     AppData.user.appNumber =
  //         response["data"]["items"][0]["applicationNumber"];
  //     List documents = response["data"]["items"][0]["documents"];
  //     AppData.user.documents = documents
  //         .map((d) => DocumentModel.fromJson(d))
  //         .toList();
  //     AppData.user.documents?.forEach((d)=> verify(d.documentId));
  //   } catch (e) {
  //     print("=========================error $e");
  //     emit(LoginFailure("applicationError:${"errorMessage".tr()}"));
  //   }
  // }
  Future<void> getApplications() async {
    try {
      var response = await ApiHelper().getAPI(
        "${Endpoint.my}${Endpoint.applications}",
      );
      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }
      print("======================applications : $response");
      if(response["data"]["items"].length > 0) {
        AppData.user.applicationId = response["data"]["items"][0]["id"];
        AppData.user.appNumber =
        response["data"]["items"][0]["applicationNumber"];
        List documents = response["data"]["items"][0]["documents"];
        AppData.user.documents = documents
            .map((d) => DocumentModel.fromJson(d))
            .toList();
      }else{
        AppData.user.applicationId = null;
        AppData.user.appNumber = null;
        AppData.user.documents = [];
      }
    if(AppData.user.documents!.isNotEmpty) await getState();

      //AppData.user.documents?.forEach((d)=> verify(d.documentId));
    } catch (e) {
      emit(LoginFailure("applicationError:${"errorMessage".tr()}"));
    }
  }

  Future<void> verify(id) async {
    try {
      var response = await ApiHelper().getAPI(
        "/api/admin/documents/$id/verify",
      );
      print("======================document : $response");
      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }

    } catch (e) {
      emit(LoginFailure("stateError:${"errorMessage".tr()}"));
    }
  }
  Future<void> getState() async {
    try {
      var response = await ApiHelper().getAPI(
        "${Endpoint.appURL}${AppData.user.applicationId}/${Endpoint.status}",
      );
      print("======================state : $response");
      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }
      AppData.user.state = response["data"]["status"];
      AppData.user.rejectReason = response["data"]["rejectReason"]?? "";
    } catch (e) {
      emit(LoginFailure("stateError:${"errorMessage".tr()}"));
    }
  }

  Future<void> getProfile() async {
    try {
      var response = await ApiHelper().getAPI(Endpoint.meProfile);
      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }
      print("======================profile : $response");

      var data = response["data"];

     if(data != null && data != []) AppData.user.getPersonalInfo(data);
    } catch (e) {
      emit(LoginFailure("profileError:${"errorMessage".tr()}"));
    }
  }

}
