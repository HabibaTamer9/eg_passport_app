import 'package:eg_passport_app/features/documents/data/passport_document.dart';
import 'package:eg_passport_app/features/documents/presentation/widgets/document_status_badge.dart';
import 'package:eg_passport_app/features/documents/presentation/widgets/document_upload_progress.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:flutter/material.dart';

class DocumentCard extends StatelessWidget {
  const DocumentCard({
    super.key,
    required this.document,
    required this.compact,
    required this.uploading,
    required this.uploadProgress,
    required this.onUpload,
    this.onReplace,
  });

  final PassportDocument document;
  final bool compact;
  final bool uploading;
  final int uploadProgress;
  final VoidCallback onUpload;
  final VoidCallback? onReplace;

  bool get _hasUploadedFile => document.uploadDate.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _DocumentMobileTile(
        document: document,
        uploading: uploading,
        uploadProgress: uploadProgress,
        onUpload: onUpload,
        onReplace: onReplace,
        onView: () => _showDocumentPreview(context),
        onOptions: (anchor) => _showOptionsMenu(context, anchor),
      );
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DocumentOptionsButton(
                onSelected: (anchor) => _showOptionsMenu(context, anchor),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  document.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: EPassportTextStyles.body(
                    size: 13,
                    weight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Align(
            alignment: Alignment.centerRight,
            child: DocumentStatusBadge(status: document.status),
          ),
          const SizedBox(height: 12),
          Expanded(child: DocumentPreview(kind: document.kind)),
          const SizedBox(height: 12),
          Text(
            _hasUploadedFile ? 'تم الرفع' : 'لم يتم رفع مستند',
            textAlign: TextAlign.right,
            style: EPassportTextStyles.body(
              size: 11,
              color: EPassportColors.muted,
              weight: FontWeight.w600,
            ),
          ),
          Text(
            _hasUploadedFile ? document.uploadDate : 'اختياري',
            textAlign: TextAlign.right,
            style: EPassportTextStyles.body(size: 11, weight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _DocumentActionButton(
            hasUploadedFile: _hasUploadedFile,
            uploading: uploading,
            uploadProgress: uploadProgress,
            onUpload: onUpload,
            onView: () => _showDocumentPreview(context),
            compact: false,
          ),
        ],
      ),
    );
  }

  void _showDocumentPreview(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: EPassportColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: Text(
              document.title,
              textAlign: TextAlign.right,
              style: EPassportTextStyles.title(16),
            ),
            content: SizedBox(
              width: 280,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 180,
                    child: DocumentPreview(kind: document.kind),
                  ),
                  const SizedBox(height: 12),
                  DocumentStatusBadge(status: document.status),
                  if (_hasUploadedFile) ...[
                    const SizedBox(height: 8),
                    Text(
                      'تاريخ الرفع: ${document.uploadDate}',
                      textAlign: TextAlign.right,
                      style: EPassportTextStyles.body(
                        size: 12,
                        color: EPassportColors.muted,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.start,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('إغلاق'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showOptionsMenu(BuildContext context, Rect anchor) {
    final canReplace = _hasUploadedFile && onReplace != null;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        anchor,
        Offset.zero & MediaQuery.sizeOf(context),
      ),
      items: [
        if (_hasUploadedFile)
          const PopupMenuItem(
            value: 'view',
            child: Text('عرض المستند'),
          ),
        if (canReplace)
          const PopupMenuItem(
            value: 'replace',
            child: Text('استبدال المستند'),
          ),
        if (_hasUploadedFile)
          const PopupMenuItem(
            value: 'info',
            child: Text('تفاصيل الحالة'),
          ),
      ],
    ).then((value) {
      if (!context.mounted || value == null) return;
      switch (value) {
        case 'view':
          _showDocumentPreview(context);
        case 'replace':
          onReplace?.call();
        case 'info':
          _showDocumentPreview(context);
      }
    });
  }

  static BoxDecoration get _cardDecoration {
    return BoxDecoration(
      color: EPassportColors.surface,
      border: Border.all(color: EPassportColors.border),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.035),
          blurRadius: 18,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

class _DocumentOptionsButton extends StatelessWidget {
  const _DocumentOptionsButton({required this.onSelected});

  final void Function(Rect anchor) onSelected;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (buttonContext) {
        return IconButton(
          onPressed: () {
            final box = buttonContext.findRenderObject()! as RenderBox;
            final offset = box.localToGlobal(Offset.zero);
            onSelected(offset & box.size);
          },
          visualDensity: VisualDensity.compact,
          tooltip: 'خيارات المستند',
          icon: const Icon(Icons.more_vert_rounded, size: 18),
          color: EPassportColors.muted,
        );
      },
    );
  }
}

class _DocumentMobileTile extends StatelessWidget {
  const _DocumentMobileTile({
    required this.document,
    required this.uploading,
    required this.uploadProgress,
    required this.onUpload,
    required this.onView,
    required this.onOptions,
    this.onReplace,
  });

  final PassportDocument document;
  final bool uploading;
  final int uploadProgress;
  final VoidCallback onUpload;
  final VoidCallback onView;
  final void Function(Rect anchor) onOptions;
  final VoidCallback? onReplace;

  bool get _hasUploadedFile => document.uploadDate.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: DocumentCard._cardDecoration,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _DocumentOptionsButton(onSelected: onOptions),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  document.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.right,
                  style: EPassportTextStyles.body(
                    size: 12,
                    weight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                DocumentStatusBadge(status: document.status),
                const SizedBox(height: 6),
                Text(
                  _hasUploadedFile
                      ? document.uploadDate
                      : 'لم يتم رفع مستند',
                  textAlign: TextAlign.right,
                  style: EPassportTextStyles.body(
                    size: 11,
                    color: EPassportColors.muted,
                    weight: FontWeight.w600,
                  ),
                ),
                if (!_hasUploadedFile || uploading) ...[
                  const SizedBox(height: 7),
                  _DocumentActionButton(
                    hasUploadedFile: _hasUploadedFile,
                    uploading: uploading,
                    uploadProgress: uploadProgress,
                    onUpload: onUpload,
                    onView: onView,
                    compact: true,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 58,
            height: 58,
            child: DocumentPreview(kind: document.kind),
          ),
        ],
      ),
    );
  }
}

class _DocumentActionButton extends StatelessWidget {
  const _DocumentActionButton({
    required this.hasUploadedFile,
    required this.uploading,
    required this.uploadProgress,
    required this.onUpload,
    required this.onView,
    required this.compact,
  });

  final bool hasUploadedFile;
  final bool uploading;
  final int uploadProgress;
  final VoidCallback onUpload;
  final VoidCallback onView;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (uploading) {
      return DocumentUploadProgressBar(
        progress: uploadProgress,
        compact: compact,
      );
    }

    final icon = hasUploadedFile
        ? Icons.visibility_outlined
        : Icons.cloud_upload_outlined;
    final label = hasUploadedFile ? 'عرض' : 'رفع مستند';

    return SizedBox(
      height: compact ? 32 : 36,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: hasUploadedFile ? onView : onUpload,
        icon: Icon(icon, size: compact ? 15 : 16),
        label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        style: OutlinedButton.styleFrom(
          foregroundColor: EPassportColors.officialBlue,
          side: const BorderSide(color: EPassportColors.border),
          backgroundColor: EPassportColors.surfaceSoft,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          textStyle: EPassportTextStyles.body(
            size: compact ? 11 : 12,
            weight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

class DocumentPreview extends StatelessWidget {
  const DocumentPreview({super.key, required this.kind});

  final PassportDocumentKind kind;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case PassportDocumentKind.personalPhoto:
        return const _PhotoPreview();
      case PassportDocumentKind.nationalIdFront:
        return const _NationalIdPreview(front: true);
      case PassportDocumentKind.nationalIdBack:
        return const _NationalIdPreview(front: false);
      case PassportDocumentKind.birthCertificate:
        return const _PaperPreview(
          accent: Color(0xFFD8C3A5),
          icon: Icons.article_outlined,
        );
      case PassportDocumentKind.previousPassport:
        return const _PassportPreview();
      case PassportDocumentKind.academicCertificate:
        return const _PaperPreview(
          accent: Color(0xFFCBB895),
          icon: Icons.school_outlined,
        );
      case PassportDocumentKind.proofOfResidence:
        return const _PaperPreview(
          accent: Color(0xFF9BB7D4),
          icon: Icons.home_work_outlined,
        );
      case PassportDocumentKind.extraDocuments:
        return const _EmptyDocumentPreview();
    }
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _previewDecoration(const Color(0xFFE6EEF7)),
      child: Center(
        child: Container(
          width: 70,
          height: 86,
          decoration: BoxDecoration(
            color: const Color(0xFFD7E4F1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: Color(0xFF344B63),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(height: 8),
              Container(
                width: 46,
                height: 26,
                decoration: BoxDecoration(
                  color: EPassportColors.officialBlue,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NationalIdPreview extends StatelessWidget {
  const _NationalIdPreview({required this.front});

  final bool front;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _previewDecoration(const Color(0xFFF2E7D7)),
      child: Center(
        child: AspectRatio(
          aspectRatio: 1.58,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: const Color(0xFFEAD8BE),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFC9AF88)),
            ),
            child: front ? _frontFace() : _backFace(),
          ),
        ),
      ),
    );
  }

  Widget _frontFace() {
    return Row(
      children: [
        Container(
          width: 34,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF6F1E8),
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(
            Icons.person_rounded,
            size: 22,
            color: EPassportColors.officialBlue,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _line(0.94),
              const SizedBox(height: 5),
              _line(0.72),
              const SizedBox(height: 5),
              _line(0.84),
            ],
          ),
        ),
      ],
    );
  }

  Widget _backFace() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          height: 18,
          decoration: BoxDecoration(
            color: const Color(0xFF6B4E2E),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(height: 8),
        _line(1),
        const SizedBox(height: 4),
        _line(0.82),
      ],
    );
  }
}

class _PaperPreview extends StatelessWidget {
  const _PaperPreview({required this.accent, required this.icon});

  final Color accent;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _previewDecoration(const Color(0xFFF8F7F4)),
      child: Center(
        child: Container(
          width: 82,
          height: 100,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFD5D0C7)),
          ),
          child: Column(
            children: [
              Icon(icon, color: accent, size: 22),
              const SizedBox(height: 9),
              _line(1),
              const SizedBox(height: 6),
              _line(0.82),
              const SizedBox(height: 6),
              _line(0.68),
              const Spacer(),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.26),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PassportPreview extends StatelessWidget {
  const _PassportPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _previewDecoration(const Color(0xFFEFE8D7)),
      child: Center(
        child: Container(
          width: 70,
          height: 94,
          decoration: BoxDecoration(
            color: EPassportColors.darkBlue,
            borderRadius: BorderRadius.circular(7),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.16),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.workspace_premium_rounded,
                color: EPassportColors.gold,
                size: 27,
              ),
              const SizedBox(height: 9),
              Text(
                'PASSPORT',
                style: EPassportTextStyles.body(
                  size: 8,
                  color: EPassportColors.gold,
                  weight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyDocumentPreview extends StatelessWidget {
  const _EmptyDocumentPreview();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _previewDecoration(const Color(0xFFF9FAFB)),
      child: const Center(
        child: Icon(
          Icons.insert_drive_file_outlined,
          color: EPassportColors.muted,
          size: 42,
        ),
      ),
    );
  }
}

BoxDecoration _previewDecoration(Color color) {
  return BoxDecoration(
    color: color,
    borderRadius: BorderRadius.circular(8),
    border: Border.all(color: EPassportColors.border),
  );
}

Widget _line(double widthFactor) {
  return FractionallySizedBox(
    alignment: Alignment.centerRight,
    widthFactor: widthFactor,
    child: Container(
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFC9CED6),
        borderRadius: BorderRadius.circular(999),
      ),
    ),
  );
}
