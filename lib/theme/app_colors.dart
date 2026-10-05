import 'package:flutter/material.dart';

abstract final class AppColors {
  AppColors._();

  // Core background and surfaces
  static const Color background = Color(0xFFFAFAFA); // Off-white
  static const Color surface = Color(0xFFFFFFFF); // White cards
  static const Color formFill = Color(0xFFF4F4F4); // Subtle grey fill for forms

  // Text colors
  static const Color textPrimary = Color(0xFF111111);
  static const Color textSecondary = Color(0xFF666666);

  // Borders
  static const Color border = Color(0xFFE5E5E5);

  // Primary accent
  static const Color accent = Color(0xFFFF5A26); // Orange

  // Base colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Semantic Status colors (for ThemeExtension)
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Backward compatibility aliases
  static const Color shadowDark = Color(0x1A000000);
  static const Color slate50 = Color(0xFFF8FAFC);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate900 = Color(0xFF0F172A);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color navy700 = Color(0xFF334155);
  static const Color navy800 = Color(0xFF1E293B);
  static const Color navy900 = Color(0xFF132237);
  static const Color navy950 = Color(0xFF0F172A);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color indigo400 = Color(0xFF6366F1);
  static const Color violet500 = Color(0xFF8B5CF6);
  static const Color violet700 = Color(0xFF6D28D9);
  static const Color amber100 = Color(0xFFFEF3C7);
  static const Color amber300 = Color(0xFFFCD34D);
  static const Color amber400 = Color(0xFFFBBF24);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber600 = Color(0xFFD97706);
  static const Color amber700 = Color(0xFFB45309);
  static const Color emerald400 = Color(0xFF34D399);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald900 = Color(0xFF064E3B);
  static const Color cyan400 = Color(0xFF22D3EE);
  static const Color cyan500 = Color(0xFF06B6D4);
  static const Color red500 = Color(0xFFEF4444);
  static const Color violet50 = Color(0xFFF5F3FF);
  static const Color violet300 = Color(0xFFC4B5FD);
  static const Color emerald50 = Color(0xFFECFDF5);
  static const Color emerald100 = Color(0xFFDCFCE7);
  static const Color blue700 = Color(0xFF1D4ED8);
}
