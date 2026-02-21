import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1D4ED8);

  // Alert Severity Colors
  static const Color critical = Color(0xFFDC2626);    // Red-600
  static const Color high = Color(0xFFEA580C);        // Orange-600
  static const Color medium = Color(0xFFEAB308);      // Yellow-500
  static const Color low = Color(0xFF16A34A);         // Green-600
  static const Color info = Color(0xFF2563EB);        // Blue-600

  static const Color gray50 = Color(0xFFF9FAFB);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.gray50,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryLight,
    scaffoldBackgroundColor: AppColors.gray900,
  );
}
