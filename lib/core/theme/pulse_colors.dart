import 'package:flutter/material.dart';

/// PULSE brand palette.
/// Direction: deep graphite / near-black, cool blue, soft violet, white,
/// subtle glow, glass-inspired surfaces.
class PulseColors {
  PulseColors._();

  // Brand core
  static const Color pulseBlue = Color(0xFF4C7BFF);
  static const Color pulseViolet = Color(0xFF8A6CFF);
  static const Color pulseGlow = Color(0xFF6FA8FF);

  // Light mode
  static const Color lightBackground = Color(0xFFFAFAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceAlt = Color(0xFFF2F3F7);
  static const Color lightBorder = Color(0xFFE7E8EF);
  static const Color lightTextPrimary = Color(0xFF14151A);
  static const Color lightTextSecondary = Color(0xFF6C6F7C);

  // Dark mode
  static const Color darkBackground = Color(0xFF0B0C10);
  static const Color darkSurface = Color(0xFF16171D);
  static const Color darkSurfaceAlt = Color(0xFF1D1F27);
  static const Color darkBorder = Color(0xFF2A2C36);
  static const Color darkTextPrimary = Color(0xFFF5F6FA);
  static const Color darkTextSecondary = Color(0xFFA0A3B1);

  // Semantic
  static const Color success = Color(0xFF3DD68C);
  static const Color warning = Color(0xFFF5B546);
  static const Color danger = Color(0xFFFF6B6B);

  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [pulseBlue, pulseViolet],
  );
}
