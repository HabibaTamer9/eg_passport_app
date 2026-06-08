import 'package:eg_passport_app/core/data/app_data.dart';

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
  final String? uploadedAt;

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
    this.uploadedAt,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      documentId: json['id'] ?? json['documentId'] ?? '',
      applicationId: json['applicationId'] ?? '',
      documentType: json['documentType'] ?? '',
      fileName: json['fileName'] ?? '',
      fileUrl: json['fileUrl'] ?? '',
      contentType: json['contentType'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      status: json['status'] ?? '',
      rejectionReason: json['rejectionReason'],
      uploadedAt: AppData().formatDate(json['uploadedAt']),
    );
  }

  DocumentModel copyWith({
    String? status,
    String? fileUrl,
    String? uploadedAt,
  }) {
    return DocumentModel(
      documentId: documentId,
      applicationId: applicationId,
      documentType: documentType,
      fileName: fileName,
      fileUrl: fileUrl ?? this.fileUrl,
      contentType: contentType,
      fileSize: fileSize,
      status: status ?? this.status,
      rejectionReason: rejectionReason,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}
