class PassportModel {
  final bool success;

  final String messageAr;
  final String messageEn;

  String? passportId;
  String? userId;
  String? appId;
  String? passportNumber;
  String? status;
  String? qrToken;
  String? qrExpiresAt;
  String? issuedAt;
  String? createdAt;
  String? updatedAt;

  PassportModel({
    required this.success,
    required this.messageAr,
    required this.messageEn,
    this.passportId,
    this.userId,
    this.appId,
    this.passportNumber,
    this.status,
    this.qrToken,
    this.qrExpiresAt,
    this.issuedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory PassportModel.fromJson(Map<String, dynamic> json) {
    return PassportModel(
      success: json['success'],
      messageAr: json['messageAr'],
      messageEn: json['messageEn'],
      // passportId: json['passportId'] ?? "",
      // userId: json['userId'] ?? "",
      // appId: json['appId'] ?? "",
      // passportNumber: json['passportNumber'] ?? "",
      // status: json['status'] ?? "",
      // qrToken: json['qrToken'] ?? "",
      // qrExpiresAt: json['qrExpiresAt'] ?? "",
      // issuedAt: json['issuedAt'] ?? "",
      // createdAt: json['createdAt'] ?? "",
      // updatedAt: json['updatedAt'] ?? "",
    );
  }


}
