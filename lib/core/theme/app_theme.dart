import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFFF5F5F5);
  static const Color accentColor = Color(0xFFFF5722);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color backgroundColor = Color(0xFFFAFAFA);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.light(
        primary: accentColor,
        onPrimary: Colors.white,
        secondary: primaryColor,
        onSecondary: Colors.white,
        surface: surfaceColor,
        onSurface: Colors.black87,
        background: backgroundColor,
        onBackground: Colors.black87,
        error: Colors.red,
        onError: Colors.white,
        outline: Colors.grey[400]!,
        shadow: Colors.black26,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge:
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        headlineMedium:
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        headlineSmall:
        TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        titleMedium:
        TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(color: Colors.black87, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(color: Colors.black87),
        bodyMedium: TextStyle(color: Colors.black54),
        bodySmall: TextStyle(color: Colors.black45),
        labelLarge: TextStyle(color: Colors.black87),
        labelMedium: TextStyle(color: Colors.black54),
        labelSmall: TextStyle(color: Colors.black45),
      ),
      iconTheme: const IconThemeData(
        color: Colors.black54,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: secondaryColor,
        selectedColor: accentColor,
        disabledColor: Colors.grey[300]!,
        labelStyle: const TextStyle(color: Colors.black87),
        brightness: Brightness.light,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor),
        ),
        hintStyle: const TextStyle(color: Colors.black45),
        labelStyle: const TextStyle(color: Colors.black54),
        prefixIconColor: Colors.black54,
        suffixIconColor: Colors.black54,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: Colors.grey[800]!,
        contentTextStyle: const TextStyle(color: Colors.white),
        actionTextColor: accentColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}