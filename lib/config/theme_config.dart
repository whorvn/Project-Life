import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeConfig {
  // Color Schemes
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF1976D2),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFF03DAC6),
    onSecondary: Color(0xFF000000),
    tertiary: Color(0xFFFF6F00),
    onTertiary: Color(0xFFFFFFFF),
    error: Color(0xFFB00020),
    onError: Color(0xFFFFFFFF),
    background: Color(0xFFFAFAFA),
    onBackground: Color(0xFF000000),
    surface: Color(0xFFFFFFFF),
    onSurface: Color(0xFF000000),
    surfaceVariant: Color(0xFFF5F5F5),
    onSurfaceVariant: Color(0xFF424242),
    outline: Color(0xFFBDBDBD),
    shadow: Color(0xFF000000),
    inverseSurface: Color(0xFF121212),
    onInverseSurface: Color(0xFFFFFFFF),
    inversePrimary: Color(0xFF90CAF9),
  );

  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF90CAF9),
    onPrimary: Color(0xFF000000),
    secondary: Color(0xFF03DAC6),
    onSecondary: Color(0xFF000000),
    tertiary: Color(0xFFFFAB40),
    onTertiary: Color(0xFF000000),
    error: Color(0xFFCF6679),
    onError: Color(0xFF000000),
    background: Color(0xFF121212),
    onBackground: Color(0xFFFFFFFF),
    surface: Color(0xFF1E1E1E),
    onSurface: Color(0xFFFFFFFF),
    surfaceVariant: Color(0xFF2C2C2C),
    onSurfaceVariant: Color(0xFFE0E0E0),
    outline: Color(0xFF616161),
    shadow: Color(0xFF000000),
    inverseSurface: Color(0xFFFFFFFF),
    onInverseSurface: Color(0xFF000000),
    inversePrimary: Color(0xFF1976D2),
  );

  // Text Themes
  static TextTheme get _baseTextTheme => GoogleFonts.interTextTheme();

  static TextTheme get lightTextTheme => _baseTextTheme.copyWith(
    displayLarge: _baseTextTheme.displayLarge?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w300,
    ),
    displayMedium: _baseTextTheme.displayMedium?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: _baseTextTheme.displaySmall?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: _baseTextTheme.headlineLarge?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: _baseTextTheme.headlineSmall?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: _baseTextTheme.titleLarge?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: _baseTextTheme.titleMedium?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: _baseTextTheme.titleSmall?.copyWith(
      color: lightColorScheme.onBackground,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
      color: lightColorScheme.onBackground,
    ),
    bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
      color: lightColorScheme.onBackground,
    ),
    bodySmall: _baseTextTheme.bodySmall?.copyWith(
      color: lightColorScheme.onSurfaceVariant,
    ),
    labelLarge: _baseTextTheme.labelLarge?.copyWith(
      color: lightColorScheme.primary,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: _baseTextTheme.labelMedium?.copyWith(
      color: lightColorScheme.onSurfaceVariant,
    ),
    labelSmall: _baseTextTheme.labelSmall?.copyWith(
      color: lightColorScheme.onSurfaceVariant,
    ),
  );

  static TextTheme get darkTextTheme => _baseTextTheme.copyWith(
    displayLarge: _baseTextTheme.displayLarge?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w300,
    ),
    displayMedium: _baseTextTheme.displayMedium?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: _baseTextTheme.displaySmall?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: _baseTextTheme.headlineLarge?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: _baseTextTheme.headlineMedium?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: _baseTextTheme.headlineSmall?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: _baseTextTheme.titleLarge?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w500,
    ),
    titleMedium: _baseTextTheme.titleMedium?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: _baseTextTheme.titleSmall?.copyWith(
      color: darkColorScheme.onBackground,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: _baseTextTheme.bodyLarge?.copyWith(
      color: darkColorScheme.onBackground,
    ),
    bodyMedium: _baseTextTheme.bodyMedium?.copyWith(
      color: darkColorScheme.onBackground,
    ),
    bodySmall: _baseTextTheme.bodySmall?.copyWith(
      color: darkColorScheme.onSurfaceVariant,
    ),
    labelLarge: _baseTextTheme.labelLarge?.copyWith(
      color: darkColorScheme.primary,
      fontWeight: FontWeight.w500,
    ),
    labelMedium: _baseTextTheme.labelMedium?.copyWith(
      color: darkColorScheme.onSurfaceVariant,
    ),
    labelSmall: _baseTextTheme.labelSmall?.copyWith(
      color: darkColorScheme.onSurfaceVariant,
    ),
  );

  // Light Theme
  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    textTheme: lightTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: lightColorScheme.surface,
      foregroundColor: lightColorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: lightTextTheme.titleLarge,
    ),
    cardTheme: CardTheme(
      color: lightColorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightColorScheme.primary,
        foregroundColor: lightColorScheme.onPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: lightColorScheme.primary,
        side: BorderSide(color: lightColorScheme.outline),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: lightColorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightColorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightColorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightColorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: lightColorScheme.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: lightColorScheme.surface,
      selectedIconTheme: IconThemeData(color: lightColorScheme.primary),
      unselectedIconTheme: IconThemeData(color: lightColorScheme.onSurfaceVariant),
      selectedLabelTextStyle: lightTextTheme.labelMedium?.copyWith(
        color: lightColorScheme.primary,
      ),
      unselectedLabelTextStyle: lightTextTheme.labelMedium?.copyWith(
        color: lightColorScheme.onSurfaceVariant,
      ),
    ),
  );

  // Dark Theme
  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    textTheme: darkTextTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: darkColorScheme.surface,
      foregroundColor: darkColorScheme.onSurface,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: darkTextTheme.titleLarge,
    ),
    cardTheme: CardTheme(
      color: darkColorScheme.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: darkColorScheme.primary,
        side: BorderSide(color: darkColorScheme.outline),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: darkColorScheme.primary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkColorScheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: darkColorScheme.error),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
    navigationRailTheme: NavigationRailThemeData(
      backgroundColor: darkColorScheme.surface,
      selectedIconTheme: IconThemeData(color: darkColorScheme.primary),
      unselectedIconTheme: IconThemeData(color: darkColorScheme.onSurfaceVariant),
      selectedLabelTextStyle: darkTextTheme.labelMedium?.copyWith(
        color: darkColorScheme.primary,
      ),
      unselectedLabelTextStyle: darkTextTheme.labelMedium?.copyWith(
        color: darkColorScheme.onSurfaceVariant,
      ),
    ),
  );
}
