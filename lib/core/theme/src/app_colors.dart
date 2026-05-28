import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  AppColors._();

  // --- BRAND COLORS ---
  static const Color primary = Color(0xFF58A6F0);
  static const Color secondary = Color(0xFFFFB74D);
  static const Color accent = Color(0xFF1976D2);

  // --- LIGHT THEME PALETTE ---
  static const Color backgroundLight = Color(0xFFF6E9E1);
  static const Color surfaceLight = Colors.white;
  static const Color cardLight = Color(0xFFFFEFD6);
  static const Color textPrimaryLight = Color(0xFF1F1B18);
  static const Color textSecondaryLight = Color(0xFF6B6B6B);

  // --- DARK THEME PALETTE ---
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1F1F1F);
  static const Color cardDark = Color(0xFF2C2C2C);
  static const Color textPrimaryDark = Colors.white;
  static const Color textSecondaryDark = Color(0xFFB0B0B0);

  // --- FEATURE SPECIFIC COLORS (Standardized) ---
  static const Color moodSad = Color(0xFFBDF2B8);
  static const Color moodAngry = Color(0xFFD6BDF2);
  static const Color moodCalm = Color(0xFFBCDFF2);
  static const Color moodHappy = Color(0xFFFFF7C2);
}
