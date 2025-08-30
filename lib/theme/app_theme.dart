import 'package:flutter/material.dart';
import 'typography.dart';
import 'color.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    // Core Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.floatingActionButton,
      onPrimary: AppColors.container2Light,
      secondary: AppColors.primaryLight,
      onSecondary: AppColors.container2Light,
      surface: AppColors.backgroundLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceContainer: AppColors.containerLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      outline: AppColors.appBarBottomLight,
      outlineVariant: AppColors.placeHolderLight,
      error: AppColors.alertLight,
      onError: AppColors.container2Light,
    ),

    // Scaffold Background
    scaffoldBackgroundColor: AppColors.backgroundLight,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.backgroundLight,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.textPrimaryLight, size: 18),
      titleTextStyle: AppTypography.headlineLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondaryLight,
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: AppColors.labelLight,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.textPrimaryLight,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: AppColors.textSecondaryLight,
      ),
    ),

    //Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.container2Light,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.textPrimaryBorderLight, width: 1),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFliedFillLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.textPrimaryBorderLight),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.textPrimaryBorderLight),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryGreenLight, width: 2),
      ),
      hintStyle: TextStyle(color: AppColors.placeHolderLight),
      labelStyle: TextStyle(color: AppColors.labelLight),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreenLight,
        foregroundColor: AppColors.container2Light,
        elevation: 0,
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreenLight,
        side: BorderSide(color: AppColors.primaryGreenLight),
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryGreenLight,
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.floatingActionButton,
      foregroundColor: AppColors.container2Light,
      elevation: 4,
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.checkBoxSucessLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.container2Light),
      side: BorderSide(color: AppColors.textPrimaryBorderLight),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryGreenLight;
        }
        return AppColors.textPrimaryBorderLight;
      }),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryGreenLight;
        }
        return AppColors.placeHolderLight;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryGreenLight.withOpacity(0.3);
        }
        return AppColors.textPrimaryBorderLight;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryGreenLight,
      linearTrackColor: AppColors.emptyProgressBarLight,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.container2Light,
      selectedItemColor: AppColors.primaryGreenLight,
      unselectedItemColor: AppColors.labelLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.textPrimaryBorderLight,
      thickness: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    // Core Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.floatingActionButton,
      onPrimary: AppColors.primaryDark,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.backgroundDark,
      surface: AppColors.backgroundDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainer: AppColors.containerDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.appBarBottomDark,

      outlineVariant: AppColors.placeHolderDark,
      error: AppColors.alertDark,
      onError: AppColors.textPrimaryDark,
    ),

    // Scaffold Background
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // AppBar Theme
    appBarTheme: AppBarTheme(
      elevation: 0,
      centerTitle: false,
      backgroundColor: AppColors.backgroundDark,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.textPrimaryDark, size: 18),
      titleTextStyle: AppTypography.headlineLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
    ),

    // Text Theme
    textTheme: TextTheme(
      headlineLarge: AppTypography.headlineLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      headlineMedium: AppTypography.headlineMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyLarge: AppTypography.bodyLarge.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      bodyMedium: AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      labelSmall: AppTypography.labelSmall.copyWith(
        color: AppColors.labelLDark,
      ),
      titleMedium: AppTypography.titleMedium.copyWith(
        color: AppColors.textPrimaryDark,
      ),
      titleSmall: AppTypography.titleSmall.copyWith(
        color: AppColors.textSecondaryDark,
      ),
    ),

    // Card Theme
    cardTheme: CardThemeData(
      elevation: 0,
      color: AppColors.containerDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFliedFillDark,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.textPrimaryBorderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.textPrimaryBorderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.primaryGreenDark, width: 2),
      ),
      hintStyle: TextStyle(color: AppColors.placeHolderDark),
      labelStyle: TextStyle(color: AppColors.labelLDark),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreenDark,
        foregroundColor: AppColors.backgroundDark,
        elevation: 0,
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryGreenDark,
        side: BorderSide(color: AppColors.primaryGreenDark),
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryGreenDark,
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.floatingActionButton,
      foregroundColor: AppColors.container2Light,

      elevation: 4,
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.checkBoxSucessDark;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.backgroundDark),
      side: BorderSide(color: AppColors.textPrimaryBorderDark),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryGreenDark;
        }
        return AppColors.textPrimaryBorderDark;
      }),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryGreenDark;
        }
        return AppColors.placeHolderDark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryGreenDark.withOpacity(0.3);
        }
        return AppColors.textPrimaryBorderDark;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryGreenDark,
      linearTrackColor: AppColors.emptyProgressBarDark,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.containerDark,
      selectedItemColor: AppColors.primaryGreenDark,
      unselectedItemColor: AppColors.labelLDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.textPrimaryBorderDark,
      thickness: 1,
    ),
  );
}

// Custom extension methods for specialized colors
