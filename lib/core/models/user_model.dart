import 'package:eg_passport_app/core/models/document_model.dart';

import '../data/app_data.dart';

class UserModel {
  final String uID;
  final String name;
  final String email;
  final String phoneNumber;
  String? id;
  String? nationalID;
  String? gender;
  String? dateOfBirth;
  String? city;
  String? address;
  String? birthCity;
  String? nationality;
  String? applicationId;
  String? appNumber;
  List<DocumentModel>? documents;
  String? developmentOtpCode;
  bool otpAlreadySent;
  String? state;
  String? profileImage;
  String? rejectReason;

  UserModel({
    required this.uID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.id,
    this.nationalID,
    this.gender,
    this.dateOfBirth,
    this.city,
    this.address,
    this.birthCity,
    this.nationality,
    this.applicationId,
    this.appNumber,
    this.documents,
    this.developmentOtpCode,
    this.otpAlreadySent = false,
    this.state,
    this.profileImage,
    this.rejectReason,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uID: json['userId'],
      name: json['fullName'],
      email: json['email'],
      phoneNumber: json['mobileNumber'],
    );
  }

  void getPersonalInfo(var data) {
    AppData.user.nationalID = data["nationalId"];
    AppData.user.id = data["id"];
    AppData.user.gender = data["gender"];
    AppData.user.dateOfBirth = AppData().formatDate(data["dateOfBirth"]);
    AppData.user.city = data["governorate"];
    AppData.user.address = data["address"];
    AppData.user.birthCity = data["placeOfBirth"];
    AppData.user.nationality = data["nationality"];
  }
}
