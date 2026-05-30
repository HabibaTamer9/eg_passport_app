import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppValidators {
  static String? validateNationalId(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "national_id_required".tr();
    }
    if (value.length != 14) {
      return "national_id_length".tr();
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return "national_id_invalid".tr();
    }
    return null;
  }

  static String? validateDob(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "dob_required".tr();
    }

    return null;
  }

  static String? validateGender(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "gender_required".tr();
    }
    return null;
  }

  static String? validateGovernorate(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "governorate_required".tr();
    }
    return null;
  }

  static String? validateNationality(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "nationality_required".tr();
    }
    return null;
  }

  static String? validateAddress(String? value, BuildContext context) {
    if (value == null || value.isEmpty) {
      return "address_required".tr();
    }
    if (value.length < 10) {
      return "address_min".tr();
    }
    if (value.length > 200) {
      return "address_max".tr();
    }
    return null;
  }
}