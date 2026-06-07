import 'package:eg_passport_app/features/documents/cubit/documents_state.dart';
import 'package:eg_passport_app/features/documents/data/documents_file_picker_service.dart';
import 'package:eg_passport_app/features/documents/data/documents_repository.dart';
import 'package:eg_passport_app/features/documents/data/passport_document.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentsCubit extends Cubit<DocumentsState> {
  DocumentsCubit(this._repository) : super(const DocumentsInitial());

  final DocumentsRepository _repository;

  static const List<int> _uploadProgressSteps = [12, 28, 45, 62, 78, 92, 100];

  Future<void> loadDocuments() async {
    emit(const DocumentsLoading());
    try {
      final documents = await _repository.fetchDocuments();
      emit(DocumentsLoaded(documents));
    } catch (_) {
      emit(
        const DocumentsLoadError(
          message: 'تعذر تحميل المستندات، يرجى المحاولة مرة أخرى.',
        ),
      );
    }
  }

  Future<void> pickAndUploadDocument(PassportDocument document) async {
    try {
      final pickedFile = await DocumentsFilePickerService.pickForKind(
        document.kind,
      );
      if (pickedFile == null || isClosed) return;
      await uploadDocument(document.id);
    } on DocumentPickValidationException catch (error) {
      final documents = _currentDocuments;
      if (documents.isEmpty || isClosed) return;
      emit(DocumentsUploadFailed(message: error.message, documents: documents));
    }
  }

  Future<void> uploadDocument(String documentId) async {
    final documents = _currentDocuments;
    if (documents.isEmpty) return;

    emit(
      DocumentsUploading(
        documents: documents,
        documentId: documentId,
        progress: 0,
      ),
    );

    try {
      for (final step in _uploadProgressSteps) {
        await Future<void>.delayed(const Duration(milliseconds: 130));
        if (isClosed) return;
        emit(
          DocumentsUploading(
            documents: documents,
            documentId: documentId,
            progress: step,
          ),
        );
      }

      final updatedDocuments = await _repository.uploadDocument(documentId);
      if (isClosed) return;
      emit(DocumentsLoaded(updatedDocuments));
    } catch (_) {
      if (isClosed) return;
      emit(
        DocumentsUploadFailed(
          message: 'فشل رفع المستند، تحقق من الاتصال وحاول مرة أخرى.',
          documents: documents,
        ),
      );
    }
  }

  void dismissUploadError() {
    final documents = _currentDocuments;
    if (documents.isEmpty) return;
    emit(DocumentsLoaded(documents));
  }

  List<PassportDocument> get _currentDocuments {
    return switch (state) {
      DocumentsLoaded(:final documents) => documents,
      DocumentsUploading(:final documents) => documents,
      DocumentsUploadFailed(:final documents) => documents,
      _ => const <PassportDocument>[],
    };
  }
}
