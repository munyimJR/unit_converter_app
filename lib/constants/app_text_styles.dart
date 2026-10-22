import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const TextStyle appBarTitle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.white,
    letterSpacing: 0.5,
  );

  static const TextStyle tabLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  static const TextStyle inputLabel = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textMedium,
    letterSpacing: 0.2,
  );

  static const TextStyle inputValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const TextStyle dropdownValue = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  static const TextStyle resultLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMedium,
    letterSpacing: 0.2,
  );

  static const TextStyle resultValue = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.resultValue,
    letterSpacing: 0.5,
  );

  static const TextStyle resultUnit = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.resultValue,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
  );
}
