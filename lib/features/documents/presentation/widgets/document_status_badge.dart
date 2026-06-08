import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/status_badge.dart';
import 'package:flutter/material.dart';

class DocumentStatusBadge extends StatelessWidget {
  const DocumentStatusBadge({super.key, required this.status});

  final String status;

  Color get _color {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
        return EPassportColors.approved;
      case 'pending':
      case 'uploaded':
        return EPassportColors.pending;
      case 'rejected':
        return EPassportColors.rejected;
      default:
        return EPassportColors.officialBlue;
    }
  }

  String get _label {
    switch (status.toLowerCase()) {
      case 'verified':
      case 'approved':
        return 'تم التحقق';
      case 'pending':
        return 'قيد المراجعة';
      case 'uploaded':
        return 'تم الرفع';
      case 'rejected':
        return 'مرفوض';
      default:
        return 'اختياري';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: _label,
      color: _color,
    );
  }
}
