import 'package:flutter/material.dart';

/// Colors taken from the Kavya design (dark glass look).
class KColors {
  static const bg = Color(0xFF0B1030);
  static const accent = Color(0xFF5B8CFF);
  static const accentSoft = Color(0xFFBFD3FF);
  static const violet = Color(0xFF8B7BFF);
  static const text = Color(0xFFEEF2FF);
  static const muted = Color(0xFF9AA6D0);
  static const green = Color(0xFF4ADE9A);
  static const coral = Color(0xFFFF6B8B);
  static const amber = Color(0xFFFFC857);
  static const glass = Color(0x0FFFFFFF); // white 6%
  static const glassBorder = Color(0x1FFFFFFF); // white 12%
}

ThemeData kavyaTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    scaffoldBackgroundColor: KColors.bg,
    colorScheme: const ColorScheme.dark(
      primary: KColors.accent,
      surface: KColors.bg,
    ),
    textTheme: base.textTheme.apply(
      bodyColor: KColors.text,
      displayColor: KColors.text,
    ),
  );
}
