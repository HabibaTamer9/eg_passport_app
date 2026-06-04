import 'package:eg_passport_app/core/models/document_model.dart';

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
  });
}
