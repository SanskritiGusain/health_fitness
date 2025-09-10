import 'package:flutter/material.dart';
import 'typography.dart';
import 'color.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,

    // Core Color Scheme
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryLight,
      onPrimary: AppColors.container2Light,
      secondary: AppColors.primaryLight,
      onSecondary: AppColors.container2Light,
      surface: AppColors.backgroundLight,
      onSurface: AppColors.textPrimaryLight,
      surfaceContainer: AppColors.containerLight,
      onSurfaceVariant: AppColors.textSecondaryLight,
      outline: AppColors.appBottomBarLight,
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
        color: AppColors.textPrimaryLight,fontSize: 20
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
      color: AppColors.textPrimaryLight,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
     
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFliedFillLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
       
      ),
      hintStyle: TextStyle(color: AppColors.placeHolderLight),
      labelStyle: TextStyle(color: AppColors.labelLight),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textPrimaryLight,
        foregroundColor: AppColors.container2Light,
        elevation: 0,
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),
////////
    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.container2Light,
        side: BorderSide(color: AppColors.textPrimaryLight),
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.textPrimaryLight, 

             foregroundColor: AppColors.textSecondaryLight,
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Floating Action Button Theme
floatingActionButtonTheme: FloatingActionButtonThemeData(
  // backgroundColor: Colors.transparent, // optional, if you set gradient inside FAB
  foregroundColor: AppColors.textPrimaryLight,
  elevation: 4,
),


    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.checkBoxSucessLight),
      side: BorderSide(color: AppColors.checkBoxSucessLight),
        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4), // optional: rounded corners
  ),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.textSecondaryLight;
      }),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.container2Light;
        }
        return AppColors.container2Light;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
            return AppColors.primaryLight;
              
        
        }
        return AppColors.toogleFieldLight;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryGreenLight,
      linearTrackColor: AppColors.emptyProgressBarLight,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundLight,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.labelLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.textFieldPrimaryLight,
      thickness: 1,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,

    // Core Color Scheme
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryDark,
      onPrimary: AppColors.container2Dark,
      secondary: AppColors.primaryDark,
      onSecondary: AppColors.container2Dark,
      surface: AppColors.backgroundDark,
      onSurface: AppColors.textPrimaryDark,
      surfaceContainer: AppColors.containerDark,
      onSurfaceVariant: AppColors.textSecondaryDark,
      outline: AppColors.appBottomBarDark,

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
        color: AppColors.textPrimaryDark,fontSize: 20
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
      color: AppColors.textPrimaryDark,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.textFliedFillDark,
      border: OutlineInputBorder(
         borderRadius: BorderRadius.circular(12),
        
      ),
      enabledBorder: OutlineInputBorder(
         borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      hintStyle: TextStyle(color: AppColors.placeHolderDark),
      labelStyle: TextStyle(color: AppColors.labelLDark),
    ),

    // Elevated Button Theme
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.textPrimaryDark,
        foregroundColor: AppColors.container2Dark,
        elevation: 0,
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Outlined Button Theme
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.container2Dark,
        side: BorderSide(color: AppColors.textPrimaryDark),
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
    ),

    // Text Button Theme
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(    backgroundColor: AppColors.textPrimaryDark,
                   foregroundColor: AppColors.textSecondaryDark,
 
        textStyle: AppTypography.titleMedium,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    // Floating Action Button Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: AppColors.textPrimaryDark,

      elevation: 4,
    ),

    // Checkbox Theme
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.checkBoxSucessDark),
      side: BorderSide(color: AppColors.checkBoxSucessDark),
             shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(4), // optional: rounded corners
  ),
    ),

    // Radio Theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryDark;
        }
        return AppColors.textSecondaryDark;
      }),
    ),

    // Switch Theme
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.container2Dark;
        }
        return AppColors.container2Dark;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
               return AppColors.primaryDark;
        }
           return AppColors.toogleFieldDark;
      }),
    ),

    // Progress Indicator Theme
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: AppColors.primaryGreenDark,
      linearTrackColor: AppColors.emptyProgressBarDark,
    ),

    // Bottom Navigation Bar Theme
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.backgroundDark,
      selectedItemColor: AppColors.primaryDark,
      unselectedItemColor: AppColors.labelLDark,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
    ),

    // Divider Theme
    dividerTheme: DividerThemeData(
      color: AppColors.textFieldPrimaryDark,
      thickness: 1,
    ),
  );
}

// Custom extension methods for specialized colors
