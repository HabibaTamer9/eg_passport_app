import 'package:eg_passport_app/features/documents/data/passport_document.dart';
import 'package:file_picker/file_picker.dart';

class DocumentPickValidationException implements Exception {
  DocumentPickValidationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class PickedPassportDocumentFile {
  const PickedPassportDocumentFile({
    required this.name,
    required this.displayPath,
    this.sizeBytes,
  });

  final String name;
  final String displayPath;
  final int? sizeBytes;
}

class _DocumentPickRules {
  const _DocumentPickRules({
    required this.allowedExtensions,
    required this.maxSizeBytes,
    required this.unsupportedTypeMessage,
  });

  final List<String> allowedExtensions;
  final int maxSizeBytes;
  final String unsupportedTypeMessage;
}

class DocumentsFilePickerService {
  DocumentsFilePickerService._();

  static const int _photoMaxBytes = 5 * 1024 * 1024;
  static const int _documentMaxBytes = 10 * 1024 * 1024;

  static Future<PickedPassportDocumentFile?> pickForKind(
    PassportDocumentKind kind,
  ) async {
    final rules = _rulesForKind(kind);

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: rules.allowedExtensions,
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
      throw DocumentPickValidationException('لم يتم اختيار ملف صالح');
    }

    final extension = _extensionFromName(name);
    if (!_isExtensionAllowed(extension, rules.allowedExtensions)) {
      throw DocumentPickValidationException(rules.unsupportedTypeMessage);
    }

    final size = platformFile.size;
    if (size > rules.maxSizeBytes) {
      final limitMb = rules.maxSizeBytes ~/ (1024 * 1024);
      throw DocumentPickValidationException(
        'حجم الملف يتجاوز الحد المسموح به ($limitMb ميغابايت)',
      );
    }

    return PickedPassportDocumentFile(
      name: name,
      displayPath: platformFile.path ?? platformFile.name,
      sizeBytes: size > 0 ? size : null,
    );
  }

  static _DocumentPickRules _rulesForKind(PassportDocumentKind kind) {
    switch (kind) {
      case PassportDocumentKind.personalPhoto:
        return const _DocumentPickRules(
          allowedExtensions: ['jpg', 'jpeg', 'png'],
          maxSizeBytes: _photoMaxBytes,
          unsupportedTypeMessage:
              'نوع الملف غير مدعوم. يُسمح فقط بـ JPG أو PNG',
        );
      case PassportDocumentKind.nationalIdFront:
      case PassportDocumentKind.nationalIdBack:
        return const _DocumentPickRules(
          allowedExtensions: ['jpg', 'jpeg', 'png'],
          maxSizeBytes: _photoMaxBytes,
          unsupportedTypeMessage:
              'نوع الملف غير مدعوم. يُسمح فقط بـ JPG أو PNG',
        );
      case PassportDocumentKind.birthCertificate:
      case PassportDocumentKind.previousPassport:
      case PassportDocumentKind.academicCertificate:
      case PassportDocumentKind.proofOfResidence:
      case PassportDocumentKind.extraDocuments:
        return const _DocumentPickRules(
          allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
          maxSizeBytes: _documentMaxBytes,
          unsupportedTypeMessage:
              'الملف غير مدعوم. يُسمح بـ JPG أو PNG أو PDF فقط',
        );
    }
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
}
