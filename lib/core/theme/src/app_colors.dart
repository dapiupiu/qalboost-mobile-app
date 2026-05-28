import 'package:flutter/material.dart';

/// [AppColors] mendefinisikan palet warna yang menenangkan untuk aplikasi kesehatan mental.
/// 
/// Rationale: Menggunakan warna-warna pastel dan soft gradients untuk mengurangi
/// stres visual bagi pengguna.
class AppColors {
  AppColors._();

  // --- BRAND COLORS ---
  static const Color primary = Color(0xFF58A6F0);
  static const Color primaryLight = Color(0xFFD7EAF8);
  static const Color secondary = Color(0xFFFFB74D);
  static const Color accent = Color(0xFF1976D2);

  // --- GRADIENTS ---
  static const LinearGradient softBlueGradient = LinearGradient(
    colors: [Color(0xFF58A6F0), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFFFEFD6), Color(0xFFF6E9E1)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // --- LIGHT THEME PALETTE ---
  static const Color backgroundLight = Color(0xFFF6E9E1);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Color(0xFFFFEFD6);
  static const Color textPrimaryLight = Color(0xFF2E2A28);
  static const Color textSecondaryLight = Color(0xFF757575);

  // --- DARK THEME PALETTE ---
  static const Color backgroundDark = Color(0xFF0F172A); // Deep Navy instead of pure black
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  // --- MOOD COLORS ---
  static const Color moodSad = Color(0xFFBDF2B8);
  static const Color moodAngry = Color(0xFFD6BDF2);
  static const Color moodCalm = Color(0xFFBCDFF2);
  static const Color moodHappy = Color(0xFFFFF7C2);

  // Helper for transparency
  static Color withOpacity(Color color, double opacity) => color.withValues(alpha: opacity);
}
