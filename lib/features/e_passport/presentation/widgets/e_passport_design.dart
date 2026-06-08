import 'package:flutter/material.dart';

class EPassportColors {
  const EPassportColors._();

  static const Color pageBackground = Color(0xFFF4F7FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSoft = Color(0xFFF8FAFC);
  static const Color border = Color(0xFFE5E7EB);
  static const Color ink = Color(0xFF111827);
  static const Color muted = Color(0xFF6B7280);
  static const Color darkBlue = Color(0xFF071B33);
  static const Color officialBlue = Color(0xFF0E315B);
  static const Color gold = Color(0xFFC49A3A);
  static const Color red = Color(0xFFD71920);
  static const Color pending = Color(0xFFD99A1E);
  static const Color approved = Color(0xFF16A34A);
  static const Color rejected = Color(0xFFDC2626);
  static const Color securityBackground = Color(0xFFF0FBF5);
  static const Color activeNavBackground = Color(0xFFF8EFE1);
  static const Color infoBackground = Color(0xFFEFF6FF);

  /// Status palette (EGY-001): Amber = pending, Green = approved/completed, Red = rejected.
  static const Map<String, Color> statusPalette = {
    'pending': pending,
    'approved': approved,
    'completed': approved,
    'rejected': rejected,
    'verified': approved,
    'optional': officialBlue,
  };
}

class EPassportTextStyles {
  const EPassportTextStyles._();

  static const String fontFamily = 'Cairo';

  static TextStyle title(double size) {
    return TextStyle(
      color: EPassportColors.ink,
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: FontWeight.w700,
      height: 1.35,
    );
  }

  static TextStyle body({
    double size = 13,
    Color color = EPassportColors.ink,
    FontWeight weight = FontWeight.w600,
  }) {
    return TextStyle(
      color: color,
      fontFamily: fontFamily,
      fontSize: size,
      fontWeight: weight,
      height: 1.45,
    );
  }
}
