import 'package:easy_localization/easy_localization.dart';
import 'package:eg_passport_app/features/auth/personal_info_screen/personal_info_cubit/personal_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/Api/api_helper.dart';
import '../../../../core/Api/endpoint.dart';
import '../../../../core/data/app_data.dart';

class PersonalInfoCubit extends Cubit<PersonalInfoState> {
  PersonalInfoCubit() : super(PersonalInfoInitial());
  String messageLanguage = ApiHelper.messageLanguage;

  String _apiMessage(Map<String, dynamic> response) {
    final errors = response["errors"];
    if (errors.isNotEmpty) {
      return errors.first[messageLanguage] ?? "حدث خطأ في البيانات";
    }
    return response[messageLanguage] ?? "حدث خطأ غير متوقع";
  }

  Future<void> getProfile() async {
    try {
      var response = await ApiHelper().getAPI(Endpoint.meProfile);
      if (response["success"] != true) {
        emit(PersonalInfoFailure(_apiMessage(response)));
        return;
      }

      var data = response["data"];

      AppData.user.getPersonalInfo(data);
    } catch (e) {
      emit(PersonalInfoFailure("errorMessage".tr()));
    }
  }

  void personalInfo(
    String nationalId,
    String gender,
    String dateOfBirth,
    String governorate,
    String address,
    String placeOfBirth,
    String nationality,
  ) async {
    emit(PersonalInfoLoading());
    try {
      var response = await ApiHelper().putAPI(Endpoint.meProfile, {
        "nationalId": nationalId,
        "governorate": governorate,
        "address": address,
        "nationality": nationality,
        "placeOfBirth": placeOfBirth,
        "profilePhotoUrl": null,
      });

      if (response["success"] != true) {
        emit(PersonalInfoFailure(_apiMessage(response)));
        return;
      }

      getProfile();

      emit(PersonalInfoSuccess());
    } catch (e) {
      emit(PersonalInfoFailure("errorMessage".tr()));
    }
  }
}
