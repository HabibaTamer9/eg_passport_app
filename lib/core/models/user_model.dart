class UserModel {
  final String uID;
  final String name;
  final String email;
  final int phoneNumber;
  int? nationalID;
  String? gender;
  String? dateOfBirth;
  String? city;
  String? address;
  String? birthCity;
  String? nationality;

  UserModel({
    required this.uID,
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.nationalID,
    this.gender,
    this.dateOfBirth,
    this.city,
    this.address,
    this.birthCity,
    this.nationality,
  });
}
