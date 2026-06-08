import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:flutter/material.dart';

class PassportCoverCard extends StatelessWidget {
  const PassportCoverCard({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 0.72,
      child: Container(
        constraints: BoxConstraints(
          minWidth: compact ? 64 : 78,
          maxWidth: compact ? 76 : 96,
        ),
        padding: EdgeInsets.all(compact ? 8 : 10),
        decoration: BoxDecoration(
          color: EPassportColors.darkBlue,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FittedBox(
              child: Text(
                'جمهورية مصر العربية',
                style: EPassportTextStyles.body(
                  size: 9,
                  color: EPassportColors.gold,
                  weight: FontWeight.w800,
                ),
              ),
            ),
            const Icon(
              Icons.workspace_premium_rounded,
              color: EPassportColors.gold,
              size: 32,
            ),
            Column(
              children: [
                Text(
                  'جواز سفر',
                  style: EPassportTextStyles.body(
                    size: compact ? 9 : 10,
                    color: EPassportColors.gold,
                    weight: FontWeight.w800,
                  ),
                ),
                Text(
                  'PASSPORT',
                  style: EPassportTextStyles.body(
                    size: compact ? 7 : 8,
                    color: EPassportColors.gold,
                    weight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
