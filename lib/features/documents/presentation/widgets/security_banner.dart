import 'package:eg_passport_app/features/e_passport/presentation/widgets/e_passport_design.dart';
import 'package:flutter/material.dart';

class SecurityBanner extends StatelessWidget {
  const SecurityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: EPassportColors.securityBackground,
        border: Border.all(color: const Color(0xFFD4F3DF)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.verified_rounded,
            color: EPassportColors.approved,
            size: 21,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'جميع مستنداتك محمية وآمنة',
                  textAlign: TextAlign.center,
                  style: EPassportTextStyles.body(
                    size: 13,
                    color: const Color(0xFF166534),
                    weight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'يتم تشفير وحفظ جميع المستندات وفقاً لأعلى معايير الأمان',
                  textAlign: TextAlign.center,
                  style: EPassportTextStyles.body(
                    size: 11,
                    color: const Color(0xFF166534),
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
