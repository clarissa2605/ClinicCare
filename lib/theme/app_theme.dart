// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Sidebar & nav
  static const Color sidebar      = Color(0xFF2e3a32);
  static const Color sidebarHover = Color(0xFF3d4a41);
  static const Color activeNav    = Color(0xFF4a5e50);

  // Backgrounds
  static const Color ivory        = Color(0xFFF4F3F1);
  static const Color card         = Color(0xFFFAF9F7);

  // Brand greens
  static const Color evergreen    = Color(0xFF68756D);
  static const Color darkGreen    = Color(0xFF3d4a41);

  // Accent
  static const Color terracotta   = Color(0xFFB57B66);
  static const Color sage         = Color(0xFFA1A79E);
  static const Color blood        = Color(0xFFA63228);
  static const Color yellow       = Color(0xFFC9B84C);
  static const Color green        = Color(0xFF7A9B52);

  // Text
  static const Color textDark     = Color(0xFF2a3028);
  static const Color textMid      = Color(0xFF5a6358);
  static const Color textLight    = Color(0xFF8a9388);

  // Border
  static const Color border       = Color(0xFFDEDDD9);

  // Antrian / poli
  static const Color antrian      = Color(0xFF4a7fa5);
  static const Color poliUmum     = Color(0xFF5b8dd9);
  static const Color poliParu     = Color(0xFF3d4a41);
  static const Color poliTbc      = Color(0xFFB57B66);
  static const Color poliLab      = Color(0xFF7A9B52);
  static const Color poliRad      = Color(0xFF9b5b8d);

  // Light tints (avatar bg, badge bg)
  static const Color bloodLt      = Color(0xFFf2d5d3);
  static const Color terracottaLt = Color(0xFFf5e5df);
  static const Color yellowLt     = Color(0xFFf7f0d5);
  static const Color greenLt      = Color(0xFFdcefd6);
  static const Color sageLt       = Color(0xFFe8ebe8);
  static const Color blueLt       = Color(0xFFddeaf7);

  // Risk level → color
  static Color riskColor(String level) {
    switch (level) {
      case 'KRITIS': return blood;
      case 'Tinggi': return terracotta;
      case 'Sedang': return yellow;
      case 'Rendah': return green;
      default:       return sage;
    }
  }

  static Color riskLightColor(String level) {
    switch (level) {
      case 'KRITIS': return bloodLt;
      case 'Tinggi': return terracottaLt;
      case 'Sedang': return yellowLt;
      case 'Rendah': return greenLt;
      default:       return sageLt;
    }
  }

  static Color poliColor(String kode) {
    switch (kode) {
      case 'UMUM': return poliUmum;
      case 'PARU': return poliParu;
      case 'TBC' : return poliTbc;
      case 'LAB' : return poliLab;
      case 'RAD' : return poliRad;
      default:     return antrian;
    }
  }
}

class AppTheme {
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.ivory,
    colorScheme: ColorScheme.light(
      primary:    AppColors.darkGreen,
      secondary:  AppColors.terracotta,
      surface:    AppColors.card,
      background: AppColors.ivory,
      error:      AppColors.blood,
    ),
    textTheme: GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.playfairDisplay(
          fontWeight: FontWeight.bold, color: AppColors.textDark),
      titleLarge:  GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDark),
      titleMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textDark),
      bodyLarge:   GoogleFonts.inter(
          fontSize: 13, color: AppColors.textMid),
      bodyMedium:  GoogleFonts.inter(
          fontSize: 12, color: AppColors.textMid),
      labelSmall:  GoogleFonts.inter(
          fontSize: 10, color: AppColors.textLight),
    ),
    cardTheme: CardThemeData(
      color:     AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.border, width: 1),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.card,
      foregroundColor: AppColors.textDark,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.darkGreen, width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
      ),
    ),
    dividerTheme: DividerThemeData(color: AppColors.border, thickness: 1),
  );
}
