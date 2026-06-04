import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Api/api_helper.dart';
import '../../../../core/Api/endpoint.dart';
import '../../../../core/data/app_data.dart';
import '../../../../core/models/document_model.dart';
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

  void getUser(var response) {
    AppData.user = UserModel(
      uID: response["userId"],
      name: response["fullName"],
      email: response["email"],
      phoneNumber: response["mobileNumber"],
    );
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
      print("======================Login : $response");

      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }

      _saveAuthTokens(response);
      getUser(response["data"]);
      await getProfile();
      await getApplications();
      await getState();
      await getNotifications();

     Future.delayed(Duration(seconds: 1),()=>emit(LoginSuccess()));


    } catch (e) {
      print("======================Login : $e");
      emit(LoginFailure("errorMessage".tr()));
    }
  }

  Future<void> getApplications() async {
    try {
      var response = await ApiHelper().getAPI(
        "${Endpoint.my}${Endpoint.applications}",
      );
      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }
      AppData.user.applicationId = response["data"]["items"][0]["id"];
      AppData.user.appNumber =
          response["data"]["items"][0]["applicationNumber"];
      List documents = response["data"]["items"][0]["documents"];
      AppData.user.documents = documents
          .map((d) => DocumentModel.fromJson(d))
          .toList();
      AppData.user.profileImage =AppData.user.documents!
          .where((d) => d.documentType == "ProfilePhoto")
          .first
          .fileUrl;
    } catch (e) {
      print("======================Applications : $e");
      emit(LoginFailure("applicationError:${"errorMessage".tr()}"));
    }
  }

  Future<void> getState() async {
    try {
      var response = await ApiHelper().getAPI(
        "${Endpoint.appURL}${AppData.user.applicationId}/${Endpoint.status}",
      );
      print("======================Profile : $response");
      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }
      AppData.user.state = response["data"]["status"];
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

      var data = response["data"];

      AppData.user.nationalID = data["nationalId"];
      AppData.user.id = data["id"];
      AppData.user.gender = data["gender"];
      AppData.user.dateOfBirth = data["dateOfBirth"];
      AppData.user.city = data["governorate"];
      AppData.user.address = data["address"];
      AppData.user.birthCity = data["placeOfBirth"];
      AppData.user.nationality = data["nationality"];
    } catch (e) {
      emit(LoginFailure("profileError:${"errorMessage".tr()}"));
    }
  }

  Future<void> getNotifications() async {
    try {
      var response = await ApiHelper().getAPI(
        "${Endpoint.my}${Endpoint.notifications}",
      );
      print("======================Profile : $response");

      if (response["success"] != true) {
        emit(LoginFailure(_apiMessage(response)));
        return;
      }
    } catch (e) {
      emit(LoginFailure("notificationsError:${"errorMessage".tr()}"));
    }
  }
}
