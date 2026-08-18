import 'package:flutter/material.dart';

/// Centralized PULSE type scale. Strong hierarchy, large numbers,
/// minimal font weights, comfortable spacing.
class PulseTypography {
  PulseTypography._();

  static const String fontFamily = 'SFProDisplay'; // falls back to system

  static TextTheme textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 48, fontWeight: FontWeight.w700, color: primary, height: 1.05, letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        fontSize: 34, fontWeight: FontWeight.w700, color: primary, height: 1.1, letterSpacing: -0.5,
      ),
      headlineMedium: TextStyle(
        fontSize: 24, fontWeight: FontWeight.w600, color: primary, height: 1.2,
      ),
      titleLarge: TextStyle(
        fontSize: 20, fontWeight: FontWeight.w600, color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w600, color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16, fontWeight: FontWeight.w400, color: primary, height: 1.4,
      ),
      bodyMedium: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w400, color: secondary, height: 1.4,
      ),
      labelLarge: TextStyle(
        fontSize: 14, fontWeight: FontWeight.w600, color: primary,
      ),
      labelSmall: TextStyle(
        fontSize: 12, fontWeight: FontWeight.w500, color: secondary,
      ),
    );
  }
}
