enum PassportDocumentKind {
  personalPhoto,
  nationalIdFront,
  nationalIdBack,
  birthCertificate,
  previousPassport,
  academicCertificate,
  proofOfResidence,
  extraDocuments,
}

enum PassportDocumentStatus { verified, pending, optional, rejected }

class PassportDocument {
  const PassportDocument({
    required this.id,
    required this.title,
    required this.kind,
    required this.status,
    required this.uploadDate,
    required this.required,
  });

  final String id;
  final String title;
  final PassportDocumentKind kind;
  final PassportDocumentStatus status;
  final String uploadDate;
  final bool required;

  PassportDocument copyWith({
    PassportDocumentStatus? status,
    String? uploadDate,
  }) {
    return PassportDocument(
      id: id,
      title: title,
      kind: kind,
      status: status ?? this.status,
      uploadDate: uploadDate ?? this.uploadDate,
      required: required,
    );
  }
}
