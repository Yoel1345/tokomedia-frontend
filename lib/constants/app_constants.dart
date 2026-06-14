import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF42B549);
  static const Color darkGreen = Color(0xFF2E7D32);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color accentGreen = Color(0xFF00880A);
  static const Color red = Color(0xFFE53935);
  static const Color orange = Color(0xFFFF6D00);
  static const Color pink = Color(0xFFE91E8C);
  static const Color mallPurple = Color(0xFF6B21A8);
  static const Color textDark = Color(0xFF212121);
  static const Color textMedium = Color(0xFF616161);
  static const Color textLight = Color(0xFF9E9E9E);
  static const Color border = Color(0xFFE0E0E0);
  static const Color background = Color(0xFFF5F5F5);
  static const Color white = Color(0xFFFFFFFF);
  static const Color discountRed = Color(0xFFE53935);
  static const Color bonusOrange = Color(0xFFFF8C00);
}

class AppTextStyles {
  static const TextStyle logoText = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
  );

  static const TextStyle heading = TextStyle(
    color: AppColors.textDark,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subheading = TextStyle(
    color: AppColors.textDark,
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.textMedium,
    fontSize: 13,
  );

  static const TextStyle price = TextStyle(
    color: AppColors.textDark,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle priceRed = TextStyle(
    color: AppColors.red,
    fontSize: 14,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle small = TextStyle(
    color: AppColors.textLight,
    fontSize: 11,
  );

  static const TextStyle smallGreen = TextStyle(
    color: AppColors.primaryGreen,
    fontSize: 11,
    fontWeight: FontWeight.w600,
  );
}
