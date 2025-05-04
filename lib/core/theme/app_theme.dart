import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Primary Colors
  static const _primaryColor = Color(0xFF2196F3);
  static const _primaryDark = Color(0xFF1976D2);
  static const _primaryLight = Color(0xFFBBDEFB);

  // Accent Colors
  static const _accentColor = Color(0xFFFF4081);
  static const _accentDark = Color(0xFFF50057);
  static const _accentLight = Color(0xFFFF80AB);

  // Secondary Colors
  static const _errorColor = Color(0xFFF44336);

  // Background Colors
  static const _surfaceColor = Color(0xFFFFFFFF);
  static const _backgroundColor = Color(0xFFF5F5F5);
  static const _cardColor = Color(0xFFFFFFFF);
  static const _dialogColor = Color(0xFFFFFFFF);

  // Text Colors
  static const _primaryTextColor = Color(0xFF212121);
  static const _secondaryTextColor = Color(0xFF757575);

  // Typography
  static TextTheme _buildTextTheme() {
    return GoogleFonts.robotoTextTheme().copyWith(
      displayLarge: GoogleFonts.roboto(
        fontSize: 96,
        fontWeight: FontWeight.w300,
      ),
      displayMedium: GoogleFonts.roboto(
        fontSize: 60,
        fontWeight: FontWeight.w300,
      ),
      displaySmall: GoogleFonts.roboto(
        fontSize: 48,
        fontWeight: FontWeight.w400,
      ),
      headlineMedium: GoogleFonts.roboto(
        fontSize: 34,
        fontWeight: FontWeight.w400,
      ),
      headlineSmall: GoogleFonts.roboto(
        fontSize: 24,
        fontWeight: FontWeight.w400,
      ),
      titleLarge: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.w500),
      titleMedium: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w400),
      bodyMedium: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w400),
      labelLarge: GoogleFonts.roboto(fontSize: 14, fontWeight: FontWeight.w500),
      bodySmall: GoogleFonts.roboto(fontSize: 12, fontWeight: FontWeight.w400),
      labelSmall: GoogleFonts.roboto(fontSize: 10, fontWeight: FontWeight.w400),
    );
  }

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: _primaryColor,
      onPrimary: _surfaceColor,
      primaryContainer: _primaryLight,
      secondary: _accentColor,
      onSecondary: _surfaceColor,
      secondaryContainer: _accentLight,
      error: _errorColor,
      onError: _surfaceColor,
      surface: _backgroundColor,
      onSurface: _primaryTextColor,
      surfaceContainerHighest: _cardColor,
      onSurfaceVariant: _secondaryTextColor,
    ),
    textTheme: _buildTextTheme(),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _surfaceColor,
      foregroundColor: _primaryTextColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size(36, 36),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(fontSize: 12, color: _secondaryTextColor),
      helperStyle: const TextStyle(fontSize: 12, color: _secondaryTextColor),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: _dialogColor,
    ),
    scaffoldBackgroundColor: Color(0xFF181A20),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF181A20),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      elevation: 0,
    ),
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.dark(
      primary: _primaryColor,
      onPrimary: _surfaceColor,
      primaryContainer: _primaryDark,
      secondary: _accentColor,
      onSecondary: _surfaceColor,
      secondaryContainer: _accentDark,
      error: _errorColor,
      onError: _surfaceColor,
      surface: _backgroundColor,
      onSurface: _primaryTextColor,
      surfaceContainerHighest: _cardColor,
      onSurfaceVariant: _secondaryTextColor,
    ),
    textTheme: _buildTextTheme(),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: _surfaceColor,
      foregroundColor: _primaryTextColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        minimumSize: const Size(36, 36),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(4)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      labelStyle: const TextStyle(fontSize: 12, color: _secondaryTextColor),
      helperStyle: const TextStyle(fontSize: 12, color: _secondaryTextColor),
    ),
    cardTheme: CardTheme(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.all(16),
    ),
    dialogTheme: DialogTheme(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      backgroundColor: _dialogColor,
    ),
    scaffoldBackgroundColor: Color(0xFF181A20),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF181A20),
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
      elevation: 0,
    ),
  );
}
