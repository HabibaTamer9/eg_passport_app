import 'package:file_picker/file_picker.dart';
import 'document_upload_models.dart';

/// Thrown when the user picks a file that fails client-side EGY-103 rules.
class DocumentPickValidationException implements Exception {
  DocumentPickValidationException(this.messageAr, {this.messageEn});

  final String messageAr;
  final String? messageEn;

  @override
  String toString() => messageAr;
}

/// Native file picking for Step 3 (mobile / desktop / web via `file_picker`).
///
/// Architecture for the backend team:
/// 1. UI calls [pickForField] → user selects a file with platform picker.
/// 2. On success, the screen stores [PickedDocumentFile] in [DocumentUploadSlotState].
/// 3. Replace the screen's upload simulation with multipart POST to `/uploads/document`
///    using [DocumentSlotConfig.fieldName] and the file bytes/path from this result.
class DocumentFilePickerService {
  DocumentFilePickerService._();

  /// Opens the OS / browser file picker for the given document slot.
  /// Returns `null` when the user cancels. Throws [DocumentPickValidationException]
  /// when the file type or size is invalid.
  static Future<PickedDocumentFile?> pickForField(DocumentField field) async {
    final config = DocumentSlotConfig.forField(field);
    if (config == null) return null;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: config.allowedExtensions,
      allowMultiple: false,
      withData: false,
      lockParentWindow: true,
    );

    if (result == null || result.files.isEmpty) {
      return null;
    }

    final platformFile = result.files.single;
    final name = platformFile.name.trim();
    if (name.isEmpty) {
      throw DocumentPickValidationException(
        'لم يتم اختيار ملف صالح',
        messageEn: 'No valid file was selected',
      );
    }

    final extension = _extensionFromName(name);
    if (!_isExtensionAllowed(extension, config.allowedExtensions)) {
      throw DocumentPickValidationException(
        _unsupportedTypeMessageAr(config),
        messageEn: _unsupportedTypeMessageEn(config),
      );
    }

    final size = platformFile.size;
    if (size > config.maxSizeBytes) {
      throw DocumentPickValidationException(
        _oversizedMessageAr(config),
        messageEn: _oversizedMessageEn(config),
      );
    }

    final displayPath = platformFile.path ?? platformFile.name;

    return PickedDocumentFile(
      name: name,
      displayPath: displayPath,
      sizeBytes: size > 0 ? size : null,
    );
  }

  static String _extensionFromName(String name) {
    final dot = name.lastIndexOf('.');
    if (dot < 0 || dot == name.length - 1) return '';
    return name.substring(dot + 1).toLowerCase();
  }

  static bool _isExtensionAllowed(String extension, List<String> allowed) {
    if (extension.isEmpty) return false;
    return allowed.map((e) => e.toLowerCase()).contains(extension);
  }

  static String _unsupportedTypeMessageAr(DocumentSlotConfig config) {
    if (config.id == DocumentField.profilePhoto) {
      return 'نوع الملف غير مدعوم. يُسمح فقط بـ JPG أو PNG';
    }
    return 'الملف غير مدعوم. يُسمح بـ JPG أو PNG أو PDF فقط';
  }

  static String _unsupportedTypeMessageEn(DocumentSlotConfig config) {
    if (config.id == DocumentField.profilePhoto) {
      return 'File type not supported. Only JPG or PNG are allowed';
    }
    return 'Unsupported file type. Only JPG, PNG or PDF allowed';
  }

  static String _oversizedMessageAr(DocumentSlotConfig config) {
    final limitMb = config.maxSizeBytes ~/ (1024 * 1024);
    if (config.id == DocumentField.profilePhoto ||
        config.id == DocumentField.nationalIdFront ||
        config.id == DocumentField.nationalIdBack) {
      return 'حجم الملف يتجاوز الحد المسموح به ($limitMb ميغابايت)';
    }
    return 'حجم الملف يتجاوز $limitMb ميغابايت';
  }

  static String _oversizedMessageEn(DocumentSlotConfig config) {
    final limitMb = config.maxSizeBytes ~/ (1024 * 1024);
    return 'File size exceeds the maximum limit (${limitMb}MB)';
  }
}
