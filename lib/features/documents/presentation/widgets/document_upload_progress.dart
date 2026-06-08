import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:flutter/material.dart';

class DocumentUploadProgressBar extends StatelessWidget {
  const DocumentUploadProgressBar({
    super.key,
    required this.progress,
    this.compact = false,
  });

  final int progress;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    if (progress <= 0) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: EPassportColors.red,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'جاري الرفع...',
            style: EPassportTextStyles.body(
              size: compact ? 11 : 12,
              color: EPassportColors.muted,
              weight: FontWeight.w700,
            ),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(999),
                child: LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: compact ? 4 : 5,
                  backgroundColor: const Color(0xFFF1D4D5),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    EPassportColors.red,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            Text(
              '$progress%',
              style: EPassportTextStyles.body(
                size: compact ? 11 : 12,
                color: EPassportColors.red,
                weight: FontWeight.w800,
              ),
            ),
          ],
        ),
        if (!compact) ...[
          const SizedBox(height: 5),
          Text(
            'جاري الرفع...',
            textAlign: TextAlign.right,
            style: EPassportTextStyles.body(
              size: 11,
              color: EPassportColors.muted,
              weight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
