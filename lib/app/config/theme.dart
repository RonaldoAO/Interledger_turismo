import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colores principales
  static const Color primaryBlue = Color(0xFF2A85FF);
  static const Color darkBlue = Color(0xFF1D5EBE);
  static const Color lightBlue = Color(0xFFEBF5FF);
  
  // Grises
  static const Color lightGray = Color(0xFFF7F9FC);
  static const Color mediumGray = Color(0xFFE9EDF5);
  static const Color darkGray = Color(0xFF6F767E);
  static const Color textDark = Color(0xFF1A1D1F);
  
  // Estados
  static const Color success = Color(0xFF58C27D);
  static const Color pending = Color(0xFFFFB547);
  static const Color error = Color(0xFFFF6A55);

  // Gradientes
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryBlue, darkBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      primary: primaryBlue,
      secondary: darkBlue,
      background: Colors.white,
      surface: Colors.white,
      error: error,
    ),
    scaffoldBackgroundColor: lightGray,
    fontFamily: GoogleFonts.inter().fontFamily,
    
    // AppBar
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: textDark,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: textDark,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
      iconTheme: IconThemeData(
        color: textDark,
        size: 24,
      ),
    ),
    
    // Botones
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
          letterSpacing: 0.2,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: 'Inter',
        ),
      ),
    ),
    
    // Tarjetas
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
    ),
    
    // Campos de entrada
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mediumGray, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: mediumGray, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primaryBlue, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: error, width: 1),
      ),
      hintStyle: TextStyle(
        color: darkGray,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      labelStyle: TextStyle(
        color: darkGray,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    
    // Navigation Bar
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: lightBlue,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Inter',
        ),
      ),
      iconTheme: MaterialStateProperty.all(
        const IconThemeData(
          size: 22,
        ),
      ),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
    ),
    
    // Chips para categorías y filtros
    chipTheme: ChipThemeData(
      backgroundColor: lightGray,
      selectedColor: lightBlue,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelStyle: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}