import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// [AppTextStyles] menyediakan tipografi yang ramah dan terbaca.
/// 
/// Rationale: Menggunakan 'Nunito' karena bentuknya yang rounded memberikan
/// kesan psikologis yang lebih ramah dan menenangkan bagi pengguna.
class AppTextStyles {
  AppTextStyles._();

  static TextTheme getTextTheme(Color textColor) {
    return GoogleFonts.nunitoTextTheme(
      TextTheme(
        displayLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w800,
          color: textColor,
          letterSpacing: -0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        titleLarge: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          color: textColor,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          color: textColor,
          height: 1.4,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          color: textColor.withValues(alpha: 0.7),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
