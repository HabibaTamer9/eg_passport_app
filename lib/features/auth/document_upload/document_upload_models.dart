import 'package:flutter/material.dart';

/// Backend field keys for POST /uploads/document (EGY-103).
enum DocumentField {
  ProfilePhoto,
  NationalIdFront,
  NationalIdBack,
  BirthCertificate,
  ExistingPassport,
}

/// Lifecycle of a single document slot on Step 3.
enum DocumentUploadPhase { idle, uploading, complete }

/// UI + local state for one document slot.
///
/// After a real file is picked, [fileName] / [filePath] are populated for display.
/// Replace [_simulateNetworkUpload] in the screen with your API client and map
/// server progress into [progress] + [phase].
class DocumentUploadSlotState {
  DocumentUploadPhase phase = DocumentUploadPhase.idle;
  int progress = 0;
  String? fileName;
  String? filePath;
  int? fileSizeBytes;

  bool get isIdle => phase == DocumentUploadPhase.idle;
  bool get isUploading => phase == DocumentUploadPhase.uploading;
  bool get isComplete => phase == DocumentUploadPhase.complete;
  bool get hasSelectedFile =>
      fileName != null && fileName!.trim().isNotEmpty;

  void reset() {
    phase = DocumentUploadPhase.idle;
    progress = 0;
    fileName = null;
    filePath = null;
    fileSizeBytes = null;
  }
}

/// Result returned by [DocumentFilePickerService] after a successful pick + validation.
class PickedDocumentFile {
  const PickedDocumentFile({
    required this.name,
    required this.displayPath,
    this.sizeBytes,
  });

  final String name;
  final String displayPath;
  final int? sizeBytes;
}

/// Static configuration per document type (rules from EGY-103).
class DocumentSlotConfig {
  const DocumentSlotConfig({
    required this.id,
    required this.fieldName,
    required this.titleAr,
    required this.required,
    required this.rulesEn,
    required this.rulesAr,
    required this.noteAr,
    required this.icon,
    required this.previewColor,
    required this.allowedExtensions,
    required this.maxSizeBytes,
  });

  final DocumentField id;
  final String fieldName;
  final String titleAr;
  final bool required;
  final String rulesEn;
  final String rulesAr;
  final String noteAr;
  final IconData icon;
  final Color previewColor;
  final List<String> allowedExtensions;
  final int maxSizeBytes;

  static DocumentSlotConfig? forField(DocumentField field) {
    try {
      return DocumentUploadRegistry.all.firstWhere((c) => c.id == field);
    } catch (_) {
      return null;
    }
  }
}

/// Central registry — single source of truth for the 5 Step 3 documents.
class DocumentUploadRegistry {
  DocumentUploadRegistry._();

  static const int mb5 = 5 * 1024 * 1024;
  static const int mb10 = 10 * 1024 * 1024;

  static const List<DocumentSlotConfig> all = [
    DocumentSlotConfig(
      id: DocumentField.ProfilePhoto,
      fieldName: 'profile_photo',
      titleAr: 'الصورة الشخصية',
      required: true,
      rulesEn:
          'JPG/PNG only, Max 5MB, min resolution 400×400px, face must be visible',
      rulesAr: 'JPG/PNG فقط · حتى 5MB · 400×400px كحد أدنى · الوجه واضح',
      noteAr: 'مستخدمة لمحاكاة القياسات الحيوية',
      icon: Icons.person_outline,
      previewColor: Color(0xFFEDE2CF),
      allowedExtensions: ['jpg', 'jpeg', 'png'],
      maxSizeBytes: mb5,
    ),
    DocumentSlotConfig(
      id: DocumentField.NationalIdFront,
      fieldName: 'national_id_front',
      titleAr: 'الرقم القومي - الوجه الأمامي',
      required: true,
      rulesEn: 'JPG/PNG/PDF, Max 5MB, must be clear and readable',
      rulesAr: 'JPG/PNG/PDF · حتى 5MB · واضح ومقروء',
      noteAr: 'الوجه الأمامي من بطاقة الرقم القومي',
      icon: Icons.badge_outlined,
      previewColor: Color(0xFFE5F4EE),
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      maxSizeBytes: mb5,
    ),
    DocumentSlotConfig(
      id: DocumentField.NationalIdBack,
      fieldName: 'national_id_back',
      titleAr: 'الرقم القومي - الوجه الخلفي',
      required: true,
      rulesEn: 'JPG/PNG/PDF, Max 5MB',
      rulesAr: 'JPG/PNG/PDF · حتى 5MB',
      noteAr: 'الوجه الخلفي من بطاقة الرقم القومي',
      icon: Icons.badge_outlined,
      previewColor: Color(0xFFEAF3F8),
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      maxSizeBytes: mb5,
    ),
    DocumentSlotConfig(
      id: DocumentField.BirthCertificate,
      fieldName: 'birth_certificate',
      titleAr: 'شهادة الميلاد',
      required: true,
      rulesEn: 'JPG/PNG/PDF, Max 10MB',
      rulesAr: 'JPG/PNG/PDF · حتى 10MB',
      noteAr: 'شهادة الميلاد الرسمية',
      icon: Icons.description_outlined,
      previewColor: Color(0xFFFFF2CF),
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      maxSizeBytes: mb10,
    ),
    DocumentSlotConfig(
      id: DocumentField.ExistingPassport,
      fieldName: 'existing_passport',
      titleAr: 'جواز السفر الحالي',
      required: false,
      rulesEn: 'JPG/PNG/PDF, Max 10MB',
      rulesAr: 'JPG/PNG/PDF · حتى 10MB',
      noteAr: 'اختياري إذا كان لديك جواز سفر سابق',
      icon: Icons.menu_book_outlined,
      previewColor: Color(0xFFEBE3D2),
      allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
      maxSizeBytes: mb10,
    ),
  ];

  static List<DocumentSlotConfig> get requiredSlots =>
      all.where((slot) => slot.required).toList();
}
