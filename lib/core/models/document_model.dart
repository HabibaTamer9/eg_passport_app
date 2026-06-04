class DocumentModel {
  final String documentId;
  final String applicationId;
  final String documentType;
  final String fileName;
  final String fileUrl;
  final String contentType;
  final int fileSize;
  final String status;
  final String? rejectionReason;

  DocumentModel({
    required this.documentId,
    required this.applicationId,
    required this.documentType,
    required this.fileName,
    required this.fileUrl,
    required this.contentType,
    required this.fileSize,
    required this.status,
    this.rejectionReason,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentId: json['id'],
      applicationId: json['applicationId'],
      documentType: json['documentType'],
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
      contentType: json['contentType'],
      fileSize: json['fileSize'],
      status: json['status'],
      rejectionReason: json['rejectionReason'],
    );
  }
}

//{id: d9ae4326-38e6-4f64-bc97-231b4063e441,
// applicationId: a78b5853-e473-441d-86ad-406148583931,
// documentType: ProfilePhoto,
// fileName: a7d6b5fed030445a8e4a2e9b9802ff72.png,
// fileUrl: /uploads/users/6ce990b1-56ce-47b7-8e33-1ac491171dce/applications/a78b5853-e473-441d-86ad-406148583931/ProfilePhoto/a7d6b5fed030445a8e4a2e9b9802ff72.png,
// contentType: image/png,
// fileSize: 3531,
// status: Uploaded,
// rejectionReason: null,
// uploadedAt: 2026-06-03T18:27:52.7254826},
