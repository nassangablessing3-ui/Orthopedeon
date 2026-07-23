import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Each screen has its own distinct gradient pair
  static const homeGrad    = [Color(0xFF1A0B3B), Color(0xFF4A1B8A)]; // Deep purple
  static const funGrad     = [Color(0xFFB45309), Color(0xFFD97706)]; // Amber/orange
  static const aiGrad      = [Color(0xFF0C4A6E), Color(0xFF0284C7)]; // Ocean blue
  static const careGrad    = [Color(0xFF064E3B), Color(0xFF059669)]; // Emerald green
  static const socialGrad  = [Color(0xFF831843), Color(0xFFDB2777)]; // Hot pink
  static const profileGrad = [Color(0xFF1E3A5F), Color(0xFF2563EB)]; // Royal blue
  static const voiceGrad   = [Color(0xFF4C0519), Color(0xFFBE123C)]; // Crimson red

  // Tab accent colours
  static const home    = Color(0xFF7C3AED);
  static const fun     = Color(0xFFD97706);
  static const ai      = Color(0xFF0284C7);
  static const care    = Color(0xFF059669);
  static const social  = Color(0xFFDB2777);
  static const profile = Color(0xFF2563EB);
}

class AppTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF7C3AED)),
    textTheme: GoogleFonts.poppinsTextTheme(),
    scaffoldBackgroundColor: const Color(0xFFF8F7FF),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF7C3AED), brightness: Brightness.dark),
    textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
  );
}
