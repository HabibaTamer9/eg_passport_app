import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:flutter/material.dart';

class RejectionReasonBox extends StatelessWidget {
  const RejectionReasonBox({
    super.key,
    required this.reason,
    this.compact = false,
  });

  final String reason;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 12 : 14,
        vertical: compact ? 10 : 12,
      ),
      decoration: BoxDecoration(
        color: EPassportColors.rejected.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: EPassportColors.rejected.withValues(alpha: 0.28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        textDirection: TextDirection.rtl,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: EPassportColors.rejected,
            size: compact ? 18 : 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'سبب الرفض',
                  textAlign: TextAlign.right,
                  style: EPassportTextStyles.body(
                    size: compact ? 11 : 12,
                    color: EPassportColors.rejected,
                    weight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reason,
                  textAlign: TextAlign.right,
                  style: EPassportTextStyles.body(
                    size: compact ? 11 : 12,
                    color: EPassportColors.ink,
                    weight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
