import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:eg_passport_app/features/e_passport/presentation/widgets/status_badge.dart';
import 'package:eg_passport_app/features/requests/data/passport_request.dart';
import 'package:flutter/material.dart';

Color requestStatusColor(PassportRequestStatus status) {
  switch (status) {
    case PassportRequestStatus.pending:
      return EPassportColors.pending;
    case PassportRequestStatus.approved:
    case PassportRequestStatus.completed:
      return EPassportColors.approved;
    case PassportRequestStatus.rejected:
      return EPassportColors.rejected;
  }
}

IconData requestStatusIcon(PassportRequestStatus status) {
  switch (status) {
    case PassportRequestStatus.pending:
      return Icons.access_time_rounded;
    case PassportRequestStatus.approved:
    case PassportRequestStatus.completed:
      return Icons.check_circle_outline_rounded;
    case PassportRequestStatus.rejected:
      return Icons.cancel_outlined;
  }
}

class RequestStatusBadge extends StatelessWidget {
  const RequestStatusBadge({super.key, required this.status});

  final PassportRequestStatus status;

  @override
  Widget build(BuildContext context) {
    return StatusBadge(
      label: status.label,
      color: requestStatusColor(status),
      icon: requestStatusIcon(status),
    );
  }
}
