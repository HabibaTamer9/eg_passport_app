import 'package:eg_passport_app/features/documents/cubit/documents_cubit.dart';
import 'package:eg_passport_app/features/documents/cubit/documents_state.dart';
import 'package:eg_passport_app/features/documents/data/documents_repository.dart';
import 'package:eg_passport_app/features/documents/data/passport_document.dart';
import 'package:eg_passport_app/features/documents/presentation/widgets/document_card.dart';
import 'package:eg_passport_app/features/documents/presentation/widgets/security_banner.dart';
import 'package:eg_passport_app/features/e_passport/e_passport_routes.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DocumentsManagementScreen extends StatelessWidget {
  const DocumentsManagementScreen({super.key});

  static const String routeName = EPassportRoutes.documents;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          DocumentsCubit(const MockDocumentsRepository())..loadDocuments(),
      child: const EPassportShell(
        activeDestination: EPassportDestination.documents,
        child: _DocumentsManagementView(),
      ),
    );
  }
}

class _DocumentsManagementView extends StatelessWidget {
  const _DocumentsManagementView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsCubit, DocumentsState>(
      listenWhen: (previous, current) => current is DocumentsUploadFailed,
      listener: (context, state) {
        if (state is DocumentsUploadFailed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.message, textAlign: TextAlign.right),
                backgroundColor: EPassportColors.rejected,
                action: SnackBarAction(
                  label: 'إغلاق',
                  textColor: EPassportColors.surface,
                  onPressed: () =>
                      context.read<DocumentsCubit>().dismissUploadError(),
                ),
              ),
            );
        }
      },
      builder: (context, state) {
        if (state is DocumentsLoading || state is DocumentsInitial) {
          return const SizedBox(
            height: 460,
            child: Center(
              child: CircularProgressIndicator(color: EPassportColors.red),
            ),
          );
        }

        if (state is DocumentsLoadError) {
          return _DocumentsError(message: state.message);
        }

        final documents = switch (state) {
          DocumentsLoaded(:final documents) => documents,
          DocumentsUploading(:final documents) => documents,
          DocumentsUploadFailed(:final documents) => documents,
          _ => const <PassportDocument>[],
        };

        final uploadingId = state is DocumentsUploading ? state.documentId : null;
        final uploadProgress = state is DocumentsUploading ? state.progress : 0;

        return _DocumentsContent(
          documents: documents,
          uploadingDocumentId: uploadingId,
          uploadProgress: uploadProgress,
        );
      },
    );
  }
}

class _DocumentsContent extends StatelessWidget {
  const _DocumentsContent({
    required this.documents,
    required this.uploadingDocumentId,
    required this.uploadProgress,
  });

  final List<PassportDocument> documents;
  final String? uploadingDocumentId;
  final int uploadProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'المستندات',
          textAlign: TextAlign.center,
          style: EPassportTextStyles.title(24),
        ),
        const SizedBox(height: 6),
        Text(
          'جميع المستندات التي قمت برفعها لطلب جواز السفر الرقمي',
          textAlign: TextAlign.center,
          style: EPassportTextStyles.body(
            size: 13,
            color: EPassportColors.muted,
            weight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 20),
        const SecurityBanner(),
        const SizedBox(height: 24),
        Text(
          'المستندات المطلوبة',
          textAlign: TextAlign.right,
          style: EPassportTextStyles.title(17),
        ),
        const SizedBox(height: 14),
        _DocumentsResponsiveGrid(
          documents: documents,
          uploadingDocumentId: uploadingDocumentId,
          uploadProgress: uploadProgress,
        ),
        const SizedBox(height: 18),
        const _ImportantNote(),
      ],
    );
  }
}

class _DocumentsResponsiveGrid extends StatelessWidget {
  const _DocumentsResponsiveGrid({
    required this.documents,
    required this.uploadingDocumentId,
    required this.uploadProgress,
  });

  final List<PassportDocument> documents;
  final String? uploadingDocumentId;
  final int uploadProgress;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<DocumentsCubit>();

    return LayoutBuilder(
      builder: (context, constraints) {
        Widget buildCard(PassportDocument document, {required bool compact}) {
          final uploading = uploadingDocumentId == document.id;
          return DocumentCard(
            document: document,
            compact: compact,
            uploading: uploading,
            uploadProgress: uploading ? uploadProgress : 0,
            onUpload: () => cubit.pickAndUploadDocument(document),
            onReplace: document.uploadDate.isNotEmpty
                ? () => cubit.pickAndUploadDocument(document)
                : null,
          );
        }

        if (constraints.maxWidth < 560) {
          return Column(
            children: documents
                .map((document) => buildCard(document, compact: true))
                .toList(),
          );
        }

        final columns = constraints.maxWidth >= 980
            ? 4
            : constraints.maxWidth >= 720
            ? 3
            : 2;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: documents.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            mainAxisExtent: 286,
          ),
          itemBuilder: (context, index) {
            return buildCard(documents[index], compact: false);
          },
        );
      },
    );
  }
}

class _ImportantNote extends StatelessWidget {
  const _ImportantNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: EPassportColors.infoBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD9EAFD)),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: EPassportColors.officialBlue,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'ملاحظات مهمة: يرجى التأكد من أن جميع المستندات واضحة وسارية المفعول قبل الاعتماد النهائي.',
              textAlign: TextAlign.center,
              style: EPassportTextStyles.body(
                size: 12,
                color: EPassportColors.officialBlue,
                weight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DocumentsError extends StatelessWidget {
  const _DocumentsError({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 460,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: EPassportColors.rejected,
              size: 38,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: EPassportTextStyles.body(
                size: 14,
                color: EPassportColors.rejected,
              ),
            ),
            const SizedBox(height: 14),
            ElevatedButton(
              onPressed: () => context.read<DocumentsCubit>().loadDocuments(),
              style: ElevatedButton.styleFrom(
                backgroundColor: EPassportColors.officialBlue,
                foregroundColor: EPassportColors.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      ),
    );
  }
}
