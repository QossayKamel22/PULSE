import 'package:flutter/material.dart';
import 'pulse_colors.dart';
import 'pulse_typography.dart';
import 'pulse_spacing.dart';

/// PULSE light and dark ThemeData. All screens must consume these —
/// do not hardcode colors/styles inside widgets.
class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(
        brightness: Brightness.light,
        background: PulseColors.lightBackground,
        surface: PulseColors.lightSurface,
        surfaceAlt: PulseColors.lightSurfaceAlt,
        border: PulseColors.lightBorder,
        textPrimary: PulseColors.lightTextPrimary,
        textSecondary: PulseColors.lightTextSecondary,
      );

  static ThemeData get dark => _build(
        brightness: Brightness.dark,
        background: PulseColors.darkBackground,
        surface: PulseColors.darkSurface,
        surfaceAlt: PulseColors.darkSurfaceAlt,
        border: PulseColors.darkBorder,
        textPrimary: PulseColors.darkTextPrimary,
        textSecondary: PulseColors.darkTextSecondary,
      );

  static ThemeData _build({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color surfaceAlt,
    required Color border,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: PulseColors.pulseBlue,
      onPrimary: Colors.white,
      secondary: PulseColors.pulseViolet,
      onSecondary: Colors.white,
      error: PulseColors.danger,
      onError: Colors.white,
      surface: surface,
      onSurface: textPrimary,
    );

    return ThemeData(
      brightness: brightness,
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: background,
      textTheme: PulseTypography.textTheme(textPrimary, textSecondary),
      dividerColor: border,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(PulseRadius.lg),
          side: BorderSide(color: border),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: PulseColors.pulseBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: PulseSpacing.lg, vertical: PulseSpacing.md),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(PulseRadius.md)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: PulseSpacing.md, vertical: PulseSpacing.md),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PulseRadius.md),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PulseRadius.md),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(PulseRadius.md),
          borderSide: const BorderSide(color: PulseColors.pulseBlue, width: 1.5),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(PulseRadius.xl)),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: PulseColors.pulseBlue.withValues(alpha: 0.15),
        elevation: 0,
      ),
    );
  }
}
