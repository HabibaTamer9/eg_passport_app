import 'package:eg_passport_app/features/documents/data/passport_document.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

Color documentStatusColor(PassportDocumentStatus status) {
  switch (status) {
    case PassportDocumentStatus.verified:
      return EPassportColors.approved;
    case PassportDocumentStatus.pending:
      return EPassportColors.pending;
    case PassportDocumentStatus.rejected:
      return EPassportColors.rejected;
    case PassportDocumentStatus.optional:
      return EPassportColors.officialBlue;
  }
}

String documentStatusLabel(PassportDocumentStatus status) {
  switch (status) {
    case PassportDocumentStatus.verified:
      return 'تم التحقق';
    case PassportDocumentStatus.pending:
      return 'قيد المراجعة';
    case PassportDocumentStatus.rejected:
      return 'مرفوض';
    case PassportDocumentStatus.optional:
      return 'اختياري';
  }
}

class DocumentStatusBadge extends StatelessWidget {
  const DocumentStatusBadge({super.key, required this.status});

  final PassportDocumentStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: documentStatusLabel(status),
      color: documentStatusColor(status),
    );
  }
}
