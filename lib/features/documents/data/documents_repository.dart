import 'package:eg_passport_app/features/documents/data/passport_document.dart';

abstract class DocumentsRepository {
  Future<List<PassportDocument>> fetchDocuments();

  Future<List<PassportDocument>> uploadDocument(String documentId);
}

class MockDocumentsRepository implements DocumentsRepository {
  const MockDocumentsRepository();

  static final List<PassportDocument> _documents = [
    const PassportDocument(
      id: 'personal_photo',
      title: 'صورة شخصية',
      kind: PassportDocumentKind.personalPhoto,
      status: PassportDocumentStatus.verified,
      uploadDate: '20 مايو 2025',
      required: true,
    ),
    const PassportDocument(
      id: 'national_id_front',
      title: 'بطاقة الرقم القومي أمامي',
      kind: PassportDocumentKind.nationalIdFront,
      status: PassportDocumentStatus.verified,
      uploadDate: '20 مايو 2025',
      required: true,
    ),
    const PassportDocument(
      id: 'national_id_back',
      title: 'بطاقة الرقم القومي خلفي',
      kind: PassportDocumentKind.nationalIdBack,
      status: PassportDocumentStatus.verified,
      uploadDate: '20 مايو 2025',
      required: true,
    ),
    const PassportDocument(
      id: 'birth_certificate',
      title: 'شهادة الميلاد',
      kind: PassportDocumentKind.birthCertificate,
      status: PassportDocumentStatus.verified,
      uploadDate: '20 مايو 2025',
      required: true,
    ),
    const PassportDocument(
      id: 'previous_passport',
      title: 'جواز سفر سابق إن وجد',
      kind: PassportDocumentKind.previousPassport,
      status: PassportDocumentStatus.optional,
      uploadDate: '20 مايو 2025',
      required: false,
    ),
    const PassportDocument(
      id: 'academic_certificate',
      title: 'شهادة المؤهل الدراسي',
      kind: PassportDocumentKind.academicCertificate,
      status: PassportDocumentStatus.pending,
      uploadDate: '18 مايو 2025',
      required: false,
    ),
    const PassportDocument(
      id: 'proof_of_residence',
      title: 'إثبات محل الإقامة',
      kind: PassportDocumentKind.proofOfResidence,
      status: PassportDocumentStatus.rejected,
      uploadDate: '15 مايو 2025',
      required: false,
    ),
    const PassportDocument(
      id: 'extra_documents',
      title: 'أي مستندات إضافية',
      kind: PassportDocumentKind.extraDocuments,
      status: PassportDocumentStatus.optional,
      uploadDate: '',
      required: false,
    ),
  ];

  @override
  Future<List<PassportDocument>> fetchDocuments() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return List<PassportDocument>.from(_documents);
  }

  @override
  Future<List<PassportDocument>> uploadDocument(String documentId) async {
    await Future<void>.delayed(const Duration(milliseconds: 550));
    for (var i = 0; i < _documents.length; i++) {
      if (_documents[i].id == documentId) {
        _documents[i] = _documents[i].copyWith(
          status: PassportDocumentStatus.pending,
          uploadDate: '7 يونيو 2025',
        );
        break;
      }
    }
    return List<PassportDocument>.from(_documents);
  }
}
