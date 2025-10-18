import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:math';

class ThemeGenerator {
  // RESKIN ENGINE - Change this number to completely reskin the app
  static const int themeNumber = 1;
  
  static ThemeData generateTheme(int themeNumber) {
    final palette = _generateColorPalette(themeNumber);
    final layout = _generateLayoutConfig(themeNumber);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: Brightness.dark,
        primary: palette.primary,
        secondary: palette.accent,
        surface: palette.surface,
        onSurface: palette.onSurface,
        onPrimary: palette.textOnPrimary,
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        primaryColor: palette.primary,
        scaffoldBackgroundColor: palette.background,
        barBackgroundColor: palette.background,
        textTheme: CupertinoTextThemeData(
          primaryColor: palette.text,
          textStyle: TextStyle(
            color: palette.text,
            fontSize: layout.bodyFontSize,
          ),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: palette.surface,
        foregroundColor: palette.onSurface,
        elevation: layout.appBarElevation,
        centerTitle: layout.centerTitle,
        titleTextStyle: TextStyle(
          fontSize: layout.titleFontSize,
          fontWeight: FontWeight.bold,
          color: palette.onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: layout.cardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(layout.cardRadius),
        ),
        color: palette.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
          foregroundColor: palette.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(layout.buttonRadius),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: layout.buttonPadding,
            vertical: layout.buttonPadding / 2,
          ),
        ),
      ),
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          fontSize: layout.headlineFontSize,
          fontWeight: FontWeight.bold,
          color: palette.onSurface,
        ),
        headlineMedium: TextStyle(
          fontSize: layout.headlineFontSize * 0.8,
          fontWeight: FontWeight.w600,
          color: palette.onSurface,
        ),
        headlineSmall: TextStyle(
          fontSize: layout.headlineFontSize * 0.7,
          fontWeight: FontWeight.w600,
          color: palette.onSurface,
        ),
        bodyLarge: TextStyle(
          fontSize: layout.bodyFontSize,
          color: palette.onSurface,
        ),
        bodyMedium: TextStyle(
          fontSize: layout.bodyFontSize * 0.9,
          color: palette.onSurface,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(layout.inputRadius),
        ),
        filled: true,
        fillColor: palette.inputBackground,
      ),
    );
  }
  
  static ColorPalette _generateColorPalette(int themeNumber) {
    // Use purple/violet theme from the picture
    final primary = const Color(0xFF6C5CE7); // Vibrant purple
    final accent = const Color(0xFF8B7FF4); // Lighter purple
    
    return ColorPalette(
      primary: primary,
      accent: accent,
      background: _generateBackgroundColor(themeNumber),
      surface: _generateSurfaceColor(themeNumber),
      cardBackground: _generateCardColor(themeNumber),
      text: _generateTextColor(themeNumber),
      onSurface: const Color(0xFFE5E5E5),
      textOnPrimary: Colors.white,
      inputBackground: _generateInputColor(themeNumber),
    );
  }
  
  static LayoutConfig _generateLayoutConfig(int themeNumber) {
    final random = Random(themeNumber);
    
    return LayoutConfig(
      cardRadius: 8.0 + (random.nextDouble() * 12.0),
      buttonRadius: 6.0 + (random.nextDouble() * 10.0),
      inputRadius: 4.0 + (random.nextDouble() * 8.0),
      cardElevation: 2.0 + (random.nextDouble() * 6.0),
      appBarElevation: 1.0 + (random.nextDouble() * 3.0),
      centerTitle: random.nextBool(),
      titleFontSize: 18.0 + (random.nextDouble() * 4.0),
      headlineFontSize: 24.0 + (random.nextDouble() * 8.0),
      bodyFontSize: 14.0 + (random.nextDouble() * 2.0),
      buttonPadding: 12.0 + (random.nextDouble() * 8.0),
    );
  }
  
  static Color _generateBackgroundColor(int themeNumber) {
    // Dark background for dark theme
    return const Color(0xFF1A1A1A);
  }
  
  static Color _generateSurfaceColor(int themeNumber) {
    // Slightly lighter surface for dark theme
    return const Color(0xFF2A2A2A);
  }
  
  static Color _generateCardColor(int themeNumber) {
    // Card color for dark theme
    return const Color(0xFF2A2A2A);
  }
  
  static Color _generateTextColor(int themeNumber) {
    // Light text for dark theme
    return const Color(0xFFE5E5E5);
  }
  
  static Color _generateInputColor(int themeNumber) {
    // Input background for dark theme
    return const Color(0xFF2A2A2A);
  }
  
  static Gradient generateGradient(int themeNumber) {
    final palette = _generateColorPalette(themeNumber);
    
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [palette.primary, palette.accent],
    );
  }
}

class ColorPalette {
  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color cardBackground;
  final Color text;
  final Color onSurface;
  final Color textOnPrimary;
  final Color inputBackground;
  
  ColorPalette({
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.cardBackground,
    required this.text,
    required this.onSurface,
    required this.textOnPrimary,
    required this.inputBackground,
  });
}

class LayoutConfig {
  final double cardRadius;
  final double buttonRadius;
  final double inputRadius;
  final double cardElevation;
  final double appBarElevation;
  final bool centerTitle;
  final double titleFontSize;
  final double headlineFontSize;
  final double bodyFontSize;
  final double buttonPadding;
  
  LayoutConfig({
    required this.cardRadius,
    required this.buttonRadius,
    required this.inputRadius,
    required this.cardElevation,
    required this.appBarElevation,
    required this.centerTitle,
    required this.titleFontSize,
    required this.headlineFontSize,
    required this.bodyFontSize,
    required this.buttonPadding,
  });
}
