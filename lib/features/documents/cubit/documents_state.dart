import 'package:eg_passport_app/features/documents/data/passport_document.dart';

abstract class DocumentsState {
  const DocumentsState();
}

class DocumentsInitial extends DocumentsState {
  const DocumentsInitial();
}

class DocumentsLoading extends DocumentsState {
  const DocumentsLoading();
}

class DocumentsLoadError extends DocumentsState {
  const DocumentsLoadError({required this.message});

  final String message;
}

class DocumentsLoaded extends DocumentsState {
  const DocumentsLoaded(this.documents);

  final List<PassportDocument> documents;
}

class DocumentsUploading extends DocumentsState {
  const DocumentsUploading({
    required this.documents,
    required this.documentId,
    required this.progress,
  });

  final List<PassportDocument> documents;
  final String documentId;
  final int progress;
}

class DocumentsUploadFailed extends DocumentsState {
  const DocumentsUploadFailed({
    required this.message,
    required this.documents,
  });

  final String message;
  final List<PassportDocument> documents;
}
