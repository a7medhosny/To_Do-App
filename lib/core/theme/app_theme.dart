import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:todo_app/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData getAppTheme() {
    return ThemeData(
      //scaffold theme
      scaffoldBackgroundColor: AppColors.background,
      //primary color
      primaryColor: AppColors.primary,
      //button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      //text theme
      textTheme: TextTheme(
        displayLarge: GoogleFonts.lato(
          color: AppColors.white,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        displayMedium: GoogleFonts.lato(
          color: AppColors.white,
          fontSize: 16,
        ),
        displaySmall: GoogleFonts.lato(
          color: AppColors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}
